//
//  ArticleComponent.h
//  Demos
//
//  Created by taffy on 15/12/27.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import <ComponentKit/ComponentKit.h>

@class Article;

@interface ArticleComponent : CKCompositeComponent

+ (id) newWithArticleModel:(Article *)article;

@end
