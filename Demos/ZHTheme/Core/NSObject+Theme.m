//
//  NSObject+Theme.m
//  daily
//
//  Created by taffy on 16/3/16.
//  Copyright © 2016年 Zhihu. All rights reserved.
//

#import "NSObject+Theme.h"
#import "NSObject+DeallocBlock.h"
#import <objc/runtime.h>

static NSString * const kUIViewDeallocHelperKey = @"kUIViewDeallocHelperKey";
static NSTimeInterval const kThemeChangingAnimationDuration = 0.3;

@interface NSObject()

@property (nonatomic) NSMutableArray<ZHThemeCodePicker> *codePickersArray;
@property (nonatomic) NSMutableDictionary<id, ZHThemeCodePicker> *codePickersDictionary;

@end

@implementation NSObject (Theme)

- (NSMutableArray<ZHThemeCodePicker> *)codePickersArray {
	return [self setupPropertyWithClassName:NSStringFromClass([NSMutableArray class]) forKey:@selector(codePickersArray)];
}

- (NSMutableDictionary<id, ZHThemeCodePicker> *)codePickersDictionary{
	return [self setupPropertyWithClassName:NSStringFromClass([NSMutableDictionary class]) forKey:@selector(codePickersDictionary)];
}

- (void) addThemeWithBlock:(ZHThemeCodePicker)codePickerBlock {
	if (!codePickerBlock) {
		return;
	}
	
	codePickerBlock();
	
	[self.codePickersArray addObject:[codePickerBlock copy]];
}

- (void) updateThemeWithBlock:(ZHThemeCodePicker)codePickerBlock forView:(UIView *)view {
	if (!codePickerBlock) {
		return;
	}
	
	if (!view) {
		return;
	}
	
	codePickerBlock();
	
	const void *ptr = (__bridge const void *)(view);
	[self.codePickersDictionary setObject:[codePickerBlock copy] forKey:[NSNumber numberWithLongLong:ptr]];
}


#pragma mark - Notification

- (void) changeTheme {
	[UIView animateWithDuration:kThemeChangingAnimationDuration animations:^{
		[self.codePickersArray enumerateObjectsUsingBlock:^(ZHThemeCodePicker  _Nonnull codePicker, NSUInteger idx, BOOL * _Nonnull stop) {
			codePicker();
		}];
		
		[self.codePickersDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, ZHThemeCodePicker  _Nonnull codePicker, BOOL * _Nonnull stop) {
			codePicker();
		}];
	}];
}


#pragma mark - private method 

- (id) setupPropertyWithClassName:(NSString *)className forKey:(const void *)key {

	id property = objc_getAssociatedObject(self, key);

	if ([property isKindOfClass:[NSClassFromString(className) class]]) {
		return property;
	}
	
	@autoreleasepool {
		property = [[NSClassFromString(className) alloc] init];
		objc_setAssociatedObject(self, key, property, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		
		[[NSNotificationCenter defaultCenter] removeObserver:self name:kNSObjectUpdateThemeNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheme) name:kNSObjectUpdateThemeNotification object:nil];
		
		// 设置 dealloc 机制
		
		if (objc_getAssociatedObject(self, &kUIViewDeallocHelperKey)) {
			return property;
		}
		
		// 这里必须要用 __unsafe_unretained ，用 __weak 会 crash，不知道为什么
		__unsafe_unretained typeof (self) weakSelf = self;
		
		id deallocHelper = [self addDeallocBlock:^{
			
			// 添加要释放的内容
			
			[[NSNotificationCenter defaultCenter] removeObserver:weakSelf name:kNSObjectUpdateThemeNotification object:nil];
			
		}];
		
		objc_setAssociatedObject(self, &kUIViewDeallocHelperKey, deallocHelper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	
	return property;
}




@end
