
//
//  ZLTextComponent.m
//  Demos
//
//  Created by taffy on 16/5/30.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "ZLTextComponent.h"

@implementation ZLTextComponent


+ (instancetype)newWithTextAttributes:(const CKTextKitAttributes &)attributes
					   viewAttributes:(const CKViewComponentAttributeValueMap &)viewAttributes
				 accessibilityContext:(const CKTextComponentAccessibilityContext &)accessibilityContext {
	
	
	
	NSString *str = attributes.attributedString.string;
	
	NSString *pattern = @"[(\\ud83c\\udf00-\\ud83d\\ude4f)|(\\ud83d\\ude80-\\ud83d\\udeff)|(\u2600-\u27bf)]";
	
	//    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
	
	NSArray *results = [regex matchesInString:str options:0 range:NSMakeRange(0, str.length)];
	NSLog(@"result count : %zd", results.count);
	NSLog(@"results = %@", results);
	
	
	
	return [super newWithTextAttributes:attributes viewAttributes:viewAttributes accessibilityContext:accessibilityContext];
	
	

}


@end
