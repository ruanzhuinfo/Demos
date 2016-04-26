//
//  BezierViewController.m
//  Demos
//
//  Created by taffy on 15/9/20.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import "BezierViewController.h"
#import <ComponentKit/ComponentKit.h>
#import "ProgressIndicatorView.h"

@interface BezierViewController ()

@end

@implementation BezierViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setTitle:@"Bezier"];
  [self.view setBackgroundColor:[UIColor whiteColor]];
  
  
  ProgressIndicatorView *progress = [[ProgressIndicatorView alloc] init];
  [progress showProgressAddToView:self.view];
  
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [progress finishedProgress:YES completionProgress:^{
      
    }];
  });
  
  // No.1
  // corner radius
  
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
  [imageView setClipsToBounds:YES];
  UIImage *anotherImage = [UIImage getRandomImage];
  UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 1.0);
  [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds
                              cornerRadius:20.0f] addClip];
  [anotherImage drawInRect:imageView.bounds];
  imageView.image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  [self.view addSubview:imageView];
  
  UIImageView *_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 50, 100, 100)];
  [_imageView setImage:[UIImage getRandomImage]];
  [_imageView.layer setCornerRadius:20.0f];
  [_imageView setClipsToBounds:YES];
  [self.view addSubview:_imageView];
  
  UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
  UIVisualEffectView * effe = [[UIVisualEffectView alloc]initWithEffect:blur];
  effe.frame = CGRectMake(10, 10, self.view.width - 20, self.view.height - 84);
  [self.view addSubview:effe];
  
  UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(50, 200, 100, 100)];
  view2.backgroundColor = [UIColor blackColor];
  [view2 setCornerRadius:20.0f];
  [self.view addSubview:view2];
  
  
  UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(200, 200, 100, 100)];
  [view3.layer setCornerRadius:20.0f];
  [view3 setBackgroundColor:[UIColor blackColor]];
  [view3 setClipsToBounds:YES];
  [self.view addSubview:view3];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
