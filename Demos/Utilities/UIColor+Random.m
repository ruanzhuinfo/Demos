//
//  UIColor+Random.m
//  Demos
//
//  Created by taffy on 15/9/25.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import "UIColor+Random.h"


#define INT_RANDOM(min, max) (min + rand() % max)

@implementation UIColor(Random)


+ (UIColor *)getRandomColor {
//  return [UIColor colorWithRed:INT_RANDOM(150, 160) / 255 green:INT_RANDOM(130, 160) / 255 blue:INT_RANDOM(100, 180) / 255 alpha:0.5];
  static BOOL seeded = NO;
  if (!seeded) {
    seeded = YES;
    srandom(time(NULL));
  }
  CGFloat red =  (CGFloat)random()/(CGFloat)RAND_MAX;
  CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
  CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
  return [UIColor colorWithRed:red green:green blue:blue alpha:0.5f];
}
@end
