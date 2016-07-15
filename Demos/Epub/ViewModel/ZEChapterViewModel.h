//
//  ZEChapterViewModel.h
//  Demos
//
//  Created by taffy on 16/7/1.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTCoreText.h"
#import "ZEChapter.h"

@interface ZEChapterViewModel : NSObject

@property(nonatomic) ZEChapter *chapter;

+ (instancetype)newWithChapterModel:(ZEChapter *)chapter;

- (NSAttributedString *)attributedStringWithHTMLData:(NSData *)data documentPath:(NSURL *)filePath;

/// 计算当前章节的页数
- (NSInteger)estimatePageCount;

/**
 *  获取一个章节中的一页的 AttributedString
 *
 *  @param index 第几页
 */
- (NSAttributedString *)attributedStringAtPageIndex:(NSInteger)index;

@end
