//
//  UIImage+Additions.m
//  Demos
//
//  Created by taffy on 15/9/24.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import "UIImage+Additions.h"
#import <stdlib.h>


@implementation UIImage(Additions)


+ (UIImage *) getRandomImage {
  
  NSInteger imageIndex = 0 + rand() % [IMAGE_DATA_LIST count];
  return [UIImage imageNamed:[IMAGE_DATA_LIST objectAtIndex:imageIndex]];
}


@end
