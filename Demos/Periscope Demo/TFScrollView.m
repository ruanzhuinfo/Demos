//
//  TFScrollView.m
//  Demos
//
//  Created by taffy on 15/9/22.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import "TFScrollView.h"

@implementation TFScrollView


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  
  UIView *view = [self.scrollViewDelegate customScrollViewHistTest:point withEvent:event];
  if (!view ) {
    return [super hitTest:point withEvent:event];
  }
  
  return view;
}



- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
  
  return [_scrollViewDelegate customGestureRecognizer:gestureRecognizer
   shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
}

@end
