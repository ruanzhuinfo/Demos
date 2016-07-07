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
									 @"encryptions": @"encryptions",
									 @"bookId": @"id",
									 @"author": @"name",
									 @"format": @"format",
									 @"version": @"version"}];
	return dict;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
	NSMutableDictionary *dic = [[super modelContainerPropertyGenericClass] mutableCopy];
	[dic addEntriesFromDictionary:@{@"chapters": [ZEChapter class]}];
	return dic;
}



@end
