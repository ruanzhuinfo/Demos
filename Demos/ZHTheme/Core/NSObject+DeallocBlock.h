//
//  NSObject+DeallocBlock.h
//  daily
//
//  Created by taffy on 16/3/18.
//  Copyright © 2016年 Zhihu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DeallocBlock)

- (id) addDeallocBlock: (void(^)()) deallocBlock;
@end
