//
//  ZEBaseModel.m
//  Demos
//
//  Created by taffy on 16/6/30.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "ZEBaseModel.h"

@implementation ZEBaseModel

- (nullable instancetype)initWithProperties:(NSDictionary *)dict {
	if ( dict.count == 0 ) {
		return nil;
	}
	self = [super init];
	if (self) {
		[self yy_modelSetWithDictionary:dict];
	}
	return self;
}

#pragma mark -  yymodel protocol

+ (NSDictionary *)modelCustomPropertyMapper {
	return @{};
}

+ (NSDictionary*)modelContainerPropertyGenericClass {
	return @{};
}

+ (nullable NSArray<NSString *> *)modelPropertyBlacklist {
	return nil;
}


#pragma mark - other thing provide by yymodel

- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }
- (id)copyWithZone:(NSZone *)zone { return [self yy_modelCopy]; }
- (NSUInteger)hash { return [self yy_modelHash]; }
- (BOOL)isEqual:(id)object { return [self yy_modelIsEqual:object]; }
- (NSString *)description { return [self yy_modelDescription]; }

@end
