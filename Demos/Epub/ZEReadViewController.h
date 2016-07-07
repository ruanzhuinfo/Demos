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

// 所在那一章的第几页
@property (nonatomic) NSInteger pageIndex;

+ (instancetype)newWithChapterModel:(ZEChapter *)chapter pageIndex:(NSInteger)index;

@end
