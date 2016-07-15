//
//  ZHDeallocBlockExecutor.m
//  daily
//
//  Created by taffy on 16/3/18.
//  Copyright © 2016年 Zhihu. All rights reserved.
//

#import "ZHDeallocBlockExecutor.h"

@implementation ZHDeallocBlockExecutor

+ (instancetype) newWithDeallocBlockExecutor: (void(^)())block {
  ZHDeallocBlockExecutor *d = [ZHDeallocBlockExecutor new];
  d.deallocBlock = block;
  return d;
}


- (void) dealloc {
  if (self.deallocBlock) {
    self.deallocBlock();
    self.deallocBlock = nil;
  }
}


@end
