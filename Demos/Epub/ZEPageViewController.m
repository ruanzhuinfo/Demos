//
//  ZEPageViewController.m
//  Demos
//
//  Created by taffy on 16/6/30.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "ZEPageViewController.h"
#import "ZEPageViewController+Bar.h"

@interface ZEPageViewController() <UIPageViewControllerDelegate, UIPageViewControllerDataSource, ZEReadViewControllerDelegate>



@property(nonatomic)UITapGestureRecognizer *tap;

@end

@implementation ZEPageViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self.view setBackgroundColor:[UIColor whiteColor]];
	
	[self setupPageViewController];
	
	// 要放在最上层
	[self setupNavigationBar];
	[self setupToolBar];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(changeCurrentPageNotifcation:)
												 name:kPageViewControllerChangePageNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didEnterBacgroundNotification)
												 name:UIApplicationDidEnterBackgroundNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(scrollMarkedPageNotification:)
												 name:kPageViewControllerScrollMarkedPageNotification
											   object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self.navigationController.navigationBar setHidden:YES];
	[self setIsHiddenStatusBar:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	// 数据本地化
	[self didEnterBacgroundNotification];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupPageViewController {
	self.pageViewController =
	[[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
									navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
												  options:nil];

	[self showViewControllerAtIndex:self.book.currentPage animation:YES];
	
	[self.pageViewController.view setFrame:self.view.bounds];
	
	self.pageViewController.dataSource = self;
	self.pageViewController.delegate = self;
	
	[self addChildViewController:self.pageViewController];
	[self.view addSubview:self.pageViewController.view];
	[self.pageViewController didMoveToParentViewController:self];
	
	self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
	self.tap.delegate = self;
	[self.pageViewController.view addGestureRecognizer:self.tap];
}

#pragma mark - pageViewcontroller dataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
	  viewControllerBeforeViewController:(ZEReadViewController *)viewController {
	
	NSInteger index = viewController.currentPage;
	
	if (index == 0 || index == NSNotFound) {
		return nil;
	}
	
	// 上一页
	return [self viewControllerAtIndex:--index];
}

- (UIViewController*)pageViewController:(UIPageViewController *)pageViewController
	  viewControllerAfterViewController:(ZEReadViewController *)viewController {
	
	NSInteger index = viewController.currentPage;
	
	if (index >= self.book.pageCount - 1 || index == NSNotFound) {
		return nil;
	}
	
	// 下一页
	return [self viewControllerAtIndex:++index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController
willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
	
	self.isHiddenStatusBar = YES;
}

- (void)pageViewController:(UIPageViewController *)pageViewController
		didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
	   transitionCompleted:(BOOL)completed {
	
	ZEReadViewController *vc = pageViewController.viewControllers.firstObject;
	if ([vc isKindOfClass:ZEReadViewController.class]) {
		// 在 model 中修改页码
		self.book.currentPage = vc.currentPage;
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
		vc.currentPage = index;
		vc.delegate = self;
		vc.isMark = [self.book isMarkWithCurrentPage:vc.currentPage];
		vc.book = self.book.book;
		[vc updateBottomInfoWithPageCount:self.book.pageCount bookTitle:self.book.book.title];
		return vc;
	}
	
	return nil;
}

- (void)showViewControllerAtIndex:(NSInteger)index animation:(BOOL)animation {
	
	ZEReadViewController *vc = [self.pageViewController viewControllers].lastObject;
	
	UIPageViewControllerNavigationDirection direction =
	index >= vc.currentPage ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
	
	self.book.currentPage = index;
	
	[self.pageViewController setViewControllers:@[[self viewControllerAtIndex:index]]
									  direction:direction
									   animated:animation
									 completion:nil];
}

#pragma mark - gesture method

- (void)didTapView:(UITapGestureRecognizer *)tap {
	
	if (tap.state != UIGestureRecognizerStateEnded) {
		return;
	}
	
	if (self.isHiddenStatusBar) {
		CGPoint position = [tap locationInView:self.view];
		ZEReadViewController *vc = [self.pageViewController viewControllers].lastObject;
		
		if (position.x < self.view.width * 0.25) {
			if (vc.currentPage == 0) {
				return;
			}
			
			[self showViewControllerAtIndex:vc.currentPage - 1 animation:YES];
			return;
		}
		else if (position.x > self.view.width * 0.75) {
			if (vc.currentPage >= self.book.pageCount - 1) {
				return;
			}
			
			[self showViewControllerAtIndex:vc.currentPage + 1 animation:YES];
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

#pragma mark - ZEReadViewControllerDelegate

- (void)didTapMarkButton:(ZEReadViewController *)viewController {
	viewController.isMark = NO;
	[self.book removeMarkWithCurrentPage:viewController.currentPage];
}

- (void)didEndDragScrollViewFinished:(ZEReadViewController *)viewController {
	viewController.isMark = !viewController.isMark;
	
	if (viewController.isMark) {
		[self.book appendMarkWithCurrentPage:viewController.currentPage];
	} else {
		[self.book removeMarkWithCurrentPage:viewController.currentPage];
	}
	
	[self updateNavigationBarMarkButton];
}


#pragma mark - Notification

- (void)changeCurrentPageNotifcation:(NSNotification *)notify {
	NSInteger index = [notify.object integerValue];
	
	[self showViewControllerAtIndex:index animation:YES];
	
	//  更新进度条 UI
	[self updateProgressValue];
	
	// 导航栏上的标签状态
	[self updateNavigationBarMarkButton];
}

- (void)scrollMarkedPageNotification:(NSNotification *)notify {
	ZEMark *mark = notify.object;
	if (![mark isKindOfClass:ZEMark.class]) {
		NSLog(@"不是 ZEMark 类型");
		return;
	}
	
	NSInteger pageIndex = [self.book pageIndexAtMarkModel:mark];
	
	if (pageIndex == NSNotFound) {
		NSLog(@"pageIndex 获取错误！");
		return;
	}
	
	[self showViewControllerAtIndex:pageIndex animation:YES];
	
	//  更新进度条 UI
	[self updateProgressValue];
	
	// 导航栏上的标签状态
	[self updateNavigationBarMarkButton];
}

- (void)didEnterBacgroundNotification {
	
	// 数据本地化
	[self.book saveBooKModel];
}

@end
