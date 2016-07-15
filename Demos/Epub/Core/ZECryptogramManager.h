//
//  ZECryptogramManager.h
//  Demos
//
//  Created by taffy on 16/7/14.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZECryptogramManager : NSObject

+ (instancetype)sharedInstance;


- (NSData *)decryptWithData:(NSData *)data;

@end
