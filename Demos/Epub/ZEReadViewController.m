//
//  ZEReadViewController.m
//  Demos
//
//  Created by taffy on 16/6/30.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "ZEReadViewController.h"
#import "DTCoreText.h"
#import "ZEChapter.h"
#import "ZEChapterViewModel.h"
#import "ZEReadStyleConfig.h"

@interface ZEReadViewController()<DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate>

@property(nonatomic)DTAttributedTextView *textView;
@property(nonatomic)ZEChapterViewModel *viewModel;

@end

@implementation ZEReadViewController

+ (instancetype)newWithChapterModel:(ZEChapter *)chapter pageIndex:(NSInteger)index {
	ZEReadViewController *vc = [[ZEReadViewController alloc] init];
	vc.chapter = chapter;
	[vc textViewAppearanceAtPageIndex:index];
	
	return vc;
}

- (void)textViewAppearanceAtPageIndex:(NSInteger)index {
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
		self.viewModel = [ZEChapterViewModel newWithChapterModel:self.chapter];
		self.textView = [self makeAttributedTextView];
		self.textView.origin = CGPointMake(0, 0);
		self.textView.attributedString = [self.viewModel attributedStringAtPageIndex:index];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.view addSubview:self.textView];
		});
	});
}

- (DTAttributedTextView *)makeAttributedTextView {
	DTAttributedTextView *dt = [[DTAttributedTextView alloc] init];
	dt.size = [ZEReadStyleConfig sharedInstance].viewSize;
	dt.contentInset = [ZEReadStyleConfig sharedInstance].edgeInsets;
	dt.shouldDrawImages = NO;
	dt.shouldDrawLinks = NO;
	dt.textDelegate = self;
	dt.scrollEnabled = NO;
	
	return dt;
}

#pragma mark - Custom Views on Text

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttributedString:(NSAttributedString *)string frame:(CGRect)frame {
	NSDictionary *attributes = [string attributesAtIndex:0 effectiveRange:NULL];
	
	NSURL *URL = [attributes objectForKey:DTLinkAttribute];
	NSString *identifier = [attributes objectForKey:DTGUIDAttribute];
	
	
	DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
	button.URL = URL;
	button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
	button.GUID = identifier;
	
	// get image with normal link text
	UIImage *normalImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDefault];
	[button setImage:normalImage forState:UIControlStateNormal];
	
	// get image for highlighted link text
	UIImage *highlightImage = [attributedTextContentView contentImageWithBounds:frame options:DTCoreTextLayoutFrameDrawingDrawLinksHighlighted];
	[button setImage:highlightImage forState:UIControlStateHighlighted];
	
	// use normal push action for opening URL
	[button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
	
	// demonstrate combination with long press
	UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
	[button addGestureRecognizer:longPress];
	
	return button;
}

//
//- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame {
//	if ([attachment isKindOfClass:[DTImageTextAttachment class]]) {
		// if the attachment has a hyperlinkURL then this is currently ignored
//		DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
//		imageView.delegate = self;
//		
//		// sets the image if there is one
////		imageView.image = [(DTImageTextAttachment *)attachment image];
//		
//		// url for deferred loading
//		imageView.url = attachment.contentURL;
//		
//		
//		[imageView setSize:attachment.originalSize];
//		
//		
//		if ([attachment.attributes objectForKey:@"height"]) {
//			NSMutableDictionary *dic = [attachment.attributes mutableCopy];
//			[dic setObject:@"" forKey:<#(nonnull id<NSCopying>)#>]
//		}
		
//		return imageView;
//	}

//	return nil;
//}

- (BOOL)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView shouldDrawBackgroundForTextBlock:(DTTextBlock *)textBlock frame:(CGRect)frame context:(CGContextRef)context forLayoutFrame:(DTCoreTextLayoutFrame *)layoutFrame {
	UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(frame,1,1) cornerRadius:10];
	
	CGColorRef color = [textBlock.backgroundColor CGColor];
	if (color)
	{
		CGContextSetFillColorWithColor(context, color);
		CGContextAddPath(context, [roundedRect CGPath]);
		CGContextFillPath(context);
		
		CGContextAddPath(context, [roundedRect CGPath]);
		CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
		CGContextStrokePath(context);
		return NO;
	}
	
	return YES; // draw standard background
}

#pragma mark Actions

- (void)linkPushed:(DTLinkButton *)button {
	NSURL *URL = button.URL;
	
	if ([[UIApplication sharedApplication] canOpenURL:[URL absoluteURL]]) {
		[[UIApplication sharedApplication] openURL:[URL absoluteURL]];
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex != actionSheet.cancelButtonIndex) {
		//		[[UIApplication sharedApplication] openURL:[self.lastActionLink absoluteURL]];
	}
}

- (void)linkLongPressed:(UILongPressGestureRecognizer *)gesture {
	if (gesture.state == UIGestureRecognizerStateBegan) {
		DTLinkButton *button = (id)[gesture view];
		button.highlighted = NO;
		//		self.lastActionLink = button.URL;
		
		if ([[UIApplication sharedApplication] canOpenURL:[button.URL absoluteURL]]) {
			//			UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:[[button.URL absoluteURL] description] delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Open in Safari", nil];
			//			[action showFromRect:button.frame inView:button.superview animated:YES];
		}
	}
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
	if (gesture.state == UIGestureRecognizerStateRecognized) {
		CGPoint location = [gesture locationInView:_textView];
		NSUInteger tappedIndex = [_textView closestCursorIndexToPoint:location];
		
		NSString *plainText = [_textView.attributedString string];
		NSString *tappedChar = [plainText substringWithRange:NSMakeRange(tappedIndex, 1)];
		
		__block NSRange wordRange = NSMakeRange(0, 0);
		
		[plainText enumerateSubstringsInRange:NSMakeRange(0, [plainText length]) options:NSStringEnumerationByWords usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
			if (NSLocationInRange(tappedIndex, enclosingRange)) {
				*stop = YES;
				wordRange = substringRange;
			}
		}];
		
		NSString *word = [plainText substringWithRange:wordRange];
		NSLog(@"%lu: '%@' word: '%@'", (unsigned long)tappedIndex, tappedChar, word);
	}
}

- (void)dealloc {}

@end
