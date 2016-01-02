//
//  ArticleComponent.m
//  Demos
//
//  Created by taffy on 15/12/27.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import "ArticleComponent.h"
#import <ComponentKit/CKComponentSubclass.h>
#import "Article.h"
#import "UIColor+Random.h"
#import "UIImage+Additions.h"

@implementation ArticleComponent

+ (id) newWithArticleModel:(Article *)article {
  
  ArticleComponent *a = [super newWithComponent:[CKInsetComponent
                                                 newWithInsets:{.top = 10, .bottom = 0, .left = 10, .right= 10}
                                                 component:
                                                 [CKStackLayoutComponent
                                                  newWithView:{
                                                    UIView.class,
                                                    {{@selector(setBackgroundColor:), [UIColor whiteColor]}}
                                                  }
                                                  size:{}
                                                  style:{
                                                    .alignItems = CKStackLayoutAlignItemsStretch,
                                                    .spacing = 5
                                                  }
                                                  children:{
                                                    {
                                                      [ArticleComponent commponentWithCircle:article]
                                                    },
                                                    {
                                                      [CKLabelComponent newWithLabelAttributes:{
                                                        .string = article.name,
                                                        .font = [UIFont systemFontOfSize:30]
                                                      } viewAttributes:{
                                                        {@selector(setBackgroundColor:), [UIColor whiteColor]},
                                                      }]
                                                    },
                                                    {
                                                      [CKLabelComponent
                                                       newWithLabelAttributes:{
                                                         .string = article.title,
                                                         .font = [UIFont fontWithName:@"Baskerville" size:20],
                                                         .color = [UIColor grayColor]
                                                       }
                                                       viewAttributes:{
                                                         {@selector(setBackgroundColor:), [UIColor whiteColor]},
                                                         {@selector(setUserInteractionEnabled:), @NO},
                                                       }]
                                                    },
                                                    {
                                                      [CKComponent newWithView:{
                                                        [UILabel class],
                                                        {
                                                          {@selector(setTextColor:), [UIColor grayColor]},
                                                          {@selector(setText:), [NSString stringWithFormat:@"%@", [NSDate new]]},
                                                          {@selector(setTextAlignment:), @(NSTextAlignmentRight)}
                                                        }
                                                      } size:{.width = 0, .height = 21}],
                                                      .alignSelf = CKStackLayoutAlignSelfStretch
                                                    },
                                                    {
                                                      [CKComponent
                                                       newWithView:{
                                                         [UIView class],
                                                         {{@selector(setBackgroundColor:), [UIColor lightTextColor]}}
                                                       }
                                                       size:{.height = 0.5}]
                                                    }
                                                  }]]];
  


  
  return a;
}

+ (CKStackLayoutComponent *) commponentWithCircle: (Article *)article {
  return [CKStackLayoutComponent newWithView:{}
                                        size:{}
                                       style:{
                                         .direction = CKStackLayoutDirectionHorizontal,
                                         .justifyContent = CKStackLayoutJustifyContentStart,
                                         .alignItems = CKStackLayoutAlignItemsStretch
                                       }
                                    children:{
                                      {
                                        [CKImageComponent
                                         newWithImage: [UIImage getRandomImage]
                                         size:{.width = 70, .height = 70}],
                                        .alignSelf = CKStackLayoutAlignSelfStart
                                        
                                        
                                      },
                                      {
                                        [CKInsetComponent newWithInsets:{.top = 0, .bottom = 0, .left = 5, .right = 0}
                                                              component:[CKStackLayoutComponent newWithView:{}
                                                                                                       size:{ .width = [UIApplication sharedApplication].keyWindow.size.width - 70 - 20}
                                                                                                      style:{
                                                                                                        .direction = CKStackLayoutDirectionVertical,
                                                                                                        .alignItems = CKStackLayoutAlignItemsStretch,
                                                                                                        .spacing = 7
                                                                                                      }
                                                                                                   children:{
                                                                                                     {
                                                                                                       [CKLabelComponent newWithLabelAttributes:{
                                                                                                         .string = article.title,
                                                                                                         .color = [UIColor grayColor],
                                                                                                         .font = [UIFont systemFontOfSize:12],
                                                                                                         .lineSpacing = 3
                                                                                                       } viewAttributes:{
                                                                                                         {@selector(setBackgroundColor:), [UIColor whiteColor]},
                                                                                                         {@selector(setUserInteractionEnabled:), @NO},
                                                                                                       }]
                                                                                                     },
                                                                                                     {
                                                                                                       [CKComponent newWithView:{
                                                                                                         [UIButton class],
                                                                                                         {
                                                                                                           {@selector(setTitle:), article.name},
                                                                                                           {@selector(setBackgroundColor:), [UIColor blueColor]}
                                                                                                         }
                                                                                                       } size:{.width = 70, .height = 30}],
                                                                                                       .alignSelf = CKStackLayoutAlignSelfStart
                                                                                                     }
                                                                                                   }]]
                                      }
                                    }];
}

@end
