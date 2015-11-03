//
//  SpotlightManage.m
//  Demos
//
//  Created by taffy on 15/10/18.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import "SpotlightManage.h"

NSString* const circleDomainIndentifier = @"circleDomainindentifier";
NSString* const articleDomainIndentifier = @"articleDomainIndentifier";
NSString* const userDomainIndentifier = @"userDomainIndentifier";

@import CoreSpotlight;
@import MobileCoreServices;
@implementation SpotlightManage 

static SpotlightManage *spotightObj;

+ (SpotlightManage *) manage {
  
  if (!spotightObj) {
    spotightObj = [SpotlightManage new];
  }
  
  return spotightObj;
}




+ (BOOL) addCirclesSearchableItems: (NSArray<NSDictionary *> *)models {

  for (NSDictionary *dic in models) {
    
  }

  return YES;
}

+ (BOOL) addArticlesSearchableItems: (NSArray<NSDictionary *> *)models {
  
  NSMutableArray *items = [NSMutableArray new];
  
  for (NSDictionary *dic in models) {
    CSSearchableItem *item = [[self manage] createSearchableItem:articleDomainIndentifier
                                    searchableItemAttributeSet:[spotightObj createSearchableItemAttributeSetOfArticle:dic]];
    if (item) {
      [items addObject:item];
    }
    
  }
  
  [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:items
                                                 completionHandler:^(NSError * _Nullable error) {
    
                                                   if (error) {
                                                     NSLog(@"%@", error.debugDescription);
                                                   } else {
                                                     NSLog(@"items added !");
                                                   }
  }];
  
  return YES;
}

+ (BOOL) addUsersSearchableItems: (NSArray<NSDictionary *> *)models {
  
  for (NSDictionary *dic in models) {
  
  }
  
  return YES;
}



- (CSSearchableItemAttributeSet *) createSearchableItemAttributeSetOfArticle: (NSDictionary *)model {
  
  CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:
                                                [NSString stringWithFormat:@"%@", kUTTypeData]];
  [attributeSet setIdentifier:[NSString stringWithFormat:@"%lu", [DATA_LIST indexOfObject:model]]];
  [attributeSet setTitle:[model objectForKey:@"title"]];
  [attributeSet setContentDescription:[model objectForKey:@"url"]];
  [attributeSet setThumbnailData:UIImagePNGRepresentation([UIImage getRandomImage])];
  return attributeSet;
}

- (CSSearchableItem *) createSearchableItem: (NSString *) domainIndentifirer
                 searchableItemAttributeSet: (CSSearchableItemAttributeSet *) attributeSet  {
  
  // 创建单个 searchItem
  CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:attributeSet.identifier
                                                             domainIdentifier:domainIndentifirer
                                                                 attributeSet:attributeSet];
  return item;
}








@end
