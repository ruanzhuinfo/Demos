//
//  SpotlightManage.h
//  Demos
//
//  Created by taffy on 15/10/18.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpotlightManage : NSObject

+ (BOOL) addCirclesSearchableItems: (NSArray<NSDictionary *> *)models;
+ (BOOL) addUsersSearchableItems: (NSArray<NSDictionary *> *)models;
+ (BOOL) addArticlesSearchableItems: (NSArray<NSDictionary *> *)models;

@end
