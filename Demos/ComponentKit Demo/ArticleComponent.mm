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
	
	NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
	
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
															[CKTextComponent
															 newWithTextAttributes:{
																 .attributedString = [[NSAttributedString alloc]
																					  initWithString:article.title
																					  attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Baskerville" size:30],
																								   NSForegroundColorAttributeName:[UIColor blackColor],
																								   NSParagraphStyleAttributeName: paragraph}]
															 }
															 viewAttributes:{
																 {@selector(setBackgroundColor:), [UIColor yellowColor]},
																 {@selector(setUserInteractionEnabled:), @NO},
															 }
															 accessibilityContext:{}]
														},
														{
															[CKTextComponent
															 newWithTextAttributes:{
																 .attributedString = [[NSAttributedString alloc]
																					  initWithString:article.title
																					  attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Baskerville" size:20],
																								   NSForegroundColorAttributeName:[UIColor grayColor],
																								   NSParagraphStyleAttributeName: paragraph}]
															 }
															 viewAttributes:{
																 {@selector(setBackgroundColor:), [UIColor yellowColor]},
																 {@selector(setUserInteractionEnabled:), @NO},
															 }
															 accessibilityContext:{}]
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
	
	NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
//	[paragraph setLineSpacing:1.2];
	
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
											  [CKInsetComponent
											   newWithInsets:{.top = 0, .bottom = 0, .left = 5, .right = 0}
											   component:[CKStackLayoutComponent
														  newWithView:{}
														  size:{ .width = [UIApplication sharedApplication].keyWindow.size.width - 70 - 20}
														  style:{
															  .direction = CKStackLayoutDirectionVertical,
															  .alignItems = CKStackLayoutAlignItemsStretch,
															  .spacing = 7
														  }
														  children:{
															  {
																  [CKTextComponent
																   newWithTextAttributes:{
																	   .attributedString = [[NSAttributedString alloc]
																							initWithString:article.title
																							attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Baskerville" size:12],
																										 NSForegroundColorAttributeName:[UIColor grayColor],
																										 NSParagraphStyleAttributeName: paragraph}]
																   }
																   viewAttributes:{
																	   {@selector(setBackgroundColor:), [UIColor yellowColor]},
																	   {@selector(setUserInteractionEnabled:), @NO},
																   }
																   accessibilityContext:{}]
															  },
															  {
																  [CKComponent
																   newWithView:{
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
