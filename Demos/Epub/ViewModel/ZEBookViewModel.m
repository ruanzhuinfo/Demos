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
#import "ZEMark.h"

@interface ZEBookViewModel()

@end

@implementation ZEBookViewModel

+ (instancetype)new {
	ZEBookViewModel *viewModel = [super new];
	
	NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"encrypted" withExtension:@"epub"];
	NSData *b = [[NSUserDefaults standardUserDefaults] objectForKey:fileURL.path];
	
	if (!b) {
		viewModel.book = [ZEBook yy_modelWithJSON:[[ZEReadFile alloc] initWithEpubPath:fileURL.path base64:@"UPIkeH3pD9JBYWlp7Ag8YQ=="].book];
		
		viewModel.book.title = @"053-傅渥成-10.16（修改版）";
		viewModel.book.authors = @[@"傅渥成"];
		viewModel.book.filePath = fileURL.path;
		[viewModel calculateBookPageCount];
	} else {
		viewModel.book = [ZEBook yy_modelWithJSON:b];
	}
	
	// NOTE:
	// v1 需求没有改变字体大小，行间距的功能，所以这样做定位到当前页是没问题的，
	// v2 有了字体或行间距修改的功能后，就要用 self.book.currentChapterCheckText 和 self.book.currentChapterPath 来配合了
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

- (NSInteger)pageIndexAtMarkModel:(ZEMark *)mark {
	
	NSRange range = NSRangeFromString(mark.pageRangeString);
	
	for (ZEChapter *c in self.book.chapters) {
		if ([c.contentPath isEqualToString:mark.chapterPath]) {
			
			if ([c.pageArray indexOfObject:mark.pageRangeString] != NSNotFound) {
				return c.pageIndex + [c.pageArray indexOfObject:mark.pageRangeString];
			}
			
			for (NSString *r in c.pageArray) {
				NSRange cr = NSRangeFromString(r);
				if ((range.location >= cr.location) && (range.location < cr.location + cr.length)) {
					return c.pageIndex + [c.pageArray indexOfObject:r];
				}
			}
		}
	}
	
	return NSNotFound;
}

- (void)saveBooKModel{
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		
		[self chapterAtPageIndex:self.currentPage completion:^id(ZEChapter *chapter, NSInteger index) {
			
			// 获取当前页的文本
			NSString *content =
			[[ZEChapterViewModel newWithChapterModel:chapter] attributedStringAtPageIndex:index].string;
			
			NSRange subStringRange = NSMakeRange(0, (content.length > 20 ? 20 : content.length));

			self.book.currentChapterCheckText = [content substringWithRange:subStringRange];
			self.book.currentChapterPath = chapter.contentPath;
			
			return nil;
		}];
		
		[[NSUserDefaults standardUserDefaults] setObject:[self.book yy_modelToJSONData] forKey:self.book.filePath];
	});
}

- (void)appendMarkWithCurrentPage:(NSInteger)currentPage {
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[self chapterAtPageIndex:currentPage completion:^id(ZEChapter *chapter, NSInteger index) {
			
			// 获取当前页的文本
			NSString *content =
			[[ZEChapterViewModel newWithChapterModel:chapter] attributedStringAtPageIndex:index].string;
			
			NSRange subStringRange = NSMakeRange(0, (content.length > 100 ? 100 : content.length));
			
			ZEMark *mark = [ZEMark new];
			mark.checkText = [content substringWithRange:subStringRange];
			mark.chapterPath = chapter.contentPath;
			mark.chapterTitle = chapter.title;
			mark.pageRangeString = [chapter.pageArray objectAtIndex:index];
			
			if (!self.book.marks) {
				self.book.marks = [NSArray array];
			}
			
			NSMutableArray *array = [self.book.marks mutableCopy];
			[array addObject:mark];
			
			self.book.marks = array;
			return nil;
		}];
	});
}

- (void)removeMarkWithCurrentPage:(NSInteger)currentPage {
	__weak typeof(self)weakSelf = self;
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[weakSelf chapterAtPageIndex:currentPage completion:^id(ZEChapter *chapter, NSInteger index) {
			
			NSRange range = NSRangeFromString([chapter.pageArray objectAtIndex:index]);
			
			ZEMark *mark = nil;
			
			for (ZEMark *m in weakSelf.book.marks) {
				NSInteger location = NSRangeFromString(m.pageRangeString).location;
				if ((location >= range.location) && location  < range.location + range.length) {
					mark = m;
					break;
				}
			}
			
			if (mark) {
				NSMutableArray *array = [weakSelf.book.marks mutableCopy];
				[array removeObject:mark];
				self.book.marks = array;
			}
			
			return nil;
		}];
	});
}

- (BOOL)isMarkWithCurrentPage:(NSInteger)currentPage {
	__weak typeof(self)weakSelf = self;
	NSNumber *boolNumber = [self chapterAtPageIndex:currentPage completion:^id(ZEChapter *chapter, NSInteger index) {
		NSRange range = NSRangeFromString([chapter.pageArray objectAtIndex:index]);
		
		for (ZEMark *m in weakSelf.book.marks) {
			NSInteger location = NSRangeFromString(m.pageRangeString).location;
			if (((location >= range.location) && location < range.location + range.length) &&
				([m.chapterPath isEqualToString:chapter.contentPath])) {
				return @(YES);
			}
		}
		
		return @(NO);
	}];
	
	return [boolNumber boolValue];
}


#pragma mark - private core method

#pragma mark - private helper


@end
