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
@property (nonatomic, strong) UIImageView *dynmatorImageView;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation DynamicAnimationViewController {
  
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setTitle:@"Dynamic"];
  [self.view setBackgroundColor:[UIColor whiteColor]];
  
  self.containerView = [[UIView alloc] initWithFrame:CGRectMake(-1, -self.view.height - 63, self.view.width + 2, self.view.height * 2)];
  [self.view addSubview:self.containerView];
  
  self.dynmatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1,0, self.view.width, self.view.height)];
  [self.dynmatorImageView setContentMode:UIViewContentModeScaleAspectFill];
  [self.dynmatorImageView setImage:[UIImage getRandomImage]];
  [self.dynmatorImageView setClipsToBounds:YES];
  [self.containerView addSubview:self.dynmatorImageView];
}


- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  // 重力
  UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.containerView];
  UIGravityBehavior *gravityBeahvior = [[UIGravityBehavior alloc] initWithItems:@[self.dynmatorImageView]];
  [gravityBeahvior setMagnitude:7];
  [animator addBehavior:gravityBeahvior];
  
  UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.dynmatorImageView]];
  [itemBehavior setElasticity:0.45];
  [animator addBehavior:itemBehavior];
  
  // 碰撞
  UICollisionBehavior *collisionBeahvior = [[UICollisionBehavior alloc] initWithItems:@[self.dynmatorImageView]];
  collisionBeahvior.translatesReferenceBoundsIntoBoundary = YES;
  [collisionBeahvior setCollisionMode:UICollisionBehaviorModeBoundaries];
  [animator addBehavior:collisionBeahvior];
  collisionBeahvior.collisionDelegate = self;
  self.animator = animator;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
