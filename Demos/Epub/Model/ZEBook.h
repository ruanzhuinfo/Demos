//
//  ZEBook.h
//  Demos
//
//  Created by taffy on 16/6/30.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "ZEChapter.h"

@interface ZEBook : ZEBaseModel

@property(nonatomic)NSString *bookId;
@property(nonatomic)NSString *author;
@property(nonatomic)NSString *format;
@property(nonatomic)NSString *version;

// 保存章节内容
@property(nonatomic, copy)NSArray<ZEChapter *> *chapters;

// 总页数
@property(nonatomic)NSInteger pageCount;

// 当前页码
@property(nonatomic)NSInteger pageIndex;


@end
