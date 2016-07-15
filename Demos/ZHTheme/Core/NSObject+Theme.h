//
//  NSObject+Theme.h
//  daily
//
//  Created by taffy on 16/3/16.
//  Copyright © 2016年 Zhihu. All rights reserved.
//

#define zh_addThemeWithBlock(obj, block) \
__weak typeof(obj) weak_##obj = obj; \
[obj addThemeWithBlock:^{ \
	__strong typeof(weak_##obj) obj = weak_##obj; \
	block(); \
}]; \

#define zh_updateThemeWithBlock(obj, block, keyView) \
__weak typeof(obj) weak_##obj = obj; \
[obj updateThemeWithBlock:^{ \
	__strong typeof(weak_##obj) obj = weak_##obj; \
	block(); \
} forView:keyView]; \

static NSString * const kNSObjectUpdateThemeNotification = @"kNSObjectUpdateThemeNotification";

typedef void (^ZHThemeCodePicker)();


#import <Foundation/Foundation.h>

@interface NSObject (Theme)

- (void) addThemeWithBlock:(ZHThemeCodePicker)codePickerBlock;
- (void) updateThemeWithBlock:(ZHThemeCodePicker)codePickerBlock forView:(UIView *)view;

@end
