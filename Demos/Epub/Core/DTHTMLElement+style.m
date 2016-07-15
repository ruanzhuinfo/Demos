//
//  DTHTMLElement+style.m
//  Demos
//
//  Created by taffy on 16/7/6.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import <objc/runtime.h>
#import "MethodSwizzle.h"

#import "DTHTMLElement+style.h"
#import "ZEReadStyleConfig.h"
#import "DTHTMLParserNode.h"

@implementation DTHTMLElement (style)

+ (void)load {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		MethodSwizzle(self,
					  @selector(initWithName:attributes:options:),
					  @selector(ze_initWithName:attributes:options:));
	});
}


- (instancetype)ze_initWithName:(NSString *)name
					 attributes:(NSDictionary *)attributes options:(NSDictionary *)options {
	
	//  会强制做一些对 html 标签属性的修改或判断
	
	return [self ze_initWithName:name attributes:attributes options:options];
}




















#pragma mark - custom method

- (void)customElementStyle {
	
	// 图片
//	if ([self isKindOfClass:DTTextAttachmentHTMLElement.class]) {
//		[self reviseTextAttachmentSize];
//	}
	
//	self.textColor = [ZEReadStyleConfig sharedInstance].textColor;
//	self.fontDescriptor.pointSize = [ZEReadStyleConfig sharedInstance].defaultFontSize;
//	self.paragraphStyle.minimumLineHeight = [ZEReadStyleConfig sharedInstance].lineSpacing;
	self.underlineStyle = kCTUnderlineStyleNone;
//

}


#pragma mark - private core method

/// 有些图片的 style＝ @“100%”, DT 默认都给修成了 size为 （17， 20）的大小了，这是不对的
- (void)reviseTextAttachmentSize {
	
	if (![self attributeForKey:@"width"] && ![self attributeForKey:@"height"]) {
		[self.textAttachment setDisplaySize:self.textAttachment.originalSize
						 withMaxDisplaySize:[ZEReadStyleConfig sharedInstance].maxImageSize];
	}
}


@end
