//
//  ZEReadViewController.m
//  Demos
//
//  Created by taffy on 16/6/30.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "ZEReadViewController.h"
#import "ZEChapter.h"
#import "ZEChapterViewModel.h"
#import "ZEReadStyleConfig.h"
#import "ZEReadViewController+Draw.h"

@interface ZEReadViewController()<UIScrollViewDelegate>

@property(nonatomic)UIScrollView *containerScrollView;
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
		self.bottomInfoLabel.text = [NSString stringWithFormat:@"%@ ∙ %ld / %ld", title, self.currentPage + 1, (long)pageCount];
	}
}

#pragma mark - subView appearance

- (void)containerScrollViewAppearance {
	self.containerScrollView = [[UIScrollView alloc] init];
	zh_addThemeWithBlock(self, ^{
		[self.containerScrollView setBackgroundColor:colorWithSelector(@selector(color_LINE02))];
	});
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
	zh_updateThemeWithBlock(dt, ^{
		[dt setBackgroundColor:colorWithSelector(@selector(color_BG07))];
	}, dt);
	
	return dt;
}

- (void)setupTopInfo {
	UILabel *title = [[UILabel alloc] init];
	title.text = self.chapter.title;
	zh_addThemeWithBlock(title, ^{
		title.textColor = colorWithSelector(@selector(color_W04));
	});
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
	zh_addThemeWithBlock(self, ^{
		self.bottomInfoLabel.textColor = colorWithSelector(@selector(color_W04));
	});
	self.bottomInfoLabel.font = [UIFont systemFontOfSize:13];
	self.bottomInfoLabel.textAlignment = NSTextAlignmentRight;
	[self.containerScrollView addSubview:self.bottomInfoLabel];
	[self.bottomInfoLabel setFrame:CGRectMake(10, self.view.height - 25, self.view.width - 20, 15)];
}

- (void)setupMarkButton {
	self.markButton = [[UIButton alloc] init];
	[self.markButton setFrame:CGRectMake(self.view.width - 46, 0, 26, 26)];
	[self.markButton setAlpha:0.0];
	zh_addThemeWithBlock(self, ^{
		[self.markButton setImage:imageWithSelector(@selector(image_Bookmarks_Highlight))
						 forState:UIControlStateNormal];
	});
	
	[self.markButton addTarget:self
						action:@selector(didTapMarkButton)
			  forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.markButton];
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

- (void)dealloc {
	NSLog(@"ZEReadViewController dealloc!!");
}

@end
