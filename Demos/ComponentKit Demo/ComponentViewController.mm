//
//  ComponentViewController.m
//  Demos
//
//  Created by taffy on 15/9/20.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import "ComponentViewController.h"
#import <ComponentKit/ComponentKit.h>
#import "Article.h"
#import "ArticleComponent.h"

@interface ComponentViewController ()<CKComponentProvider, UICollectionViewDelegateFlowLayout>



@end

@implementation ComponentViewController {

  CKCollectionViewDataSource *_dataSource;
  CKComponentFlexibleSizeRangeProvider *_sizeRangeProvider;
  
  NSArray *listModel;
  UICollectionView *collectionView;

}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setTitle:@"ComponentKit"];
  [self.view setBackgroundColor:[UIColor whiteColor]];
  
  _sizeRangeProvider = [CKComponentFlexibleSizeRangeProvider providerWithFlexibility:CKComponentSizeRangeFlexibleHeight];
  
  UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
  [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
  [flowLayout setMinimumInteritemSpacing:0];
  [flowLayout setMinimumLineSpacing:0];
 
  collectionView  = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) collectionViewLayout:flowLayout];
  [collectionView setBackgroundColor:[UIColor whiteColor]];
  collectionView.delegate = self;
  
  [self.view addSubview:collectionView];
  listModel = [self createModel:DATA_LIST];
  _dataSource = [[CKCollectionViewDataSource alloc] initWithCollectionView:collectionView
                                               supplementaryViewDataSource:nil
                                                         componentProvider:self.class
                                                                   context:listModel
                                                 cellConfigurationFunction:nil];
  CKArrayControllerSections sections;
  sections.insert(0);
  [_dataSource enqueueChangeset:{sections, {}} constrainedSize:{}];
  
  CKArrayControllerInputItems items;
  for (NSInteger i = 0; i < [listModel count]; i++) {
    items.insert([NSIndexPath indexPathForRow:i inSection:0], listModel[i]);
  }
  [_dataSource enqueueChangeset:{{}, items}
                constrainedSize:[_sizeRangeProvider sizeRangeForBoundingSize:collectionView.bounds.size]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSArray<Article *> *)createModel: (NSArray<NSDictionary *> *) array {
  return [Article newWithArray:array];
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  return [_dataSource sizeForItemAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath
{
  [_dataSource announceWillAppearForItemInCell:cell];
}

- (void)collectionView:(UICollectionView *)collectionView
  didEndDisplayingCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath
{
  [_dataSource announceDidDisappearForItemInCell:cell];
}

#pragma mark - CKComponentProvider

+ (CKComponent *)componentForModel:(id<NSObject>)model context:(id<NSObject>)context {
  return [ArticleComponent newWithArticleModel:model];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  if( scrollView.contentSize.height == 0 ) {
    return ;
  }
  
  if (scrolledToBottomWithBuffer(scrollView.contentOffset, scrollView.contentSize, scrollView.contentInset, scrollView.bounds)) {
    CKArrayControllerInputItems items;
    for (NSInteger i = 0; i < [listModel count]; i++) {
      items.insert([NSIndexPath indexPathForRow:listModel.count + i inSection:0], listModel[i]);
    }
    [_dataSource enqueueChangeset:{{}, items}
                  constrainedSize:[_sizeRangeProvider sizeRangeForBoundingSize:collectionView.bounds.size]];
  }
}

static BOOL scrolledToBottomWithBuffer(CGPoint contentOffset, CGSize contentSize, UIEdgeInsets contentInset, CGRect bounds)
{
  CGFloat buffer = CGRectGetHeight(bounds) - contentInset.top - contentInset.bottom;
  const CGFloat maxVisibleY = (contentOffset.y + bounds.size.height);
  const CGFloat actualMaxY = (contentSize.height + contentInset.bottom);
  return ((maxVisibleY + buffer) >= actualMaxY);
}

@end
