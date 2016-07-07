//
//  ZEReadStyleConfig.h
//  Demos
//
//  Created by taffy on 16/6/30.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
#import "DTCoreText.h"

@interface ZEReadStyleConfig : NSObject<YYModel, NSCoding, NSCopying>

// multiplier
@property(nonatomic)CGFloat textSizeMultiplier;
@property(nonatomic)CGFloat LineHeightMultiplier;

// size
@property(nonatomic)UIEdgeInsets edgeInsets;
@property(nonatomic)CGSize viewSize;
@property(nonatomic)CGSize maxImageSize;
@property(nonatomic)CGFloat lineSpacing;
@property(nonatomic)CGFloat paragraphSpacing;
@property(nonatomic)CGFloat defaultFontSize;
@property(nonatomic)CGFloat pFontSize;
@property(nonatomic)CGFloat h1FontSize;
@property(nonatomic)CGFloat h2FontSize;
@property(nonatomic)CGFloat h3FontSize;

// color
@property(nonatomic)UIColor *textColor;
@property(nonatomic)UIColor *linkColor;
@property(nonatomic)UIColor *linkHighlightColor;



+ (instancetype)sharedInstance;

@end
