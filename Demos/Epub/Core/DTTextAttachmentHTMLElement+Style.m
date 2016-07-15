//
//  DTTextAttachmentHTMLElement+Style.m
//  Demos
//
//  Created by taffy on 16/7/13.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "DTTextAttachmentHTMLElement+Style.h"
#import "MethodSwizzle.h"

@implementation DTTextAttachmentHTMLElement (Style)

- (void)applyStyleDictionary:(NSDictionary *)styles {
	// element size is determined in super (tag attribute and style)
	[super applyStyleDictionary:styles];
	
	// at this point we have the size from width/height attribute or style in _size
	
	// set original size if it was previously unknown
	if (CGSizeEqualToSize(CGSizeZero, _textAttachment.originalSize)) {
		_textAttachment.originalSize = _size;
	}
	
	// update the display size
//	[_textAttachment setDisplaySize:_size withMaxDisplaySize:self.maxDisplaySize];
}


@end
