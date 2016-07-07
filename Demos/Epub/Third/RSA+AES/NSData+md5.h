//
//  NSData+md5.h
//  Demos
//
//  Created by taffy on 16/7/5.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (md5)

- (NSString *)MD5HexDigest;
- (NSData *)MD5Digest;

@end
