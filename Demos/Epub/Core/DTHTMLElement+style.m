//
//  DTHTMLElement+style.m
//  Demos
//
//  Created by taffy on 16/7/6.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "DTHTMLElement+style.h"
#import "ZEReadStyleConfig.h"

@implementation DTHTMLElement (style)


- (void)customElementStyle {
	
	// 图片
	if ([self isKindOfClass:DTTextAttachmentHTMLElement.class]) {
		[self reviseTextAttachmentSize];
	}
	
	self.textColor = [ZEReadStyleConfig sharedInstance].textColor;
	self.fontDescriptor.pointSize = [ZEReadStyleConfig sharedInstance].defaultFontSize;
	self.paragraphStyle.minimumLineHeight = [ZEReadStyleConfig sharedInstance].lineSpacing;
	
	if ([self.name isEqualToString:@"p"]) {
		if (!self.childNodes.count) {
			
		}
	}
	
	
	
	
	
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
