//
//  ZEBook.m
//  Demos
//
//  Created by taffy on 16/6/30.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "ZEBook.h"

@implementation ZEBook

+ (NSDictionary *)modelCustomPropertyMapper {
	NSMutableDictionary *dict = [[super modelCustomPropertyMapper] mutableCopy];
	[dict addEntriesFromDictionary:@{@"chapters": @"chapters",
									 @"marks": @"marks",
									 @"encryptions": @"encryptions",
									 @"bookId": @"id",
									 @"authors": @"authors",
									 @"format": @"format",
									 @"version": @"version",
									 @"title": @"title"}];
	return dict;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
	NSMutableDictionary *dic = [[super modelContainerPropertyGenericClass] mutableCopy];
	[dic addEntriesFromDictionary:@{@"chapters": [ZEChapter class],
									@"marks": [ZEMark class]}];
	return dic;
}

@end
