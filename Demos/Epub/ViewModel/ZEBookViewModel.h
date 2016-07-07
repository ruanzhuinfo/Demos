//
//  ZEBookViewModel.h
//  Demos
//
//  Created by taffy on 16/7/1.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZEBook, ZEChapter;

@interface ZEBookViewModel : NSObject

@property (nonatomic) NSInteger pageCount;
@property (nonatomic) NSInteger currentPage;

- (id)chapterAtPageIndex:(NSInteger)index completion:(id (^)(ZEChapter *, NSInteger))completion;

- (NSInteger)calculateBookPageCount;


@end
