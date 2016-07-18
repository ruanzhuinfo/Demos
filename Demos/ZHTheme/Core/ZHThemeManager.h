//
//  ZHThemeManager.h
//  daily
//
//  Created by taffy on 16/3/10.
//  Copyright © 2016年 Zhihu. All rights reserved.
//


#import "NSObject+Theme.h"

#define zh_image(image) [ZHThemeManager imageWithSelector:@selector(image)]
#define zh_color(color) [ZHThemeManager colorWithSelector:@selector(color)]

UIImage *imageWithSelector(SEL sel);
UIColor *colorWithSelector(SEL sel);

UIStatusBarStyle ZHStausBarStyle();
UIKeyboardAppearance ZHKeyboardAppearance();
UIActivityIndicatorViewStyle ZHActivityIndicatorViewStyle();


/**
 *  app 中所有与主题有关的资源获取逻辑都在这里
 */
@interface ZHThemeManager : NSObject

+ (BOOL)isNightMode;
+ (void)setNightMode:(BOOL)night;

/**
 *  获取一个 UIColor 对象
 *
 *  @param selector 是从 UIColor+theme.h 中拿的方法，
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithSelector:(SEL) selector;

/**
 *  获取一个 UIImage 对象
 *
 *  @param selector 是从 UIImage+theme.h 中拿的方法
 *
 *  @return UIImage
 */
+ (UIImage *)imageWithSelector: (SEL) selector;

/**
 *  在一个 View 上添加一个 color 为 black， alpha 为 0.6 的遮罩
 *
 *  @param inView 会在 inView 上添加一个 subView，但并不影响 inView 的所有交互
 */
+ (void) setupNightShadeInView: (UIView *)inView;

+ (UIStatusBarStyle) stausBarStyle;
+ (UIKeyboardAppearance) keyboardAppearance;
+ (UIActivityIndicatorViewStyle) activityIndicatorViewStyle;

@end






