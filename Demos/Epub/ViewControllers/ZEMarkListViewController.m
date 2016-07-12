//
//  ZEMarkListViewController.m
//  Demos
//
//  Created by taffy on 16/7/8.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "ZEMarkListViewController.h"
#import "ZEMarkTableViewCell.h"
#import "ZEPageViewController.h"
#import "ZEBook.h"

@interface ZEMarkListViewController()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic)ZEBook *book;
@property(nonatomic)UITableView *markTableView;

@end

@implementation ZEMarkListViewController

+ (instancetype)newWithBookModel:(ZEBook *)book {
	
	ZEMarkListViewController *vc = [ZEMarkListViewController new];
	vc.book = book;
	return vc;
}


- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor whiteColor];
	
	[self setupTableView];
}


- (void)setupTableView {
	CGRect rect = CGRectMake(0, 0, self.view.width, self.view.height - 64);
	self.markTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
	self.markTableView.delegate = self;
	self.markTableView.dataSource = self;
	
	[self.markTableView registerClass:ZEMarkTableViewCell.class
				  forCellReuseIdentifier:NSStringFromSelector(@selector(setupTableView))];
	
	[self.markTableView setTableFooterView:[UIView new]];
	
	[self.markTableView setEstimatedRowHeight:44];
	[self.markTableView setRowHeight:UITableViewAutomaticDimension];
	
	[self.view addSubview:self.markTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.book.marks.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	ZEMarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromSelector(@selector(setupTableView))];
	
	ZEMark *mark = [self.book.marks objectAtIndex:indexPath.row];
	
	[cell setupDataWithMark:mark];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([tableView respondsToSelector:@selector(setSeparatorInset:)]){
		[tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
	}
	
	if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
		[tableView setLayoutMargins:UIEdgeInsetsZero];
	}
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:kPageViewControllerScrollMarkedPageNotification
	 object:self.book.marks[indexPath.row]];
	
	[self.navigationController popToRootViewControllerAnimated:YES];
}





@end
