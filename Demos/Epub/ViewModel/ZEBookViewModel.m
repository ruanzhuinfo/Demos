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

@interface ZEBookViewModel()
@property(nonatomic)ZEChapterViewModel *currentChpaterViewModel;

@end

@implementation ZEBookViewModel

+ (instancetype)new {
	ZEBookViewModel *viewModel = [super new];
	
	NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"Hour 028-高飞龙" withExtension:@"epub"];
	
	NSData *b = [[NSUserDefaults standardUserDefaults] objectForKey:fileURL.path];
	if (!b) {
		viewModel.book = [ZEBook yy_modelWithJSON:[[ZEReadFile alloc] initWithEpubPath:fileURL.path base64:@"UPIkeH3pD9JBYWlp7Ag8YQ=="].book];
		
		viewModel.book.title = @"Hour 028-高飞龙";
		viewModel.book.authors = @[@"高飞龙"];
		viewModel.book.filePath = fileURL.path;
		[viewModel calculateBookPageCount];
	} else {
		viewModel.book = [ZEBook yy_modelWithJSON:b];
	}
	
	viewModel.currentPage = viewModel.book.pageIndex;
	
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

- (ZEBook *)bookModel {
	return self.book;
}

- (void)saveBooKModel{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:[self.book yy_modelToJSONData] forKey:self.book.filePath];
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
		
		if (c.pageIndex + c.pageCount > index) {
			return completion(c, index - c.pageIndex);
		}
	}
	
	return nil;
}



#pragma mark - private core method

#pragma mark - private helper


@end
