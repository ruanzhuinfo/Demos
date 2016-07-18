//
//  ZEProgressView.m
//  Demos
//
//  Created by taffy on 16/7/8.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "ZEProgressView.h"

@interface ZEProgressView()

@property(nonatomic)UIProgressView *progressView;
@property(nonatomic)UIView *progressBar;

@property(nonatomic)UIView *tipView;
@property(nonatomic)UILabel *titleLabel;
@property(nonatomic)UILabel *rateLabel;
@property(nonatomic)UIButton *backButton;

@property(nonatomic)BOOL activate;

@property(nonatomic)CGFloat previousProgress;

@property(nonatomic)CGFloat backButtonRotate;

@end

@implementation ZEProgressView


- (instancetype)init {
	self = [super init];
	if (self) {
		[self setupProgress];
		
		UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanProgressBar:)];
		[self addGestureRecognizer:pan];
	}
	
	return self;
}

- (void)setProgress:(float)progress {

	_progress = progress;
	[self layoutProgressViewWithProgress:_progress];
}

- (void)layoutProgressViewWithProgress:(CGFloat)progress {
	
	if (!self.tipView) {
		CGFloat tipViewHeight = 47.0;
		self.tipView = [[UIView alloc] init];
		[self.tipView.layer setCornerRadius:tipViewHeight/2];
		[self.tipView setHidden:YES];
		[self.tipView setAlpha:0.0];
		[self.superview addSubview:self.tipView];
		[self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.height.equalTo(@(tipViewHeight));
			make.width.lessThanOrEqualTo(@250).priorityHigh();
			make.bottom.equalTo(self.superview).offset(-self.height - 25);
		}];
		
		UIView *vLine = [[UIView alloc] init];
		[self.tipView addSubview:vLine];
		[vLine mas_makeConstraints:^(MASConstraintMaker *make) {
			make.width.equalTo(@0.5);
			make.bottom.equalTo(self.tipView).offset(-11);
			make.top.equalTo(self.tipView).offset(11);
		}];
		
		self.titleLabel = [[UILabel alloc] init];
		[self.titleLabel setFont:[UIFont systemFontOfSize:14]];
		[self.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
		[self.tipView addSubview:self.titleLabel];
		[self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.tipView).offset(18);
			make.right.equalTo(vLine.mas_left).offset(-7);
			make.top.equalTo(self.tipView).offset(6);
		}];
		
		self.rateLabel = [[UILabel alloc] init];
		[self.rateLabel setFont:[UIFont systemFontOfSize:13]];
		[self.tipView addSubview:self.rateLabel];
		[self.rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(self.titleLabel);
			make.right.equalTo(vLine.mas_left).offset(-7);
			make.top.equalTo(self.titleLabel.mas_bottom).offset(2);
			make.bottom.equalTo(self.tipView).offset(-6);
		}];
		
		self.backButton = [[UIButton alloc] init];
		[self.backButton addTarget:self action:@selector(didTapBackButton) forControlEvents:UIControlEventTouchUpInside];
		[self.backButton setEnabled:NO];
		[self.tipView addSubview:self.backButton];
		[self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
			make.width.equalTo(@54);
			make.left.equalTo(vLine.mas_right);
			make.top.equalTo(self.tipView);
			make.right.equalTo(self.tipView);
			make.bottom.equalTo(self.tipView);
		}];
		
		
		zh_updateThemeWithBlock(self, ^{
			[self.tipView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.9]];
			[self.titleLabel setTextColor:colorWithSelector(@selector(color_BG06))];
			[self.rateLabel setTextColor:[UIColor colorWithWhite:1 alpha:0.7]];
			[self.backButton setImage:imageWithSelector(@selector(image_Read_Return_Invalid)) forState:UIControlStateNormal];
			
			[vLine setBackgroundColor:colorWithSelector(@selector(color_LINE02))];
		}, self.tipView);
	}
	
	[self.progressView setProgress:progress];
	[self.progressBar mas_updateConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.progressView).offset(progress * self.progressView.width - self.progressBar.width / 2);
	}];
}

- (void)updateText:(NSString *)title rateString:(NSString *)rateString {
	[self.tipView setHidden:NO];
	[UIView animateWithDuration:0.25 animations:^{
		[self.tipView setAlpha:1.0];
	}];
	
	self.titleLabel.text = title;
	self.rateLabel.text = rateString;
}

- (void)showProgressBar {
	[self mas_updateConstraints:^(MASConstraintMaker *make) {
		make.bottom.equalTo(self.superview);
	}];
	
	[self layoutIfNeeded];
}

- (void)hiddenProgressBar {
	[self mas_updateConstraints:^(MASConstraintMaker *make) {
		make.bottom.mas_equalTo(100);
	}];
	
	[self layoutIfNeeded];

	if (self.hiddenTipViewBlock) {
		self.hiddenTipViewBlock();
	}
}



#pragma mark - view appearance

