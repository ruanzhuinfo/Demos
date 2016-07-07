//
//  ZEChapterViewModel.m
//  Demos
//
//  Created by taffy on 16/7/1.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "ZEChapterViewModel.h"
#import "ZEReadStyleConfig.h"
#import "NSData+AES128.h"
#import "DTHTMLElement+style.h"

@interface ZEChapterViewModel()

@property(nonatomic)ZEReadStyleConfig *styleConfig;
@property(nonatomic)NSMutableAttributedString *contentAttributedString;

@end

@implementation ZEChapterViewModel

+ (instancetype)newWithChapterModel:(ZEChapter *)chapter {
	ZEChapterViewModel *viewModel = [ZEChapterViewModel new];
	viewModel.styleConfig = [ZEReadStyleConfig sharedInstance];
	viewModel.chapter = chapter;
	return viewModel;
}


#pragma mark - public method

- (NSInteger)estimatePageCount {
	self.chapter.pageArray = [self pageArrayFromAttributedString:self.contentAttributedString];
	self.chapter.pageCount = self.chapter.pageArray.count;
	return self.chapter.pageCount;
}

- (NSAttributedString *)attributedStringAtPageIndex:(NSInteger)index {
	if (index >= self.chapter.pageCount || index < 0) {
		NSLog(@"pageIndex 出错了！ index:%ld---count:%ld", index, self.chapter.pageCount);
		return nil;
	}
	
	NSRange range = NSRangeFromString(self.chapter.pageArray[index]);
	return [self.contentAttributedString attributedSubstringFromRange:range];
}


#pragma mark - private core method

/// 生成一个 NSAttributedString
- (NSAttributedString *)contentAttributedString {
	if (_contentAttributedString) {
		return _contentAttributedString;
	}
	
	void (^customTextAttachmentBlock)(DTHTMLElement *) = ^(DTHTMLElement *element) {
		
		[self parserHTMLElemet:element nodeBlock:^(DTHTMLElement *node) {
			// 自定义样式
			[node customElementStyle];
		}];
	};
	
	NSDictionary *options =
	@{
	  DTMaxImageSize: [NSValue valueWithCGSize:_styleConfig.maxImageSize],
	  NSTextSizeMultiplierDocumentOption: @(_styleConfig.textSizeMultiplier),
	  DTDefaultLineHeightMultiplier: [NSNumber numberWithFloat:_styleConfig.LineHeightMultiplier],
	  DTWillFlushBlockCallBack: [customTextAttachmentBlock copy],
	  NSBaseURLDocumentOption: [NSURL fileURLWithPath:self.chapter.contentPath],
	  };
	
	_contentAttributedString =
	[[NSMutableAttributedString alloc] initWithHTMLData:[self getChapterData]
												options:options
									 documentAttributes:nil];
	return _contentAttributedString;
}

/**
 *  遍历出每个节点
 *
 *  @param element   跟节点
 *  @param nodeBlock 每个节点的回调
 */
- (void)parserHTMLElemet:(DTHTMLElement *)element nodeBlock:(void(^)(DTHTMLElement *))nodeBlock {
	nodeBlock(element);
	
	if (element.childNodes.count > 0) {
		
		[element.childNodes enumerateObjectsUsingBlock:
		 ^(DTHTMLElement*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			 
			[self parserHTMLElemet:obj nodeBlock:nodeBlock];
		}];
	}
}


/**
 *  根据一个 NSAttributedString 计算出一章节需要分的页数和每页在 NSAttributedString.string 中的 range
 */
- (NSArray<NSString *> *)pageArrayFromAttributedString:(NSAttributedString *)attributedString {
	
	// 通过 DTCoreText 配置出 frameSetter
	DTCoreTextLayouter *layouter = [[DTCoreTextLayouter alloc] initWithAttributedString:attributedString];
	ZEReadStyleConfig *c = _styleConfig;
	CGRect rect = CGRectMake(c.edgeInsets.left,
							 c.edgeInsets.top,
							 c.viewSize.width - c.edgeInsets.right * 2,
							 c.viewSize.height - c.edgeInsets.bottom * 2);
	
	NSMutableArray<NSString *> *array = [NSMutableArray array];
	NSInteger samePlaceRepeatCount = 0;
	NSInteger offset = 0;
	
	while(samePlaceRepeatCount < 2) {
		DTCoreTextLayoutFrame *layoutFrame =
		[layouter layoutFrameWithRect:rect
								range:NSMakeRange(offset, layouter.attributedString.string.length)];
		
		NSRange range = [layoutFrame visibleStringRange];
		
		if (array.lastObject) {
			NSRange lastRange = NSRangeFromString(array.lastObject);
			if (range.location == lastRange.location) {
				samePlaceRepeatCount ++;
				continue;
			}
		}
		
		if (range.length == 0 || range.length == NSNotFound) {
			break;
		}
		
		offset = range.length + range.location;
		[array addObject:NSStringFromRange(range)];
	}
	
	return array;
}

/// 从文件中获取本章节内容。
- (NSData *)getChapterData {
	if (!self.chapter.contentData) {
		NSData *data = [NSData dataWithContentsOfFile:self.chapter.contentPath];
		
		if (self.chapter.isEncrypt) {
			data  = [data AES128CFBDecryptWithBase64:@"UPIkeH3pD9JBYWlp7Ag8YQ=="];
		}
		
		NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		
		//  去掉不可控的 <br> 标签，用 paragraphStyle 代替
		html = [html stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
		
//		NSLog(@"%@", html);
		
		self.chapter.contentData = [html dataUsingEncoding:NSUTF8StringEncoding];
	}
	
	return self.chapter.contentData;
}

#pragma mark - helper method

- (NSInteger)indexOfPageArray:(NSInteger)index {
	return [self.chapter.pageArray[index] integerValue];
}

- (void)dealloc {

}

@end
