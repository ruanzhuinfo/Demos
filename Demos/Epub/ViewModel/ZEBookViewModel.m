//
//  ZEBookViewModel.m
//  Demos
//
//  Created by taffy on 16/7/1.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "ZEBookViewModel.h"
#import "ZEChapterViewModel.h"
#import "ZEReadFile.h"
#import "ZEBook.h"

@interface ZEBookViewModel()

@property(nonatomic)ZEBook *book;
@property(nonatomic)ZEChapterViewModel *currentChpaterViewModel;

@end

@implementation ZEBookViewModel

+ (instancetype)new {
	ZEBookViewModel *viewModel = [super new];
	
	NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"Hour 028-高飞龙" withExtension:@"epub"];
	viewModel.book = [ZEBook yy_modelWithJSON:[[ZEReadFile alloc] initWithEpubPath:fileURL.path base64:@"UPIkeH3pD9JBYWlp7Ag8YQ=="].book];
	viewModel.currentPage = 0;
	[viewModel calculateBookPageCount];
	
	return viewModel;
}

#pragma mark - public method

- (void)setCurrentPage:(NSInteger)currentPage {
	if (currentPage <= self.pageCount && currentPage >= 0) {
		self.book.pageIndex = currentPage;
	}
}

- (NSInteger)currentPage{
	return self.book.pageIndex;
}

- (NSInteger)pageCount {
	return self.book.pageCount;
}

- (NSInteger)calculateBookPageCount {
	self.book.pageCount = 0;
	[self.book.chapters enumerateObjectsUsingBlock:^(ZEChapter * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		ZEChapterViewModel *m = [ZEChapterViewModel newWithChapterModel:obj];
		obj.pageIndex = self.book.pageCount;
		self.book.pageCount += [m estimatePageCount];
	}];
	
	return self.book.pageCount;
}

- (id)chapterAtPageIndex:(NSInteger)index
			  completion:(id (^)(ZEChapter *, NSInteger))completion {

	for (ZEChapter *c in self.book.chapters) {
		if (c.pageIndex == index) {
			return completion(c, 0);
		}
		
		if (c.pageIndex > index) {
			ZEChapter *pc = [self.book.chapters objectAtIndex:[self.book.chapters indexOfObject:c] - 1];
			return completion(pc, index - pc.pageIndex);
		}
	}
	
	return nil;
}

#pragma mark - private core method

#pragma mark - private helper


@end
