//
//  TFView.m
//  Demos
//
//  Created by taffy on 15/9/20.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import "TFView.h"

@implementation TFView



- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  
  UIView *toucheView = [super hitTest:point withEvent:event];
  UIView *view = [self.viewDelegate customViewHistTest:point withEvent:event withView: toucheView];
  
  if (!view) {
    return [super hitTest:point withEvent:event];
  }
  
  return view;
}


@end
