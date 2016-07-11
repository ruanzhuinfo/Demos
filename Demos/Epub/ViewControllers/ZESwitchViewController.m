//
//  ZESwitchViewController.m
//  Demos
//
//  Created by taffy on 16/7/7.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "ZESwitchViewController.h"
#import "ZEChapterListViewController.h"
#import "ZEMarkListViewController.h"

@interface ZESwitchViewController()

@property(nonatomic)ZEChapterListViewController *chpaterListVC;
@property(nonatomic)ZEMarkListViewController *markListVC;
@property(nonatomic)UIViewController *currentVC;
@property(nonatomic)ZEBook *book;

@end

@implementation ZESwitchViewController

+ (instancetype)newWithBookModel:(ZEBook *)book {
	ZESwitchViewController *vc = [ZESwitchViewController new];
	vc.book = book;
	return vc;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self.view setBackgroundColor:[UIColor whiteColor]];
	
	[self setupSegmentedControl];
	
	[self setupChildViewController];
}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self.navigationController.navigationBar setHidden:NO];
	
	
	[[UINavigationBar appearance] setTintColor:[UIColor grayColor]];
	[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-100, -100)
														 forBarMetrics:UIBarMetricsDefault];
}

- (BOOL)prefersStatusBarHidden {
	return NO;
}



- (void)setupSegmentedControl {
	UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:@[@"目录", @"书签"]];
	[segmented setTintColor:[UIColor grayColor]];
	[segmented setFrame:CGRectMake(0, 0, 166, 29)];
	[segmented setSelectedSegmentIndex:0];
	[segmented addTarget:self action:@selector(didChangeIndexForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
	
	[self.navigationItem setTitleView:segmented];
}

- (void)setupChildViewController {
	self.chpaterListVC = [ZEChapterListViewController newWithBookModel:self.book];
	[self addChildViewController:self.chpaterListVC];
	[self.view addSubview:self.chpaterListVC.view];
	[self.chpaterListVC didMoveToParentViewController:self];
	self.currentVC = self.chpaterListVC;
	
	self.markListVC = [ZEMarkListViewController new];
	[self addChildViewController:self.markListVC];
	
}


- (void)didChangeIndexForSegmentedControl:(UISegmentedControl *)control {
	
	UIViewController *toVC = control.selectedSegmentIndex == 0 ? self.chpaterListVC : self.markListVC;
	if (toVC == self.currentVC) {
		return;
	}
	
	[self transitionFromViewController:self.currentVC
					  toViewController:toVC
							  duration:0
							   options:0
							animations:nil
							completion:^(BOOL finished){
								self.currentVC = toVC;
							}];
}

@end
