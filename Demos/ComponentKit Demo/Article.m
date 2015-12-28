//
//  Article.m
//  Demos
//
//  Created by taffy on 15/12/27.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import "Article.h"

@implementation Article



+(Article *)newWithDic:(NSDictionary *)dic {
  
  Article *a = [[self alloc] init];
  if (a) {
    a.image = [dic objectForKey:@"image"];
    a.name = [dic objectForKey:@"name"];
    a.title = [dic objectForKey:@"title"];
  }
  return a;
}

+ (NSArray *)newWithArray:(NSArray *)array {
  
  NSMutableArray *arr = [NSMutableArray new];
  for (NSDictionary *dic in array) {
    [arr addObject:[Article newWithDic:dic]];
  }
  return arr;
}

@end


