//
//  PeriscopeViewController.m
//  Demos
//
//  Created by taffy on 15/9/20.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import "PeriscopeViewController.h"
#import "TFScrollView.h"
#import "TFView.h"


typedef enum {
  scrollDirectionTop,
  scrollDirectionDown,
  scrollDirectionDefault
} ScrollDirection;

@interface PeriscopeViewController () <UITableViewDelegate, UITableViewDataSource, TFViewDelegate, TFScrollViewDelegate, UIGestureRecognizerDelegate> {
  
  UIImage *tempImage;
  UITableView *_tableView;
  NSArray *dataArray;
  TFScrollView *pageScrollView;
  TFScrollView *tableScrollView;
  TFView *vedioView;
  TFView *headerView;
  
  float lastContentOffsetY;
}

@end

@implementation PeriscopeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setTitle:@"Periscope"];
  [self.view setBackgroundColor:[UIColor whiteColor]];
  [self.view setClipsToBounds:YES];
  
  dataArray = DATA_LIST;
  
  tempImage = [self imageCompressWithSimple:[UIImage imageNamed:@"IMG_1318.jpg"] scaledToSize:self.view.size];
  
  vedioView = [[TFView alloc] initWithFrame:self.view.bounds];
  [vedioView setImage:tempImage];
  [vedioView setBackgroundColor:[UIColor yellowColor]];
  [vedioView setClipsToBounds:YES];
  [vedioView setContentMode:UIViewContentModeScaleToFill];
  [self.view addSubview:vedioView];
  
  UIPanGestureRecognizer *panView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanView:)];
  [vedioView addGestureRecognizer:panView];

  pageScrollView = [[TFScrollView alloc] initWithFrame:self.view.bounds];
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
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  return [dataArray count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell2"];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
  }
  
  cell.textLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
  
  return cell;
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
  if (tableScrollView.contentOffset.y >= lastContentOffsetY) {
    if (tableScrollView.contentOffset.y >= 360) {
      [tableScrollView setContentOffset:CGPointMake(0, 360)];
    } else {
      [_tableView setContentOffset:CGPointMake(0, 0)];
    }
  } else {
    if (_tableView.contentOffset.y != 0) {
      [tableScrollView setContentOffset:CGPointMake(0, 360)];
    }
  }
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  lastContentOffsetY = tableScrollView.contentOffset.y;
};

#pragma mark - TFView delegate
- (id) customViewHistTest:(CGPoint)point withEvent:(UIEvent *)event withView:(UIView *)view {

  if ([headerView pointInside:point withEvent:event]) {
    return _tableView;
  }
  
  return nil;
}

#pragma makk - TFScrollView Delegate
- (id) customScrollViewHistTest:(CGPoint)point withEvent:(UIEvent *)event {

  // 控制触发 vedioView ，是否关闭当前视图

  return nil;
}



- (BOOL) customGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
  return YES;
}

#pragma mark - handle pan method
- (void) handlePanView: (UIPanGestureRecognizer *)pan {
  
  CGPoint offsetPoint = [pan translationInView:vedioView];
  
  NSLog(@"offsetPointY: %f",offsetPoint.y);
  NSLog(@"offsetPointX: %f", offsetPoint.x);
  

  if (offsetPoint.y > 50) {
    [UIView animateWithDuration:0.35 animations:^{
      [vedioView setFrame:CGRectMake(0, self.view.height, self.view.width, self.view.height)];
      [pageScrollView setFrame:vedioView.frame];
    }];
  }
  
}

//
//- (UIImage *)blurryGPUImage:(UIImage *)image withBlurLevel:(NSInteger)blur {
//
//  CGRect mainScreenFrame = [[UIScreen mainScreen] bounds];
//  
//  // Yes, I know I'm a caveman for doing all this by hand
//  GPUImageView *primaryView = [[GPUImageView alloc] initWithFrame:mainScreenFrame];
//  primaryView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//  
//  UISlider *filterSettingsSlider = [[UISlider alloc] initWithFrame:CGRectMake(25.0, mainScreenFrame.size.height - 50.0, mainScreenFrame.size.width - 50.0, 40.0)];
//  filterSettingsSlider.minimumValue = 0.0;
//  filterSettingsSlider.maximumValue = 3.0;
//  filterSettingsSlider.value = 1.0;
//  
//  [primaryView addSubview:filterSettingsSlider];
//  
//  photoCaptureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//  photoCaptureButton.frame = CGRectMake(round(mainScreenFrame.size.width / 2.0 - 150.0 / 2.0), mainScreenFrame.size.height - 90.0, 150.0, 40.0);
//  [photoCaptureButton setTitle:@"Capture Photo" forState:UIControlStateNormal];
//  photoCaptureButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
//  [photoCaptureButton addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
//  [photoCaptureButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
//  
//  [primaryView addSubview:photoCaptureButton];
//}

-(UIImage*)imageCompressWithSimple:(UIImage *)image scaledToSize:(CGSize)size
{
  UIGraphicsBeginImageContext(size);
  [image drawInRect:CGRectMake(0,0,size.width,size.height)];
  UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}


@end
