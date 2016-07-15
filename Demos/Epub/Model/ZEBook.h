//
//  ZEBook.h
//  Demos
//
//  Created by taffy on 16/6/30.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "ZEChapter.h"
#import "ZEMark.h"

@interface ZEBook : ZEBaseModel

@property(nonatomic)NSString *bookId;
@property(nonatomic)NSArray<NSString *> *authors;
@property(nonatomic)NSString *format;
@property(nonatomic)NSString *version;
@property(nonatomic)NSString *title;

/// 注解章节的地址, 注解的地方要添加特殊的图标，用 footNotePath 去判断超链接是否是注解
@property(nonatomic)NSString *footNotePath;

/// 保存章节内容
@property(nonatomic, copy)NSArray<ZEChapter *> *chapters;

/// 保存书签
@property(nonatomic, copy)NSArray<ZEMark *> *marks;

/// 本地存储路径
@property(nonatomic)NSString *filePath;

/// 总页数
@property(nonatomic)NSInteger pageCount;

/// 当前页码
@property(nonatomic)NSInteger pageIndex;

/// 当前章节本地路径
@property(nonatomic)NSString *currentChapterPath;

/// 当前页的前 20 个字符， 用于进度校验
@property(nonatomic)NSString *currentChapterCheckText;



@end
