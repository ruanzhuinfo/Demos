//
//  PeriscopeViewController.m
//  Demos
//
//  Created by taffy on 15/9/20.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import "PeriscopeViewController.h"
#import "TFView.h"

@interface PeriscopeViewController () <UITableViewDelegate , UITableViewDataSource, TFViewDelegate> {

  UITableView *_tableView;
  NSArray *dataArray;
  TFView *vedioView;
}

@end

@implementation PeriscopeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setTitle:@"Periscope"];
  [self.view setBackgroundColor:[UIColor whiteColor]];
  [self.view setClipsToBounds:YES];
  
  
  vedioView = [[TFView alloc] initWithFrame:self.view.bounds];
  [vedioView setBackgroundColor:[UIColor grayColor]];
  [vedioView setViewDelegate:self];
  [vedioView setUserInteractionEnabled:YES];
  [self.view addSubview:vedioView];
  
  
  _tableView = [[UITableView alloc]
               initWithFrame:self.view.bounds
               style:UITableViewStylePlain];
  [_tableView setBackgroundColor:[UIColor clearColor]];
  [_tableView setDelegate:self];
  [_tableView setDataSource:self];
  [_tableView setRowHeight:44];
  [_tableView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.bounds.size.height + 500)];
  [vedioView addSubview:_tableView];
  
  UIPanGestureRecognizer *panView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanView:)];
  [vedioView addGestureRecognizer:panView];
  
  dataArray = DATA_LIST;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  if (section == 0) return 1;
  return [dataArray count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
  if (section == 0) return 0;
  if (section == 1) return 200;
  return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    return 300;
  }
  
  return 44;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (section == 1) return @"这里包括（文字部分和 滚动中的第一个 header）";
  return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  
  if (indexPath.section == 0) {
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell0"];
    if (!cell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    return cell;
  }
  
  UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell2"];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
  }
  
  cell.textLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
  return cell;
}



#pragma mark - TFView delegate
- (id) customHistTest:(CGPoint)point {
  
  if (point.y < 100) {
    return vedioView;
  }
  
  return _tableView;
}


#pragma mark - handle pan method
- (void) handlePanView: (UIPanGestureRecognizer *)pan {
  
  CGPoint locationPoint = [pan locationInView:vedioView];
  CGPoint offsetPoint = [pan translationInView:vedioView];
  
  NSLog(@"offsetPointY: %f",offsetPoint.y);
  NSLog(@"offsetPointX: %f", offsetPoint.x);
  
  
  if (offsetPoint.x < -50) {
    [UIView animateWithDuration:0.35 animations:^{
      [_tableView setFrame:CGRectMake(-self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    }];
  }
  
  if (offsetPoint.y > 50) {
    [UIView animateWithDuration:0.35 animations:^{
      [vedioView setFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
    }];
  }
  
}



@end
