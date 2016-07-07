//
//  BlockTest.m
//  Demos
//
//  Created by taffy on 16/6/1.
//  Copyright © 2016年 taffy. All rights reserved.
//


#import "BlockInstance.h"
#import "BlockTest.h"

@interface BlockTest()

@property (nonatomic) NSString *name;

@end

@implementation BlockTest


- (void)viewDidLoad {
	[super viewDidLoad];
	
	[[BlockInstance sharedInstance] test:^{
		
		// 以参数形式传递的 block 是不会被系统自动 copy 到堆上的
		// 可以被释放
		
		self.name = @"ssss";
		[self runCode];
	}];
}



- (void) runCode {
	self.name = @"block!!!!!";
}


- (void)dealloc {
	NSLog(@"block dealloc！！！");
}

@end
