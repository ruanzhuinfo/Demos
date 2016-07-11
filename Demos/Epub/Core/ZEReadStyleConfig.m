//
//  ZEReadStyleConfig.m
//  Demos
//
//  Created by taffy on 16/6/30.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "ZEReadStyleConfig.h"

@implementation ZEReadStyleConfig

+ (instancetype)sharedInstance {
	static ZEReadStyleConfig *config = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		config = [[ZEReadStyleConfig alloc] init];
	});
	return config;
}

- (instancetype)init {
	self = [super init];
	if (self) {
		
		// size
		self.edgeInsets = UIEdgeInsetsMake(45, 10, 45, 10);
		self.viewSize = [UIScreen mainScreen].bounds.size;
		self.maxImageSize = CGSizeMake(self.viewSize.width - self.edgeInsets.left - self.edgeInsets.right,
									   self.viewSize.height - self.edgeInsets.top - self.edgeInsets.bottom);
		self.defaultFontSize = 17;
		self.h1FontSize = 22;
		self.h2FontSize = 18;
		self.h3FontSize = 16;
		self.pFontSize = 14;
		self.lineSpacing = 28;
		self.paragraphSpacing = 3.5;
		
		// color
		self.linkColor = [UIColor blueColor];
		self.linkHighlightColor = [UIColor redColor];
		self.textColor = [UIColor blackColor];
		
		// multipliter
		self.textSizeMultiplier = 1.0;
		self.LineHeightMultiplier = 1.0;
	}
	
	return self;
}



#pragma mark - YYModel
- (void)encodeWithCoder:(NSCoder *)aCoder {[self yy_modelEncodeWithCoder:aCoder];}
- (id)initWithCoder:(NSCoder *)aDecoder {self = [super init];return [self yy_modelInitWithCoder:aDecoder];}
- (id)copyWithZone:(NSZone *)zone {return [self yy_modelCopy];}
- (BOOL)isEqual:(id)object {return [self yy_modelIsEqual:object];}

@end
