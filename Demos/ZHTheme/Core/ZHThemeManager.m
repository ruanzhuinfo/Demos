//
//  ZHThemeManager.m
//  daily
//
//  Created by taffy on 16/3/10.
//  Copyright © 2016年 Zhihu. All rights reserved.
//

#import "ZHThemeManager.h"
#import <objc/runtime.h>

static NSString* const nightModeKey = @"NIGHT_MODE_KEY";

#pragma mark - 快捷方法

UIStatusBarStyle ZHStausBarStyle() {
	return [ZHThemeManager stausBarStyle];
}

UIKeyboardAppearance ZHKeyboardAppearance() {
	return [ZHThemeManager keyboardAppearance];
}

UIActivityIndicatorViewStyle ZHActivityIndicatorViewStyle() {
	return [ZHThemeManager activityIndicatorViewStyle];
}

UIImage *imageWithSelector(SEL sel) {
	return [ZHThemeManager imageWithSelector:sel];
}

UIColor *colorWithSelector(SEL sel) {
	return [ZHThemeManager colorWithSelector:sel];
}

@interface ZHThemeManager()

/// 生成 UIImage 的时候，线程是不安全的，必须要在主线程完成，
/// 而在有些 object 中是无法保证当前线程在主线程，所以在 HRThemeManager 中必须回到主线程生成 UIImage 然后返回给 object，
/// 而 tempImage 在这些操纵中只起到了中转数据的作用，对于使用者不必考虑这个变量。
@property (nonatomic, strong) UIImage *tempImage;

@end


@implementation ZHThemeManager

+ (instancetype) shareInstance {
	static ZHThemeManager *manager;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [ZHThemeManager new];
	});
	return manager;
}



#pragma mark - public method

+ (UIColor *)colorWithSelector:(SEL)selector {
	NSString *colorName = NSStringFromSelector(selector);
	
	if ([ZHThemeManager isNightMode]) {
		colorName = [colorName stringByAppendingString:@"_Night"];
	}
	
	return [UIColor performSelector:NSSelectorFromString(colorName)];
}

+ (UIImage *)imageWithSelector:(SEL)selector {
	return [ZHThemeManager imageNamed:NSStringFromSelector(selector)];
}

+ (UIStatusBarStyle) stausBarStyle {
	if ([ZHThemeManager isNightMode]) {
		return UIStatusBarStyleLightContent;
	}
	return UIStatusBarStyleDefault;
}

+ (UIKeyboardAppearance) keyboardAppearance {
	if ([ZHThemeManager isNightMode]) {
		return UIKeyboardAppearanceDark;
	} else {
		return UIKeyboardAppearanceLight;
	}
}

+ (UIActivityIndicatorViewStyle) activityIndicatorViewStyle {
	if ([ZHThemeManager isNightMode]) {
		return UIActivityIndicatorViewStyleGray;
	} else {
		return UIActivityIndicatorViewStyleWhite;
	}
}

+ (void)setNightMode:(BOOL)night {
	[[NSUserDefaults standardUserDefaults] setBool:night forKey:nightModeKey];
	[[NSNotificationCenter defaultCenter] postNotificationName:kNSObjectUpdateThemeNotification object:nil];
}

+ (BOOL)isNightMode {
	return [[NSUserDefaults standardUserDefaults] boolForKey:nightModeKey];
}

+ (void) setupNightShadeInView: (UIView *)inView {
	UIView *shadeContainerView = objc_getAssociatedObject(inView, CFBridgingRetain(inView));
	if ([ZHThemeManager isNightMode]) {
		if (!shadeContainerView) {
			shadeContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, inView.bounds.size.width, 0)];
			UIView *shadeView = [[UIView alloc] initWithFrame:inView.bounds];
			[shadeView setBackgroundColor:[UIColor blackColor]];
			[shadeView setAlpha:0.6];
			[shadeContainerView addSubview:shadeView];
			objc_setAssociatedObject(inView, CFBridgingRetain(inView), shadeContainerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		}
		[inView addSubview:shadeContainerView];
	} else {
		[shadeContainerView removeFromSuperview];
	}
}


#pragma mark - private methond

+ (UIImage *)imageNamed:(NSString *)imageName {
	
	// 当前线程若在主线程，就直接通过 imageWithName：方法拿资源
	if ([NSThread isMainThread]) {
		if ([ZHThemeManager isNightMode]) {
			UIImage *image = [[ZHThemeManager shareInstance]
							  getImageWithName:[imageName
										  stringByReplacingOccurrencesOfString:@"theme_"
										  withString:@"theme_Night_"]];
			if (image) return image;
		}
		return [[ZHThemeManager shareInstance] getImageWithName:imageName];
	}
	
	// 程序走到这里说明当前线程是子线程，所以要通过以下方式获取图片资源
	@synchronized(self) {
		if ([ZHThemeManager isNightMode]) {
			UIImage *image = [[ZHThemeManager shareInstance]
							  imageFromMainThread:[imageName
												   stringByReplacingOccurrencesOfString:@"theme_"
												   withString:@"theme_Night_"]];
			if (image) return image;
		}
		return [[ZHThemeManager shareInstance] imageFromMainThread:imageName];
	}
}


#pragma mark - helper method

- (UIImage *) getImageWithName: (NSString *)imageName {
	UIImage *image = [UIImage performSelector:NSSelectorFromString(imageName)];
	if (image) return image;
	return [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", imageName]];
}

- (UIImage *) imageFromMainThread: (NSString *)name {
	[self performSelectorOnMainThread:@selector(setImageWithName:) withObject:name waitUntilDone:YES];
	return self.tempImage;
}

/**
 *  在主线程获取图片的一个方法
 *
 *  @param name 图片名称
 */
- (void) setImageWithName: (NSString *)name {
	self.tempImage = [self getImageWithName:name];
}



@end
