//
//  ZEReadFile.h
//  Demos
//
//  Created by taffy on 16/6/28.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^BookParserCompletion)(NSDictionary<NSString*,id> *book, NSString *error);
typedef void (^ChapterParserCompletion)(NSArray<NSDictionary *> *chapters, NSString *error);

/**
 *  解析 epub 格式的文件
 */
@interface ZEReadFile : NSObject

/// 电子书数据结构
@property (nonatomic) NSDictionary<NSString*, id> *book;

- (instancetype)initWithEpubPath:(NSString *)ePubPath;
- (instancetype)initWithEpubPath:(NSString *)ePubPath completion:(BookParserCompletion)completion;


@end
