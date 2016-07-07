//
//  BlockInstance.m
//  Demos
//
//  Created by taffy on 16/6/1.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "BlockInstance.h"

@implementation BlockInstance

+ (instancetype)sharedInstance {
	static BlockInstance *share;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		share = [BlockInstance new];
	});
	return share;
}


- (void)test:(void (^)())callback {
	callback();
}


@end
