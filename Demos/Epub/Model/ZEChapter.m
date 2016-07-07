//
//  ZEChapter.m
//  Demos
//
//  Created by taffy on 16/6/30.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "ZEChapter.h"

@implementation ZEChapter

+ (NSDictionary *)modelCustomPropertyMapper {
	NSDictionary *dict = [super modelCustomPropertyMapper];
	NSMutableDictionary *all = [dict mutableCopy];
	[all addEntriesFromDictionary:
	 @{@"title": @"chapterTitle",
	   @"contentPath": @"content",
	   @"sort": @"chapterOrder",
	   @"isEncrypt": @"encryption"
	   }];
	return all;
}


@end
