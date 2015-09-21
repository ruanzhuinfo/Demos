//
//  DemoListViewController.m
//  Demos
//
//  Created by taffy on 15/9/20.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import "DemoListViewController.h"

@interface DemoListViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation DemoListViewController {

  NSArray *demoListData;

}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setTitle:@"List"];
  [self.view setBackgroundColor:[UIColor whiteColor]];
  
  demoListData = [[NSArray alloc] initWithContentsOfFile:
                  [[NSBundle mainBundle] pathForResource:@"DemoListData" ofType:@"plist"]];
  UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                        style:UITableViewStylePlain];
  [tableView setDelegate:self];
  [tableView setDataSource:self];
  [tableView setRowHeight:44];
  [tableView setTableFooterView:[[UIView alloc] init]];
  [self.view addSubview:tableView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [demoListData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifierCell"];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:@"identifierCell"];
  }
  
  [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
  [cell.textLabel setText:[[demoListData objectAtIndex:indexPath.row] allKeys].firstObject];
  return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  UIViewController *vc = [[(Class)NSClassFromString([[demoListData objectAtIndex:indexPath.row] allObjects].firstObject) alloc] init];
  [self.navigationController pushViewController:vc animated:YES];
}
@end
