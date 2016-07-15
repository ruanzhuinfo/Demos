//
//  ZEFootNoteViewController.m
//  Demos
//
//  Created by taffy on 16/7/13.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "ZEFootNoteViewController.h"
#import "ZEBook.h"
#import "ZEChapterViewModel.h"
#import "TFHpple.h"
#import "ZECryptogramManager.h"

@interface ZEFootNoteViewController ()<DTAttributedTextContentViewDelegate>

@property(nonatomic)DTAttributedTextView *textView;
@property(nonatomic)ZEChapterViewModel *viewModel;
@property(nonatomic)ZEBook *book;
@property(nonatomic)ZEChapter *chapter;

@property(nonatomic)NSURL *footNoteURL;
@property(nonatomic)NSString *footNoteID;

@property(nonatomic)CGSize contentSize;

@end

static CGFloat const kMaxContentHeight = 205;
static CGFloat const kTextViewPadding = 15;

@implementation ZEFootNoteViewController

+ (instancetype)newWithBook:(ZEBook *)book footNoteURL:(NSURL *)URL {
	
	ZEFootNoteViewController *fv = [ZEFootNoteViewController new];
	fv.footNoteURL = URL;
	fv.book = book;
	return fv;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	[self.view setBackgroundColor:[UIColor whiteColor]];
	
	[self setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, kMaxContentHeight)];
	
	[self parserFilePath];
	
	self.chapter = [self chapterFromFilePath:self.book.footNotePath];
	
	if (!self.chapter) {
		return;
	}
	
	self.textView = [self makeAttributedTextView];
	self.textView.size = self.contentSize;
	self.textView.contentInset = UIEdgeInsetsMake(kTextViewPadding,
												  kTextViewPadding,
												  kTextViewPadding,
												  kTextViewPadding);
	self.viewModel = [ZEChapterViewModel newWithChapterModel:self.chapter];
	
	self.textView.attributedString =
	[self.viewModel attributedStringWithHTMLData:[self partHtmlData]
									documentPath:[NSURL fileURLWithPath:self.chapter.contentPath]];
	[self.view addSubview:self.textView];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	CGSize layoutFrameSize = self.textView.attributedTextContentView.layoutFrame.frame.size;
	[self setContentSize:CGSizeMake(layoutFrameSize.width + kTextViewPadding * 2,
									layoutFrameSize.height + kTextViewPadding * 2)];
	[self.textView setHeight:self.contentSize.height];
	[self setPreferredContentSize:self.contentSize];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (DTAttributedTextView *)makeAttributedTextView {
	DTAttributedTextView *dt = [[DTAttributedTextView alloc] init];
	dt.origin = CGPointMake(0, 0);
	dt.shouldDrawImages = NO;
	dt.shouldDrawLinks = NO;
	dt.textDelegate = self;
	dt.scrollEnabled = YES;
	return dt;
}

- (void)setContentSize:(CGSize)contentSize {
	
	if (contentSize.height > kMaxContentHeight) {
		contentSize.height = kMaxContentHeight;
	}
	
	_contentSize = contentSize;
}



#pragma mark - helper

- (void)parserFilePath {
	
	if (!self.footNoteURL) {
		return;
	}

	NSArray * array = [self.footNoteURL.absoluteString componentsSeparatedByString:self.footNoteURL.relativePath];
	
	if (array.count != 2) {
		return;
	}
	
	self.footNoteID = [[array lastObject] substringFromIndex:1];
}

- (ZEChapter *)chapterFromFilePath:(NSString *)filePath {
	
	for (ZEChapter *c in self.book.chapters) {
		if ([c.contentPath isEqualToString:filePath]) {
			return c;
		}
	}
	
	return nil;
}

- (NSData *)partHtmlData {
	
	if (!self.chapter) {
		return nil;
	}
	
	NSData *data = self.chapter.contentData;
	
	if (!data) {
		data = [NSData dataWithContentsOfFile:self.chapter.contentPath];
		if (self.chapter.isEncrypt) {
			data = [[ZECryptogramManager sharedInstance] decryptWithData:data];
		}
	}
	
	// 解析想要那段 HTML
	TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
	NSArray<TFHppleElement *> *elements = [doc searchWithXPathQuery:@"//a[@id]/.."];
	
	for (TFHppleElement *e in elements) {
		NSArray<TFHppleElement *> *noteIDs = [e searchWithXPathQuery:[NSString stringWithFormat:@"//a[@id='%@']", self.footNoteID]];
		if (noteIDs.count > 0) {
			NSString *html = [e.raw stringByReplacingOccurrencesOfString:noteIDs.firstObject.raw withString:@""];
			return [html dataUsingEncoding:NSUTF8StringEncoding];
		}
	}
	
	return nil;
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

- (void)linkLongPressed:(UILongPressGestureRecognizer *)gesture {
	if (gesture.state == UIGestureRecognizerStateBegan) {
		DTLinkButton *button = (id)[gesture view];
		button.highlighted = NO;
	}
}





@end
