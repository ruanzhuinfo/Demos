//
//  ZEReadViewController.h
//  Demos
//
//  Created by taffy on 16/6/30.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZEChapter;

@interface ZEReadViewController : UIViewController

@property (nonatomic, weak)ZEChapter *chapter;

/// 相对于整本书的第几页
@property (nonatomic) NSInteger currentPage;

+ (instancetype)newWithChapterModel:(ZEChapter *)chapter pageIndex:(NSInteger)index;


- (void)updateBottomInfoWithPageCount:(NSInteger)pageCount bookTitle:(NSString *)title;

@end
