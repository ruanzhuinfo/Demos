//
//  ZEPageViewController.m
//  Demos
//
//  Created by taffy on 16/6/30.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "ZEPageViewController.h"
#import "ZEReadViewController.h"
#import "ZEBookViewModel.h"
#import "ZEPageViewController+Bar.h"

@interface ZEPageViewController() <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property(nonatomic)UIPageViewController *pageViewController;

@property(nonatomic)ZEBookViewModel *book;

@property(nonatomic)UITapGestureRecognizer *tap;

@end

@implementation ZEPageViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self.view setBackgroundColor:[UIColor whiteColor]];
	
	[self setupPageViewController];
	
	self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
	self.tap.delegate = self;
	[self.view addGestureRecognizer:self.tap];
	
	// 要放在最上层
	[self setupNavigationBar];
	[self setupToolBar];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	self.isHiddenStatusBar = YES;
}

- (void)setupPageViewController {
	self.pageViewController =
	[[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
									navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
												  options:nil];
	
	[self.pageViewController setViewControllers:@[[self viewControllerAtIndex:self.book.currentPage]]
									  direction:UIPageViewControllerNavigationDirectionForward
									   animated:YES
									 completion:nil];
	
	[self.pageViewController.view setFrame:self.view.bounds];
	
	self.pageViewController.dataSource = self;
	self.pageViewController.delegate = self;
	
	[self addChildViewController:self.pageViewController];
	[self.view addSubview:self.pageViewController.view];
	[self.pageViewController didMoveToParentViewController:self];
}

#pragma mark - pageViewcontroller dataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(ZEReadViewController *)viewController {
	
	NSInteger index = viewController.pageIndex;
	
	if (index == 0 || index == NSNotFound) {
		return nil;
	}
	
	// 上一页
	return [self viewControllerAtIndex:--index];
}

- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(ZEReadViewController *)viewController {
	
	NSInteger index = viewController.pageIndex;
	
	if (index >= self.book.pageCount || index == NSNotFound) {
		return nil;
	}
	
	// 下一页
	return [self viewControllerAtIndex:++index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
	
	self.isHiddenStatusBar = YES;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
	
	ZEReadViewController *vc = pageViewController.viewControllers.firstObject;
	if ([vc isKindOfClass:ZEReadViewController.class]) {
		// 在 model 中修改页码
		self.book.currentPage = vc.pageIndex;
	}
}

#pragma mark - private core method

- (void)setIsHiddenStatusBar:(BOOL)isHiddenStatusBar {
	_isHiddenStatusBar = isHiddenStatusBar;
	
	[self setNeedsStatusBarAppearanceUpdate];
	
	if (isHiddenStatusBar) {
		[self hiddenBar];
	} else {
		[self showBar];
	}
}

- (ZEBookViewModel *)book {
	if (_book) {
		return _book;
	}
	
	_book = [ZEBookViewModel new];
	
	return _book;
}

- (ZEReadViewController *)viewControllerAtIndex:(NSInteger)index {
	if (index < 0 || index == self.book.pageCount) {
		return nil;
	}
	
	ZEReadViewController *vc =
	[self.book chapterAtPageIndex:index completion:^(ZEChapter *chapter, NSInteger i) {
		return [ZEReadViewController newWithChapterModel:chapter pageIndex:i];
	}];
	
	if (vc) {
		vc.pageIndex = index;
		return vc;
	}
	
	return nil;
}

#pragma mark - gesture method

- (void)didTapView:(UITapGestureRecognizer *)tap {
	
	if (tap.state != UIGestureRecognizerStateEnded) {
		return;
	}
	
	if (self.isHiddenStatusBar) {
		CGPoint position = [tap locationInView:self.view];
		ZEReadViewController *vc = [self.pageViewController viewControllers].lastObject;
		
		if (position.x < self.view.width * 0.3) {
			if (vc.pageIndex == 0) {
				return;
			}
			
			[self.pageViewController setViewControllers:@[[self viewControllerAtIndex:--vc.pageIndex]]
											  direction:UIPageViewControllerNavigationDirectionReverse
											   animated:YES
											 completion:nil];
			return;
		}
		else if (position.x > self.view.width * 0.65) {
			if (vc.pageIndex == self.book.pageCount - 1) {
				return;
			}
			
			[self.pageViewController setViewControllers:@[[self viewControllerAtIndex:++vc.pageIndex]]
											  direction:UIPageViewControllerNavigationDirectionForward
											   animated:YES
											 completion:nil];
			return;
		}
		else {
			self.isHiddenStatusBar = NO;
		}
	} else {
		self.isHiddenStatusBar = YES;
	}
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return YES;
}

@end
