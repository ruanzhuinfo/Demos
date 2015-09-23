//
//  DynamicAnimationViewController.m
//  Demos
//
//  Created by taffy on 15/9/22.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import "DynamicAnimationViewController.h"

@interface DynamicAnimationViewController () <UICollisionBehaviorDelegate>

@property (nonatomic, strong) UIDynamicAnimator *animator;

@end

@implementation DynamicAnimationViewController {
  
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setTitle:@"Dynamic"];
  [self.view setBackgroundColor:[UIColor whiteColor]];
  
  UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(100, 50, 100, 100)];
  [aView setBackgroundColor:[UIColor lightGrayColor]];
  [self.view addSubview:aView];
  
  aView.transform = CGAffineTransformRotate(aView.transform, 45);
  
  // 重力
  UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
  UIGravityBehavior *gravityBeahvior = [[UIGravityBehavior alloc] initWithItems:@[aView]];
  [animator addBehavior:gravityBeahvior];
  
  // 碰撞
  UICollisionBehavior *collisionBeahvior = [[UICollisionBehavior alloc] initWithItems:@[aView]];
  collisionBeahvior.translatesReferenceBoundsIntoBoundary = YES;
  [animator addBehavior:collisionBeahvior];
  collisionBeahvior.collisionDelegate = self;
  self.animator = animator;
  
  
  
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
