//
//  ZEChapter.h
//  Demos
//
//  Created by taffy on 16/6/30.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "ZEBaseModel.h"

@interface ZEChapter : ZEBaseModel

/// 章节标题
@property(nonatomic)NSString *title;
/// 章节的正文地址
@property(nonatomic)NSString *contentPath;
/// 章节正文 NSData 内容
@property(nonatomic)NSData *contentData;
/// 章节序列号，备用
@property(nonatomic)NSString *sort;
/// 是否需要解密
@property(nonatomic)BOOL isEncrypt;


/// 此章节的页数
@property(nonatomic)NSInteger pageCount;
/// 相对于整本书的索引，也就是本章的第一页相对于在整本书中的第几页
@property(nonatomic)NSInteger pageIndex;
/// 每页字符串偏移量
@property (nonatomic, copy)NSArray<NSString *> *pageArray;


@end
