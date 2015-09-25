//
//  IMessageViewController.m
//  Demos
//
//  Created by taffy on 15/9/21.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import "IMessageViewController.h"
#import "TFSpringCollectionViewFlowLayout.h"
#import "UIColor+Random.h"


@interface IMessageViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {

  UICollectionView *_collectionView;
  TFSpringCollectionViewFlowLayout *_collectionViewLayout;
  NSArray *dataList;
}

@end

@implementation IMessageViewController

static NSString *cellIdentifier = @"CellIdentifier";

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setTitle:@"IMessages Demo"];
  [self.view setBackgroundColor:[UIColor whiteColor]];
  
  _collectionViewLayout = [[TFSpringCollectionViewFlowLayout alloc] init:CGSizeMake(44, 44)];
  _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_collectionViewLayout];
  [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
  [_collectionView setHeight:self.view.height - 64];
  [_collectionView setBackgroundColor:[UIColor whiteColor]];
  [_collectionView setDelegate:self];
  [_collectionView setDataSource:self];
  [self.view addSubview:_collectionView];
  
  dataList = DATA_LIST;
}


- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [_collectionViewLayout invalidateLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIcollectionView Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return [dataList count];
}

//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewLayout *)collectionViewLayout
//  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//  
//  
//  
//}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView
                   cellForItemAtIndexPath:(NSIndexPath *)indexPath {

  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
  cell.backgroundColor = [UIColor getRandomColor];
  
  return cell;
}



@end
