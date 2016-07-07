//
//  ZEPageViewController+Bar.m
//  Demos
//
//  Created by taffy on 16/7/7.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "ZEPageViewController+Bar.h"
#import <objc/runtime.h>
#import "ZENavigationController.h"
#import "ZESwitchViewController.h"


static NSString* const kNavigationBar = @"kNavigationBarString";
static NSString* const kToolBar = @"kToolBar";
static NSString* const kMoreTag = @"0x000111";
static NSString* const kMarkTag = @"0x000222";
static NSString* const kModeTag = @"0x000333";

static CGFloat const kNavigationBarHeight = 64.0;
static CGFloat const kToolBarHeight = 49.0;
static CGFloat const kButtonSize = 44;

@interface ZEPageViewController()

@property(nonatomic)UIView *toolBar;
@property(nonatomic)UIView *navigationBar;
@property(nonatomic)UIButton *moreButton;
@property(nonatomic)UIButton *markButton;
@property(nonatomic)UIButton *modeButton;

@end

@implementation ZEPageViewController (Bar)

- (BOOL)prefersStatusBarHidden {
	return self.isHiddenStatusBar;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
	return UIStatusBarAnimationSlide;
}

- (UIView *)toolBar {return objc_getAssociatedObject(self, &kToolBar);}
- (UIView *)navigationBar {return objc_getAssociatedObject(self, &kNavigationBar);}
- (UIButton *)moreButton {return objc_getAssociatedObject(self, &kMoreTag);}
- (UIButton *)markButton {return objc_getAssociatedObject(self , &kMarkTag);}
- (UIButton *)modeButton {return objc_getAssociatedObject(self, &kModeTag);}

- (void)setupNavigationBar {
	
	UIView *bar = objc_getAssociatedObject(self, &kNavigationBar);
	if (!bar) {
		bar = [[UIView alloc] init];
		objc_setAssociatedObject(self, &kNavigationBar, bar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		[bar setBackgroundColor:[UIColor whiteColor]];
		[self.view addSubview:bar];
		[bar mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.view);
			make.right.equalTo(self.view);
			make.height.mas_equalTo(kNavigationBarHeight);
			make.top.mas_equalTo(-kNavigationBarHeight);
		}];
		
		UIView *line = [[UIView alloc] init];
		[line setBackgroundColor:[UIColor lightGrayColor]];
		[bar addSubview:line];
		[line mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(bar);
			make.right.equalTo(bar);
			make.bottom.equalTo(bar);
			make.height.mas_equalTo(0.5);
		}];
		
		UIButton *more = [self createButton:[UIImage imageNamed:@"Read_Bar_Catalog_Normal"] action:@selector(didTapMoreItem)];
		objc_setAssociatedObject(self, &kMoreTag, more, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		[bar addSubview:more];
		[more mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.mas_equalTo(-8);
			make.size.mas_equalTo(CGSizeMake(kButtonSize, kButtonSize));
			make.bottom.mas_equalTo(bar);
		}];
		
		UIButton *mark = [self createButton:[UIImage imageNamed:@"Read_Bar_Bookmarks_Normal"] action:@selector(didTapChapterItem)];
		objc_setAssociatedObject(self, &kMarkTag, mark, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		[bar addSubview:mark];
		[mark mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(more.mas_left).offset(8);
			make.size.equalTo(more);
			make.bottom.equalTo(more);
		}];
		
		UIButton *mode = [self createButton:[UIImage imageNamed:@"Night_Night"] action:@selector(didTapReadModeItem)];
		objc_setAssociatedObject(self, &kModeTag, mode, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		[bar addSubview:mode];
		[mode mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(mark.mas_left).offset(8);
			make.size.equalTo(mark);
			make.bottom.equalTo(mark);
		}];
		
		UIButton *back = [self createButton:[UIImage imageNamed:@"Back_Normal"] action:@selector(didTapBackItem)];
		[bar addSubview:back];
		[back mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(bar).offset(8);
			make.size.equalTo(more);
			make.bottom.equalTo(more);
		}];
	}
}

- (void)setupToolBar {
	UIView *bar = objc_getAssociatedObject(self, &kToolBar);
	if (!bar) {
		bar = [[UIView alloc] init];
		[bar setBackgroundColor:[UIColor whiteColor]];
		[self.view addSubview:bar];
		[bar mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.view);
			make.right.equalTo(self.view);
			make.height.mas_equalTo(kToolBarHeight);
			make.bottom.mas_equalTo(kToolBarHeight);
		}];
		
		UIView *line = [[UIView alloc] init];
		[line setBackgroundColor:[UIColor lightGrayColor]];
		[bar addSubview:line];
		[line mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(bar);
			make.right.equalTo(bar);
			make.top.equalTo(bar);
			make.height.mas_equalTo(0.5);
		}];
		
		objc_setAssociatedObject(self, &kToolBar, bar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
}

- (void)showBar {
	[UIView animateWithDuration:0.25 animations:^{
		[self.navigationBar mas_updateConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.view);
		}];
		
		[self.toolBar mas_updateConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(self.view);
		}];
		
		[self.navigationBar layoutIfNeeded];
		[self.toolBar layoutIfNeeded];
	}];
}

- (void)hiddenBar {
	[UIView animateWithDuration:0.25 animations:^{
		[self.navigationBar mas_updateConstraints:^(MASConstraintMaker *make) {
			make.top.mas_equalTo(-kNavigationBarHeight);
		}];
		
		[self.toolBar mas_updateConstraints:^(MASConstraintMaker *make) {
			make.bottom.mas_offset(kToolBarHeight);
		}];
		
		[self.toolBar layoutIfNeeded];
		[self.navigationBar layoutIfNeeded];
	}];
}

#pragma mark - selector method

- (void)didTapMoreItem {

	ZENavigationController *nav = [ZENavigationController newWithParentViewController:self];
	ZESwitchViewController *switchVC = [ZESwitchViewController new];
	[nav pushViewController:switchVC animated:YES];
}

- (void)didTapChapterItem {

}

- (void)didTapReadModeItem {
	
}

- (void)didTapBackItem {
	
}


#pragma mark - private helper method

- (UIButton *)createButton:(UIImage *)image action:(SEL)action {
	UIButton *button = [[UIButton alloc] init];
	[button setImage:image forState:UIControlStateNormal];
	[button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
	return button;
}


@end
