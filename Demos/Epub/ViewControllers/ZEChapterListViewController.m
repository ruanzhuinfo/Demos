//
//  ZEChapterListViewController.m
//  Demos
//
//  Created by taffy on 16/7/8.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "ZEChapterListViewController.h"
#import "ZEPageViewController.h"
#import "ZEChapterTableViewCell.h"
#import "ZEBook.h"

@interface ZEChapterListViewController()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic)ZEBook *book;

/// 在页面中所有地方对 chapters 的使用都必须用 chapters，它才是经过处理的 tableView 的真正的数据源，切记！！！
@property(nonatomic, copy)NSArray<ZEChapter *> *chapters;

@property(nonatomic)UITableView *chapterTableView;
@property(nonatomic)NSInteger currentChapterIndex;

@end

@implementation ZEChapterListViewController

+ (instancetype)newWithBookModel:(ZEBook *)book {

	ZEChapterListViewController *vc = [ZEChapterListViewController new];
	vc.book = book;
	vc.chapters = [vc filterChaptersWithBookModel:vc.book];
	return vc;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	zh_addThemeWithBlock(self, ^{
		[self.view setBackgroundColor:colorWithSelector(@selector(color_BG06))];
	});
	
	self.currentChapterIndex = [self getCurrentPageIndex];
	
	[self setupTableView];
}


- (void)setupTableView {
	CGRect rect = CGRectMake(0, 0, self.view.width, self.view.height - 64);
	self.chapterTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
	self.chapterTableView.delegate = self;
	self.chapterTableView.dataSource = self;
	
	[self.chapterTableView registerClass:ZEChapterTableViewCell.class
				  forCellReuseIdentifier:NSStringFromSelector(@selector(setupTableView))];
	[self setupTableViewHeaderView];
	[self.view addSubview:self.chapterTableView];
	
	zh_addThemeWithBlock(self, ^{
		[self.chapterTableView setSeparatorColor:colorWithSelector(@selector(color_R02))];
	});
}

- (void)setupTableViewHeaderView {
	UIView *headerView = [[UIView alloc] init];
	
	UILabel *title = [[UILabel alloc] init];
	[title setText:self.book.title];
	zh_updateThemeWithBlock(title, ^{
		[title setTextColor:colorWithSelector(@selector(color_W01))];
	}, title);
	[title setFont:[UIFont boldSystemFontOfSize:19]];
	[headerView addSubview:title];
	[title mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(10);
		make.right.mas_equalTo(-10);
		make.top.mas_equalTo(20);
	}];
	
	UILabel *author = [[UILabel alloc] init];
	zh_updateThemeWithBlock(author, ^{
		[author setTextColor:colorWithSelector(@selector(color_W04))];
	}, author);
	[author setText:[NSString stringWithFormat:@"作者：%@ 等", self.book.authors.firstObject]];
	[author setFont:[UIFont systemFontOfSize:16]];
	[headerView addSubview:author];
	[author mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.mas_equalTo(10);
		make.top.mas_equalTo(title.mas_bottom).offset(17);
		make.right.mas_equalTo(-10);
		make.bottom.mas_equalTo(-15);
	}];
	
	CGSize size = [headerView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
	[headerView setSize:size];
	self.chapterTableView.tableHeaderView = headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.chapters.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	ZEChapterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromSelector(@selector(setupTableView))];
	
	cell.isCurrentPage = indexPath.row == self.currentChapterIndex;
	
	cell.chapterStyle = ZEChapterStyleNormal;
	
	[cell setupDataWithChapterModel:self.chapters[indexPath.row]];
	
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
	 postNotificationName:kPageViewControllerChangePageNotification
	 object:@(self.chapters[indexPath.row].pageIndex)];
	
	[self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - helper method

- (NSInteger)getCurrentPageIndex {
	for (ZEChapter *c in self.chapters) {
		if (self.book.pageIndex < c.pageIndex + c.pageCount &&
			self.book.pageIndex >= c.pageIndex) {
			return [self.chapters indexOfObject:c];
		}
	}
	
	return -1;
}

- (NSArray<ZEChapter *> *)filterChaptersWithBookModel:(ZEBook *)book {
	
	NSMutableArray *tempArray = [NSMutableArray array];
	[book.chapters enumerateObjectsUsingBlock:^(ZEChapter * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if ([obj.title isEqualToString:@""]) {
			[tempArray addObject:obj];
		}
	}];
	
	NSMutableArray *c = [book.chapters mutableCopy];
	[c removeObjectsInArray:tempArray];
	
	return c;
}

@end
