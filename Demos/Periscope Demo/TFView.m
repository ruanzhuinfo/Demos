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
  
  return [self.viewDelegate customHistTest:point];
}


@end
