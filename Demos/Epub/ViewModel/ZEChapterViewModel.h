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

- (NSInteger)estimatePageCount;

- (NSAttributedString *)attributedStringAtPageIndex:(NSInteger)index;

@end
