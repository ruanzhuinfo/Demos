//
//  ZEMark.h
//  Demos
//
//  Created by taffy on 16/7/12.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "ZEBaseModel.h"

@interface ZEMark : ZEBaseModel

// 章节本地路径
@property(nonatomic)NSString *chapterPath;

// 章节标题
@property(nonatomic)NSString *chapterTitle;

// 当前页的前 100 个字符， 用于进度校验
@property(nonatomic)NSString *checkText;

// 相对于此章节的位置
// 打开此标签时会先根据 pageRange 拿到一段文本于 checkText 比较
// 如果在此页不存在 checkText 则再在整章寻找
@property(nonatomic)NSString *pageRangeString;


@end