- (void)setupProgress {
	
	UILabel *title = [[UILabel alloc] init];
	[title setText:@"进度"];
	[title setFont:[UIFont systemFontOfSize:14]];
	[self addSubview:title];
	[title mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(self);
		make.left.equalTo(self).offset(10);
	}];
	
	UIProgressView *pv = [[UIProgressView alloc] init];
	[pv.layer setCornerRadius:2.5];
	[pv.layer setMasksToBounds:YES];
	[pv setProgressViewStyle:UIProgressViewStyleDefault];
	[self addSubview:pv];
	self.progressView = pv;
	[pv mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(title.mas_right).offset(10);
		make.centerY.equalTo(self);
		make.right.equalTo(self).offset(-10);
		make.height.mas_equalTo(5);
	}];
	
	
	CGFloat barSize = 15.0;
	UIView *pvBar = [[UIView alloc] init];
	[pvBar.layer setCornerRadius:barSize/2];
	CALayer *l = [[CALayer alloc] init];
	[l setFrame:CGRectMake(0.5, 0.5, barSize - 1, barSize - 1)];
	[l setCornerRadius:(barSize - 1)/2];
	[pvBar.layer addSublayer:l];
	
	[self addSubview:pvBar];
	self.progressBar = pvBar;
	[pvBar mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(self);
		make.size.mas_equalTo(CGSizeMake(15, 15));
	}];
	
	UIView *line = [[UIView alloc] init];
	[self addSubview:line];
	[line mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self);
		make.right.equalTo(self);
		make.top.equalTo(self);
		make.height.equalTo(@0.5);
	}];
	
	zh_addThemeWithBlock(self, ^{
		[self setBackgroundColor:colorWithSelector(@selector(color_BG06))];
		[title setTextColor:colorWithSelector(@selector(color_W04))];
		[pv setTintColor:colorWithSelector(@selector(color_VOTE))];
		[pv setTrackTintColor:colorWithSelector(@selector(color_R02))];
		[pvBar setBackgroundColor:colorWithSelector(@selector(color_BG06))];
		[l setBackgroundColor:colorWithSelector(@selector(color_BLUE)).CGColor];
		[line setBackgroundColor:colorWithSelector(@selector(color_R02))];
	});
}


#pragma mark - UIPanGestureRecognizer method

- (void)didPanProgressBar:(UIPanGestureRecognizer *)pan {
	
	CGPoint location = [pan locationInView:self];
	
	switch(pan.state) {
		case UIGestureRecognizerStateBegan:{
			CGRect containsRect = CGRectMake(self.progressBar.x - 15,
											 self.progressBar.y - 15,
											 self.progressBar.width + 30,
											 self.progressBar.height + 30);
			
			if (CGRectContainsPoint(containsRect, location)) {
				self.activate = YES;
				self.previousProgress = self.progress;
			}
		}
		case UIGestureRecognizerStateChanged: {
			if (self.activate) {
				CGFloat offsetX = [pan locationInView:self.progressView].x;
				if (offsetX <= self.progressView.width && offsetX >= 0) {
					
					self.progress = offsetX/self.progressView.width;
					if ([self.delegate respondsToSelector:@selector(didPanProgressBarWithProgress:)]) {
						[self.delegate didPanProgressBarWithProgress:self.progress];
						
					}
				}
			}
			break;
		}
		case UIGestureRecognizerStateFailed:
		case UIGestureRecognizerStateCancelled:
		case UIGestureRecognizerStatePossible:
		case UIGestureRecognizerStateEnded: {
			if (self.activate) {
				if ([self.delegate respondsToSelector:@selector(panProgressBarDidEndWithProgress:)]) {
					[self.delegate panProgressBarDidEndWithProgress:self.progress];
				}
			}
			
			[self setBackButtonEnable:YES];
			
			self.activate = NO;
			
			// 隐藏 tipView
			
			__weak typeof(self) weakSelf = self;
			self.hiddenTipViewBlock = ^{
				[UIView animateWithDuration:0.25 animations:^{
					[weakSelf.tipView setAlpha:0.0];
				} completion:^(BOOL finished) {
					[weakSelf.tipView setHidden:YES];
				}];
				
				[weakSelf setBackButtonEnable:NO];
			};
			
//			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//				if (self.hiddenTipViewBlock) {
//					self.hiddenTipViewBlock();
//				}
//				self.hiddenTipViewBlock = nil;
//			});
			break;
		}
	}
}

#pragma mark - backButton method

- (void)didTapBackButton {
	if ([self.delegate respondsToSelector:@selector(didTapBackButtonWithProgress:)]) {

		// 当前进度和上一次进度交换
		CGFloat temp = self.previousProgress;
		self.previousProgress = self.progress;
		
		// 显示上一次的页面
		[self.delegate didTapBackButtonWithProgress:temp];
		
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			// 按钮旋转
			if (!self.backButtonRotate) {
				self.backButtonRotate = -(180.f * M_PI / 180.f);
			} else {
				self.backButtonRotate = 0.f;
			}
		});
	}
}


#pragma mark - private method

- (void)setBackButtonEnable:(BOOL)enable {
	if(enable) {
		zh_updateThemeWithBlock(self, ^{
			[self.backButton setImage:imageWithSelector(@selector(image_Read_Return))
							 forState:UIControlStateNormal];
		}, self.backButton);
		[self.backButton setEnabled:YES];
	} else {
		zh_updateThemeWithBlock(self, ^{
			[self.backButton setImage:imageWithSelector(@selector(image_Read_Return_Invalid))
							 forState:UIControlStateNormal];
		}, self.backButton);
		[self.backButton setEnabled:NO];
		self.backButtonRotate = 0.f;
	}
}

- (void)setBackButtonRotate:(CGFloat)backButtonRotate {
	_backButtonRotate = backButtonRotate;
	[UIView animateWithDuration:0.25 animations:^{
		CATransform3D transform = CATransform3DIdentity;
		transform.m34 = 1.0 / -500;
		transform = CATransform3DRotate(transform, backButtonRotate, 0.f, 1.f, 0.f);
		self.backButton.imageView.layer.transform = transform;
	}];
}

@end
