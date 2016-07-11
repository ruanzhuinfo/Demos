//
//  ZEChapterTableViewCell.h
//  Demos
//
//  Created by taffy on 16/7/8.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZEChapter;

typedef NS_OPTIONS(NSInteger, ZEChapterStyle) {
	ZEChapterStyleNormal = 0,
	ZEchapterStyleNoPurchase
};

@interface ZEChapterTableViewCell : UITableViewCell

@property(nonatomic)ZEChapterStyle chapterStyle;
@property(nonatomic)BOOL isCurrentPage;

- (void)setupDataWithChapterModel:(ZEChapter *)chapter;

@end
