//
//  Article.h
//  Demos
//
//  Created by taffy on 15/12/27.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject


@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *name;



+ (Article *)newWithDic: (NSDictionary *)dic;
+ (NSArray *)newWithArray: (NSArray *)array;

@end
