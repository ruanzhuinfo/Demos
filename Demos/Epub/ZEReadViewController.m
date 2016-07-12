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

@interface ZEReadViewController()<DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate, UIScrollViewDelegate>

@property(nonatomic)UIScrollView *containerScrollView;
@property(nonatomic)DTAttributedTextView *textView;
@property(nonatomic)ZEChapterViewModel *viewModel;
@property(nonatomic)UILabel *bottomInfoLabel;
@property(nonatomic)UILabel *topInfoLabel;
@property(nonatomic)UIButton *markButton;

@end

@implementation ZEReadViewController

+ (instancetype)newWithChapterModel:(ZEChapter *)chapter pageIndex:(NSInteger)index {
	ZEReadViewController *vc = [[ZEReadViewController alloc] init];
	vc.chapter = chapter;
	vc.pageIndexAtChapter = index;
	
	[vc containerScrollViewAppearance];
	[vc textViewAppearanceAtPageIndex:index];
	
	[vc setupTopInfo];
	[vc setupBottomInfo];
	return vc;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self.view bringSubviewToFront:self.bottomInfoLabel];
	[self.view bringSubviewToFront:self.topInfoLabel];
	[self.view bringSubviewToFront:self.markButton];
}

- (void)updateBottomInfoWithPageCount:(NSInteger)pageCount bookTitle:(NSString *)title {
	if (pageCount == 0) {
		self.bottomInfoLabel.text = [NSString stringWithFormat:@"%@ ∙ 页码更新中...", title];
	} else {
		self.bottomInfoLabel.text = [NSString stringWithFormat:@"%@ ∙ %ld / %ld", title, self.currentPage + 1, pageCount];
	}
}

#pragma mark - subView appearance

- (void)containerScrollViewAppearance {
	self.containerScrollView = [[UIScrollView alloc] init];
	[self.containerScrollView setBackgroundColor:[UIColor grayColor]];
	[self.containerScrollView setDelegate:self];
	[self.containerScrollView setShowsVerticalScrollIndicator:NO];
	[self.containerScrollView setShowsHorizontalScrollIndicator:NO];
	[self.containerScrollView setAlwaysBounceVertical:YES];
	[self.view addSubview:self.containerScrollView];
	[self.containerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
}

- (void)textViewAppearanceAtPageIndex:(NSInteger)index {
	self.textView = [self makeAttributedTextView];
	[self.containerScrollView addSubview:self.textView];
	[self.containerScrollView setContentSize:CGSizeMake(self.textView.width, self.textView.height + 0.5)];
	
	self.viewModel = [ZEChapterViewModel newWithChapterModel:self.chapter];
	self.textView.origin = CGPointMake(0, 0);
	self.textView.attributedString = [self.viewModel attributedStringAtPageIndex:index];
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

- (void)setupTopInfo {
	UILabel *title = [[UILabel alloc] init];
	title.text = self.chapter.title;
	title.textColor = [UIColor lightGrayColor];
	title.font = [UIFont systemFontOfSize:13];
	self.topInfoLabel = title;
	[self.containerScrollView addSubview:title];
	[title mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(@10);
		make.top.equalTo(@10);
		make.right.equalTo(self.containerScrollView).offset(-51);
	}];
}

- (void)setupBottomInfo {
	self.bottomInfoLabel = [[UILabel alloc] init];
	self.bottomInfoLabel.textColor = [UIColor lightGrayColor];
	self.bottomInfoLabel.font = [UIFont systemFontOfSize:13];
	self.bottomInfoLabel.textAlignment = NSTextAlignmentRight;
	[self.containerScrollView addSubview:self.bottomInfoLabel];
	[self.bottomInfoLabel setFrame:CGRectMake(10, self.view.height - 25, self.view.width - 20, 15)];
}

- (void)setupMarkButton {
	self.markButton = [[UIButton alloc] init];
	[self.markButton setAlpha:0.0];
	[self.markButton setImage:[UIImage imageNamed:@"Bookmarks_Highlight"]
					 forState:UIControlStateNormal];
	[self.markButton addTarget:self
						action:@selector(didTapMarkButton)
			  forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.markButton];
	
	[self.markButton setFrame:CGRectMake(self.view.width - 46, 0, 26, 26)];
}

- (void)setIsMark:(BOOL)isMark {
	_isMark = isMark;

	if (isMark) {
		if (!self.markButton) {
			[self setupMarkButton];
			[UIView animateWithDuration:0.25 animations:^{
				[self.markButton setAlpha:1.0];
			}];
		}
	} else {
		if (self.markButton) {
			[UIView animateWithDuration:0.25 animations:^{
				[self.markButton setAlpha:0.0];
			} completion:^(BOOL finished) {
				[self.markButton removeFromSuperview];
				self.markButton = nil;
			}];
		}
	}
}


#pragma mark - markButton Selector

- (void)didTapMarkButton {
	if ([self.delegate respondsToSelector:@selector(didTapMarkButton:)]) {
		[self.delegate didTapMarkButton:self];
	}
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	CGFloat offsetY = [scrollView.panGestureRecognizer translationInView:self.containerScrollView].y;
	
	if (offsetY >= 55) {
		if ([self.delegate respondsToSelector:@selector(didEndDragScrollViewFinished:)]) {
			[self.delegate didEndDragScrollViewFinished:self];
		}
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	CGFloat velocitY = [scrollView.panGestureRecognizer velocityInView:self.containerScrollView].y;
	CGFloat positionY = [scrollView.panGestureRecognizer translationInView:self.containerScrollView].y;
	if ((velocitY < 0 && positionY <= 0) || positionY < 0) {
		[scrollView setContentOffset:CGPointZero];
	}
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
