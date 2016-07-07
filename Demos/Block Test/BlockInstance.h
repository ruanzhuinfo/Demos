//
//  BlockInstance.h
//  Demos
//
//  Created by taffy on 16/6/1.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlockInstance : NSObject


+ (instancetype) sharedInstance;

- (void)test:(void (^)())callback;

@end
