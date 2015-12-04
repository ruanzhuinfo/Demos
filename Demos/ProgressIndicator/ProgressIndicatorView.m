//
//  ProgressIndicatorView.m
//  Demos
//
//  Created by taffy on 15/12/3.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import "ProgressIndicatorView.h"

#define COLOR_FROM_HEX_ALPHA(d, a) [UIColor colorWithRed:((d >> 16) & 0xFF) / 255.0f green:((d >> 8) & 0xFF) / 255.0 blue:(d & 0xFF) / 255.0f alpha:a]

float const progressDuration = 2.0;
float const progressStep_1 = 0.37;

@implementation ProgressIndicatorView {
  
  CGFloat currentWidth;
  CGFloat totalWidth;
  NSInteger animationCount;
}

- (id) init {
  self = [super init];
  if (self) {
    [self setBackgroundColor:COLOR_FROM_HEX_ALPHA(0x33BBFF, 1)];
  }
  
  return self;
}

- (void) showProgressAddToView: (UIView *)inView {
  totalWidth = inView.bounds.size.width;
  currentWidth = 0;
  animationCount = 0;
  [inView addSubview:self];
  [self setFrame:CGRectMake(0, 0, 0, 2)];
  [self.layer setCornerRadius:1.0];
  [self setAlpha:1.0];
  [self animationStart: progressDuration];
}

- (void) finishedProgress:(BOOL)finished completionProgress: (CompletionProgressBlock)completionProgress {
  
  if (finished) {
    [self animationCompletion:^{
      [UIView animateWithDuration:0.5 animations:^{
        [self setAlpha:0.0];
      } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self setFrame:CGRectMake(0, 0, 0, 2)];
        completionProgress();
      }];
    }];
  } else {
    [UIView animateWithDuration:0.5 animations:^{
      [self setAlpha:0.0];
    } completion:^(BOOL finished) {
      [self removeFromSuperview];
      [self setFrame:CGRectMake(0, 0, 0, 2)];
      completionProgress();
    }];
  }
}


#pragma mark -- private method

- (void) animationStart: (NSTimeInterval)duration {
  
  [UIView animateWithDuration:duration animations:^{
    [self setFrame:CGRectMake(0, 0, [self progressWidth:progressStep_1], 2)];
    animationCount++;
  } completion:^(BOOL finished) {
    if (animationCount <= 5) {
      [self animationStart: duration];
    }
  }];
}

- (void) animationCompletion: (CompletionProgressBlock) completion {
  [UIView animateWithDuration:0.35 animations:^{
    [self setFrame:CGRectMake(0, 0, totalWidth, 2)];
  } completion:^(BOOL finished) {
    completion();
  }];
}

- (CGFloat) progressWidth: (CGFloat) rate {
  
  currentWidth = ((totalWidth - currentWidth) * rate) + currentWidth;
  return ceilf(currentWidth);
}

@end

