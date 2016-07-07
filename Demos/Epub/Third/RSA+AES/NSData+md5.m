//
//  NSData+md5.m
//  Demos
//
//  Created by taffy on 16/7/5.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "NSData+md5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (md5)


- (NSString *)MD5HexDigest {
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	
	CC_MD5(self.bytes, (CC_LONG)self.length, result);
	NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
	for (int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
		[ret appendFormat:@"%02x",result[i]];
	}
	return ret;
}

- (NSData *)MD5Digest {
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	
	CC_MD5(self.bytes, (CC_LONG)self.length, result);
	return [[NSData alloc] initWithBytes:result length:CC_MD5_DIGEST_LENGTH];
}

@end
