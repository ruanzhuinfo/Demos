//
//  ZEProgressView.h
//  Demos
//
//  Created by taffy on 16/7/8.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZEProgressViewDelegate <NSObject>

- (id)didPanProgressBarWithProgress:(CGFloat)progress;
- (void)panProgressBarDidEndWithProgress:(CGFloat)progress;
- (void)didTapBackButtonWithProgress:(CGFloat)progress;

@end


@interface ZEProgressView : UIView

@property(nonatomic)void(^hiddenTipViewBlock)();
@property(nonatomic)float progress;
@property(nonatomic,weak)id<ZEProgressViewDelegate> delegate;

- (void)updateText:(NSString *)title rateString:(NSString *)rateString;

- (void)showProgressBar;
- (void)hiddenProgressBar;


@end
