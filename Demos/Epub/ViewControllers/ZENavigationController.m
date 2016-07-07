//
//  ZENavigationController.m
//  Demos
//
//  Created by taffy on 16/7/7.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "ZENavigationController.h"

@interface ZETempViewController : UIViewController
@property(nonatomic)NSInteger comeInCount;
@end

@implementation ZETempViewController

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:YES];
	if (_comeInCount == 0) {
		_comeInCount = 1;
		return;
	}
	
	[self.navigationController willMoveToParentViewController:nil];
	[self.navigationController.view removeFromSuperview];
	[self.navigationController removeFromParentViewController];
	[self.navigationController didMoveToParentViewController:nil];
}


@end


@implementation ZENavigationController

+ (instancetype)newWithParentViewController:(UIViewController *)viewController {
	if (!viewController) {
		return nil;
	}
	
	ZETempViewController *v = [[ZETempViewController alloc] init];
	[v.view setBackgroundColor:[UIColor clearColor]];
	
	ZENavigationController *nav = [[ZENavigationController alloc] initWithRootViewController:v];
	[nav.view setBackgroundColor:[UIColor clearColor]];
	[nav.navigationBar setHidden:YES];
	
	[nav beginAppearanceTransition:YES animated:NO];
	
	[viewController addChildViewController:nav];
	[viewController.view addSubview:nav.view];
	[nav willMoveToParentViewController:viewController];
	[nav didMoveToParentViewController:viewController];
	
	[nav endAppearanceTransition];
	
	return nav;
}

- (void)dealloc {

}



@end
