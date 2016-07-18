//
//  UIColor+HEX.m
//  Demos
//
//  Created by taffy on 16/7/17.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "UIColor+HEX.h"

@implementation UIColor (HEX)

+ (UIColor *)colorWithHexString:(NSString *)hexString {
	NSString *string = hexString;
	if ([string hasPrefix:@"#"])
		string = [string substringFromIndex:1];
	
	if (string.length == 3) {
		string = [NSString stringWithFormat:@"%@%@", string, string];
	}
	
	NSScanner *scanner = [NSScanner scannerWithString:string];
	unsigned hexNum;
	if (![scanner scanHexInt:&hexNum]) return nil;
	
	UInt32 r = (hexNum >> 16) & 0xFF;
	UInt32 g = (hexNum >> 8) & 0xFF;
	UInt32 b = (hexNum) & 0xFF;
	UIColor *result = [UIColor colorWithRed:r / 255.0f
									  green:g / 255.0f
									   blue:b / 255.0f
									  alpha:1.0f];
	return result;
}

@end
