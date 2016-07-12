//
//  ZEReadViewController.h
//  Demos
//
//  Created by taffy on 16/6/30.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZEChapter, ZEReadViewController;

@protocol ZEReadViewControllerDelegate <NSObject>

- (void)didTapMarkButton:(ZEReadViewController *)viewController;
- (void)didEndDragScrollViewFinished:(ZEReadViewController *)viewController;

@end

@interface ZEReadViewController : UIViewController

@property(nonatomic, weak)id<ZEReadViewControllerDelegate>delegate;

@property (nonatomic, weak)ZEChapter *chapter;

// 是否添加了标签
@property(nonatomic)BOOL isMark;

/// 相对于整本书的第几页
@property (nonatomic) NSInteger currentPage;
// 相对于本章节的页码
@property(nonatomic)NSInteger pageIndexAtChapter;

+ (instancetype)newWithChapterModel:(ZEChapter *)chapter pageIndex:(NSInteger)index;


- (void)updateBottomInfoWithPageCount:(NSInteger)pageCount bookTitle:(NSString *)title;

@end
