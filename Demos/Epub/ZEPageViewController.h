//
//  ZEPageViewController.h
//  Demos
//
//  Created by taffy on 16/6/30.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZEBookViewModel.h"
#import "ZEProgressView.h"

static NSString* const kPageViewControllerChangePageNotification = @"kPageViewControllerChangePageNotification";

@interface ZEPageViewController : UIViewController<UIGestureRecognizerDelegate, ZEProgressViewDelegate>

@property(nonatomic)ZEBookViewModel *book;
@property(nonatomic)BOOL isHiddenStatusBar;

- (void)showViewControllerAtIndex:(NSInteger)index animation:(BOOL)animation;

@end
