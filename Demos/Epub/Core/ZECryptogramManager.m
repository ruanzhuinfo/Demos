//
//  ZECryptogramManager.m
//  Demos
//
//  Created by taffy on 16/7/14.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "ZECryptogramManager.h"
#import "NSData+AES128.h"

@interface ZECryptogramManager()

@property(nonatomic)NSString *codeBase64;

@end

@implementation ZECryptogramManager


+ (instancetype)sharedInstance {
	static ZECryptogramManager *cm;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		cm = [ZECryptogramManager new];
		cm.codeBase64 = @"UPIkeH3pD9JBYWlp7Ag8YQ==";
	});
	return cm;
}

- (NSData *)decryptWithData:(NSData *)data {
	data = [data AES128CFBDecryptWithBase64:self.codeBase64];
	return data;
}

@end
