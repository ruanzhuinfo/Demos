//
//  PeriscopeViewController.m
//  Demos
//
//  Created by taffy on 15/9/20.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import "PeriscopeViewController.h"
#import "UIColor+Random.h"
#import "TFScrollView.h"
#import "TFView.h"
#import "ProgressIndicatorView.h"


typedef enum {
  scrollDirectionTop,
  scrollDirectionDown,
  scrollDirectionDefault
} ScrollDirection;

@interface PeriscopeViewController () <UITableViewDelegate, UITableViewDataSource, TFViewDelegate, TFScrollViewDelegate> {
  
  UIImage *tempImage;
  UITableView *_tableView;
  NSArray *dataArray;
  TFScrollView *pageScrollView;
  TFScrollView *tableScrollView;
  TFView *vedioView;
  TFView *headerView;
  
  float lastContentOffsetY;
  
  // demo test
  CGRect vedioOriginFrame;
  CGRect pageOriginFrame;
}

@end

@implementation PeriscopeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setTitle:@"Periscope"];
  [self.view setBackgroundColor:[UIColor whiteColor]];
  [self.view setClipsToBounds:YES];
  
  
  ProgressIndicatorView *progress = [[ProgressIndicatorView alloc] init];
  [progress showProgressAddToView:self.view];
  
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [progress finishedProgress:YES completionProgress:^{
      
    }];
  });
  
  
  
  dataArray = DATA_LIST;
  
  tempImage = [UIImage getRandomImage];
  
  // 播放视频或图片的容器
  vedioView = [[TFView alloc] initWithFrame:self.view.bounds];
  [vedioView setImage:tempImage];
  [vedioView setClipsToBounds:YES];
  [vedioView setContentMode:UIViewContentModeScaleAspectFill];
  [self.view addSubview:vedioView];
  
  // 列表 和 评论的容器
  pageScrollView = [[TFScrollView alloc] initWithFrame:self.view.bounds];
  [pageScrollView setScrollViewDelegate:self];
  [pageScrollView setDirectionalLockEnabled:YES];
  [pageScrollView setShowsHorizontalScrollIndicator:NO];
  [pageScrollView setShowsVerticalScrollIndicator:NO];
  [pageScrollView setPagingEnabled:YES];
  [pageScrollView setContentSize:CGSizeMake(self.view.width * 2, self.view.height)];
  [self.view addSubview:pageScrollView];

  tableScrollView = [[TFScrollView alloc] initWithFrame:self.view.bounds];
  [tableScrollView setScrollViewDelegate:self];
  [tableScrollView setDelegate:self];
  [tableScrollView setShowsHorizontalScrollIndicator:NO];
  [tableScrollView setShowsVerticalScrollIndicator:NO];
  [pageScrollView addSubview:tableScrollView];
  
  _tableView = [[UITableView alloc]
                initWithFrame:self.view.bounds
                style:UITableViewStylePlain];
  [_tableView setDelegate:self];
  [_tableView setDataSource:self];
  [_tableView setRowHeight:44];
  [_tableView setBounces:NO];
  [_tableView setWidth:self.view.width - 30];
  [_tableView setLeft:15];
  [_tableView setTop:self.view.height - 200];
  [_tableView setHeight:497];
  [_tableView setShowsVerticalScrollIndicator:NO];
  [_tableView setShowsHorizontalScrollIndicator:NO];
  [_tableView setClipsToBounds:YES];
  [_tableView.layer setCornerRadius:4];
  [tableScrollView addSubview:_tableView];
  
  headerView = [[TFView alloc] initWithFrame:CGRectMake(_tableView.left + 10, _tableView.top - 70, _tableView.width - 20, 70)];
  [headerView setBackgroundColor:[UIColor clearColor]];
  [headerView setViewDelegate:self];
  UILabel *label = [[UILabel alloc] initWithFrame:headerView.bounds];
  [label setTextColor:[UIColor blackColor]];
  [label setFont:[UIFont boldSystemFontOfSize:16]];
  [label setText:@"360 度环绕立体眼妆教程，因地制宜玩转百变妆容 | 原来是西门大嫂"];
  [label setTextAlignment:NSTextAlignmentCenter];
  [label setNumberOfLines:0];
  [label setLineBreakMode:NSLineBreakByCharWrapping];
  [headerView addSubview:label];
  [tableScrollView addSubview:headerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  
  // 重新设置 tableScrollView 的 contentSize 和 _tableView 的 height;
  [tableScrollView setContentSize:CGSizeMake(_tableView.width, _tableView.bottom + 64)];
  
  // demo test
  vedioOriginFrame = vedioView.frame;
  pageOriginFrame = pageScrollView.frame;
}

- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section {

  return [dataArray count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = (UITableViewCell *)[tableView
                                              dequeueReusableCellWithIdentifier:@"cell2"];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:@"cell2"];
  }
  
  cell.textLabel.text = [[dataArray objectAtIndex:indexPath.row]
                         objectForKey:@"title"];
  [cell.contentView setBackgroundColor:[UIColor getRandomColor]];
  return cell;
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
  // 动效的核心逻辑
  
  if (tableScrollView.contentOffset.y >= lastContentOffsetY) {
    
    // 向上滑动时
    if (tableScrollView.contentOffset.y >= 360) {
      [tableScrollView setContentOffset:CGPointMake(0, 360)];
    } else {
      [_tableView setContentOffset:CGPointMake(0, 0)];
    }
  } else {
    
    // 向下滑动时
    if (_tableView.contentOffset.y != 0) {
      [tableScrollView setContentOffset:CGPointMake(0, 360)];
    }
  }
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  
  //记录滚动位置，判断滚动方向
  lastContentOffsetY = tableScrollView.contentOffset.y;
};

#pragma mark - TFView delegate
- (id) customViewHistTest:(CGPoint)point withEvent:(UIEvent *)event withView:(UIView *)view {

  // 视觉上 headerView 也是 _tableView 的一部分
  if ([headerView pointInside:point withEvent:event]) {
    return _tableView;
  }
  
  return nil;
}

#pragma makk - TFScrollView Delegate
- (UIView *) customScrollViewHistTest:(CGPoint)point withEvent:(UIEvent *)event {

  // 控制触发 vedioView ，是否关闭当前视图
  if ([tableScrollView pointInside:point withEvent:event]) {
    if (point.y < headerView.top) {
      [tableScrollView setScrollEnabled:NO];
    } else {
      [tableScrollView setScrollEnabled:YES];
    }
  }
  
  return nil;
}

- (BOOL) customGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
  
  // return YES 是引起 scrollView 和 tableView 同时起效的必要条件
  if (otherGestureRecognizer == pageScrollView.panGestureRecognizer ||
      gestureRecognizer == pageScrollView.panGestureRecognizer) {
    return NO;
  }
  
  return YES;
}

- (void) customHandlPanView:(UIPanGestureRecognizer *)pan withView:(UIView *)view {
  
  // 关闭视图
  if (view == pageScrollView) {
    CGPoint offsetPoint = [pan translationInView:vedioView];
  
    // vedioView 拖动超过 50 点关闭视图
    if (offsetPoint.y > 50) {
      
      [pan setCancelsTouchesInView:YES];
      
      [UIView animateWithDuration:0.35 animations:^{
        [vedioView setFrame:CGRectMake(0, self.view.height, self.view.width, self.view.height)];
        [pageScrollView setFrame:vedioView.frame];
      }];
      
      // demo
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.35 animations:^{
          [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
          vedioView.frame = vedioOriginFrame;
          pageScrollView.frame = pageOriginFrame;
        }];
        
      });
    }
  }
}


- (UIImage *)blurryGPUImage:(UIImage *)image withBlurLevel:(NSInteger)blur {

  return nil;
}

-(UIImage*)imageCompressWithSimple:(UIImage *)image scaledToSize:(CGSize)size
{
  UIGraphicsBeginImageContext(size);
  [image drawInRect:CGRectMake(0,0,size.width,size.height)];
  UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}


@end
