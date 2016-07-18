//
//  ZEReadViewController+Draw.m
//  Demos
//
//  Created by taffy on 16/7/14.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "ZEReadViewController+Draw.h"
#import "ZEFootNoteViewController.h"
#import "ZEBook.h"

@implementation ZEReadViewController (Draw)


#pragma mark - Custom Views on Text

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttributedString:(NSAttributedString *)string frame:(CGRect)frame {
	NSDictionary *attributes = [string attributesAtIndex:0 effectiveRange:NULL];
	
	NSURL *URL = [attributes objectForKey:DTLinkAttribute];
	NSString *identifier = [attributes objectForKey:DTGUIDAttribute];
	
	DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
	button.URL = URL;
	button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
	button.GUID = identifier;
	
	// 注解按钮
	if ([self isFootNoteFile:URL]) {
		zh_updateThemeWithBlock(button, ^{
			[button setImage:imageWithSelector(@selector(image_Read_Note)) forState:UIControlStateNormal];
		}, button);
		[button addTarget:self action:@selector(didTapNoteButton:) forControlEvents:UIControlEventTouchUpInside];
		return button;
	}
	
	UIImage *normalImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDefault];
	[button setImage:normalImage forState:UIControlStateNormal];
	
	UIImage *highlightImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDrawLinksHighlighted];
	[button setImage:highlightImage forState:UIControlStateHighlighted];
	
	[button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
	
	// 图片不可点
	if ([attributes objectForKey:DTAttachmentParagraphSpacingAttribute]) {
		[button setUserInteractionEnabled:NO];
		return button;
	}
	
	return button;
}

- (BOOL)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView shouldDrawBackgroundForTextBlock:(DTTextBlock *)textBlock frame:(CGRect)frame context:(CGContextRef)context forLayoutFrame:(DTCoreTextLayoutFrame *)layoutFrame {
	
	UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(frame,1,1) cornerRadius:10];
	
	CGColorRef color = [textBlock.backgroundColor CGColor];
	if (color) {
		CGContextSetFillColorWithColor(context, color);
		CGContextAddPath(context, [roundedRect CGPath]);
		CGContextFillPath(context);
		
		CGContextAddPath(context, [roundedRect CGPath]);
		CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
		CGContextStrokePath(context);
		return NO;
	}
	
	return YES;
}

#pragma mark Actions

- (void)didTapNoteButton:(DTLinkButton *)button {
	NSURL *URL = button.URL;
	ZEFootNoteViewController *vc = [ZEFootNoteViewController newWithBook:self.book footNoteURL:URL];
	vc.modalPresentationStyle = UIModalPresentationPopover;
	vc.popoverPresentationController.sourceView = button;
	vc.popoverPresentationController.sourceRect = button.bounds;
	vc.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown;
	zh_addThemeWithBlock(vc, ^{
		[vc.popoverPresentationController setBackgroundColor:colorWithSelector(@selector(color_BG06))];
	});
	vc.popoverPresentationController.delegate = self;
	[self presentViewController:vc animated:YES completion:nil];
}

- (void)linkPushed:(DTLinkButton *)button {
	NSURL *URL = button.URL;
	
	// 打开本地 url
	// 实际是跳转到章节
	if ([URL.absoluteString hasPrefix:@"file://"]) {
		return;
	}
	
	if ([[UIApplication sharedApplication] canOpenURL:[URL absoluteURL]]) {
		[[UIApplication sharedApplication] openURL:[URL absoluteURL]];
	}
}

#pragma mark - UIPopoverPresentationViewController delegate

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
	return UIModalPresentationNone;
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
	return YES;
}


#pragma mark - helper method

- (BOOL)isFootNoteFile:(NSURL *)url {
	
	if (![url.path isEqualToString:self.book.footNotePath]) {
		return NO;
	}
	
	NSArray * array = [url.absoluteString componentsSeparatedByString:url.relativePath];
	
	if (array.count != 2) {
		return NO;
	}
	
	if (![array.lastObject hasPrefix:@"#"]) {
		return NO;
	}
	
	return YES;
}

@end
