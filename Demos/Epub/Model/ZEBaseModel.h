//
//  ZEBaseModel.h
//  Demos
//
//  Created by taffy on 16/6/30.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>


@interface ZEBaseModel : NSObject <YYModel, NSCoding, NSCopying>

/// 必要信息不全的时候回返回 nil
-(nullable instancetype)initWithProperties:(nullable NSDictionary*)dict;


//
+ (nonnull NSDictionary *)modelCustomPropertyMapper NS_REQUIRES_SUPER;
+ (nullable NSDictionary*)modelContainerPropertyGenericClass NS_REQUIRES_SUPER;

@end
