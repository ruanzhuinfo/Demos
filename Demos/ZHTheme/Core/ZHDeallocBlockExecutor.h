//
//  ZHDeallocBlockExecutor.h
//  daily
//
//  Created by taffy on 16/3/18.
//  Copyright © 2016年 Zhihu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHDeallocBlockExecutor : NSObject


+ (instancetype) newWithDeallocBlockExecutor: (void(^)())block;

@property (nonatomic, copy) void(^deallocBlock)();
@end
