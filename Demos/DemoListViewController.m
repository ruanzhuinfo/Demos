//
//  DemoListViewController.m
//  Demos
//
//  Created by taffy on 15/9/20.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import "DemoListViewController.h"
#import "DDTabPagerViewController.h"
#import "ZENavigationController.h"

@interface DemoListViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation DemoListViewController {
	
	NSArray *demoListData;
	
	DDItemScrollView *itemScrollView;
	DDTabPagerViewController *pageViewController;
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self setTitle:@"List"];
	[self.view setBackgroundColor:[UIColor whiteColor]];
	
	demoListData = [[NSArray alloc] initWithContentsOfFile:
					[[NSBundle mainBundle] pathForResource:@"DemoListData" ofType:@"plist"]];
	UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds
														  style:UITableViewStylePlain];
	[tableView setAccessibilityIdentifier:@"demoList"];
	[tableView setDelegate:self];
	[tableView setDataSource:self];
	[tableView setRowHeight:44];
	[tableView setTableFooterView:[[UIView alloc] init]];
	[self.view addSubview:tableView];
	
	
	
	itemScrollView = [DDItemScrollView newWithPoint:CGPointMake(0, 0)
											  items:@[@{@"name": @"新闻", @"count": @11, @"isNew": @NO},@{@"name": @"深度", @"count": @3, @"isNew": @NO},@{@"name": @"音乐", @"count": @13, @"isnew": @YES},@{@"name": @"影视", @"count": @0, @"isNew": @NO},@{@"name": @"娱乐", @"count": @2, @"isNew": @NO}, @{@"name": @"新闻1", @"count": @11, @"isNew": @NO},@{@"name": @"深度1", @"count": @3, @"isNew": @NO},@{@"name": @"音乐1", @"count": @13, @"isnew": @YES},@{@"name": @"影视1", @"count": @0, @"isNew": @NO},@{@"name": @"娱乐1", @"count": @2, @"isNew": @NO}]
								   makeItemCallback:^ItemModel *(NSDictionary *model) {
									   
									   // 配置成 DDItemScrollView 内能流通的对象
									   
									   ItemModel *m = [ItemModel new];
									   m.itemName = [model objectForKey:@"name"];
									   m.unReadCount = [[model objectForKey:@"count"] integerValue];
									   m.isNew = [[model objectForKey:@"isnew"] boolValue];
									   return m;
									   
								   } tapItemCallback:^(id model) {
									   
									   // 要显示的 viewController
									   
									   [self.navigationController pushViewController:
										[DDTabPagerViewController newWithViewControllerPicker:^UIViewController *(ItemModel *model) {
										   
										   if ([model.itemName isEqualToString:@"新闻"]) {
											   return [[(Class)NSClassFromString([[demoListData objectAtIndex:0] allObjects].firstObject) alloc] init];
										   }
										   else if ([model.itemName isEqualToString:@"深度"]) {
											   return [[(Class)NSClassFromString([[demoListData objectAtIndex:2] allObjects].firstObject) alloc] init];
										   }
										   else if ([model.itemName isEqualToString:@"音乐"]) {
											   return [[(Class)NSClassFromString([[demoListData objectAtIndex:2] allObjects].firstObject) alloc] init];
										   }
										   else if ([model.itemName isEqualToString:@"影视"]) {
											   return [[(Class)NSClassFromString([[demoListData objectAtIndex:3] allObjects].firstObject) alloc] init];
										   }
										   
										   return [[(Class)NSClassFromString([[demoListData objectAtIndex:4] allObjects].firstObject) alloc] init];
										   
									   } itemScrollView:itemScrollView selectedItemCell:model]
																			animated:NO];
								   }];
	
	[itemScrollView setItemScrollViewSelectedState:NO];
	[self.view addSubview:itemScrollView];
	[tableView setTop:tableView.top + itemScrollView.height];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
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
	
	[cell setAccessibilityIdentifier:[NSString stringWithFormat:@"cell_%ld", (long)indexPath.row]];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	[cell.textLabel setText:[[demoListData objectAtIndex:indexPath.row] allKeys].firstObject];
	return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	UIViewController *vc = [[(Class)NSClassFromString([[demoListData objectAtIndex:indexPath.row] allObjects].firstObject) alloc] init];
	
	if ([vc isKindOfClass:NSClassFromString(@"ZEPageViewController").class]) {
		[self presentViewController:vc animated:YES completion:nil];
		
//		ZENavigationController *nav = [ZENavigationController newWithParentViewController:self.navigationController];
//		[nav pushViewController:vc animated:YES];
	} else {
		[self.navigationController pushViewController:vc animated:YES];
	}
}
@end
