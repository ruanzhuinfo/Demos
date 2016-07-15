//
//  NSObject+DeallocBlock.m
//  daily
//
//  Created by taffy on 16/3/18.
//  Copyright © 2016年 Zhihu. All rights reserved.
//

#import "NSObject+DeallocBlock.h"
#import "ZHDeallocBlockExecutor.h"
#import <objc/runtime.h>

static NSString *kNSObjectDeallocBlockKey;


@implementation NSObject (DeallocBlock)


- (id) addDeallocBlock:(void (^)())deallocBlock {
  if (!deallocBlock) return nil;
  
  NSMutableArray *deallocBlocks = objc_getAssociatedObject(self, &kNSObjectDeallocBlockKey);
  if (!deallocBlocks) {
    deallocBlocks = [NSMutableArray array];
    objc_setAssociatedObject(self, &kNSObjectDeallocBlockKey, deallocBlocks, OBJC_ASSOCIATION_RETAIN);
  }
  
  for (ZHDeallocBlockExecutor *blockExecutor in deallocBlocks) {
    if (blockExecutor.deallocBlock == deallocBlock) {
      return nil;
    }
  }
  
  ZHDeallocBlockExecutor *executor = [ZHDeallocBlockExecutor newWithDeallocBlockExecutor:deallocBlock];
  [deallocBlocks addObject:executor];
  return executor;
}
@end
