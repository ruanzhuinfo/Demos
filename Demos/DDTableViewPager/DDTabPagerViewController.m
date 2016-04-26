//
//  DDTabPagerViewController.m
//  Demos
//
//  Created by taffy on 16/4/25.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "DDTabPagerViewController.h"


static NSString * kTablePagerViewContoller = @"kTablePagerViewContoller";


@interface DDTabPagerViewController()<UIScrollViewDelegate>

// 获取要显示的 viewController
@property (nonatomic) DDViewControllerPicker viewControllerPicker;

// 顶部选项卡
@property (nonatomic) DDItemScrollView *itemScrollView;

// 存放已经加载过的选项卡，有利于判断当前 viewController 是否已经显示过
@property (nonatomic) NSMutableArray<ItemCell *> *loadedItemCell;

// 存放已经加载过的 viewController
@property (nonatomic) NSMutableDictionary<NSString *, UIViewController *> *loadedViewControllers;

// 显示 viewcontroller 的容器
@property (nonatomic) UIScrollView *pageScrollView;

@end

@implementation DDTabPagerViewController {
  
  ItemCell *selectedItemCell;  // 当前选中选项卡
  ItemCell *leftItemCell; // 当前选项卡的左边一个
  ItemCell *rightItemCell; // 当前选项卡的右边一个
}

+ (instancetype) newWithViewControllerPicker:(DDViewControllerPicker)viewControllerPicker
                              itemScrollView:(DDItemScrollView *)itemScrollView
                            selectedItemCell:(ItemCell *)itemCell {
  
  DDTabPagerViewController *vc = [[DDTabPagerViewController alloc] init];
  vc.itemScrollView = itemScrollView;
  vc.viewControllerPicker = [viewControllerPicker copy];
  vc->selectedItemCell = itemCell;
  vc.loadedViewControllers = [NSMutableDictionary dictionary];
  vc.loadedItemCell = [NSMutableArray array];
  
  __weak typeof(vc) weakSelf = vc;
  vc.itemScrollView.tapItemBlock = ^(ItemCell *item) {
    
    __strong typeof(weakSelf) strongSelf = weakSelf;
    // 修改 tapItemBlock 的值为显示每个 viewController 的功能
		
		// 必须要在此处设置 selectedItemCell，目的是在 scrollViewDidScroll: 中要使用
    strongSelf->selectedItemCell = item;
	
    [strongSelf showViewControllerWithSelectedItemCell:item animation:YES];
		[strongSelf.pageScrollView setDelegate:nil];
		[strongSelf.pageScrollView scrollRectToVisible:[strongSelf getWillVisibleRectFromItemCell:item] animated:YES];
		
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[strongSelf.pageScrollView setDelegate:strongSelf];
		});
  };
  
  return vc;
}

- (void) viewDidLoad {
  [super viewDidLoad];
  
  [self.view setBackgroundColor:[UIColor whiteColor]];
	
  [self setPageScrollView:[self getPageScrollView]];
  [self.view addSubview:self.pageScrollView];
	
	[self.view addSubview:self.itemScrollView];
  
  // 激活状态的 itemscrollview 样式修改
  [self.itemScrollView setItemScrollViewSelectedState:YES];
  
  // 进入 tabPagerViewController 后，会有一个选中选项卡，对应的要显示当前的 viewController
  [self.pageScrollView scrollRectToVisible:[self getWillVisibleRectFromItemCell:selectedItemCell] animated:NO];
  [self showViewControllerWithSelectedItemCell:selectedItemCell animation:NO];
}

- (UIScrollView *)getPageScrollView {
  
  UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.itemScrollView.bottom, kWidth, self.view.height - self.itemScrollView.bottom)];
  [scrollView setShowsHorizontalScrollIndicator:NO];
  [scrollView setShowsVerticalScrollIndicator:NO];
  [scrollView setPagingEnabled:YES];
  [scrollView setDirectionalLockEnabled: YES];
  [scrollView setContentSize:CGSizeMake(kWidth * self.itemScrollView.items.count, scrollView.height)];
  [scrollView setDelegate:self];
  return scrollView;
}

- (void) showViewControllerWithSelectedItemCell: (ItemCell *)itemCell animation: (BOOL)animation {
  
  NSInteger index = [self.itemScrollView.itemCells indexOfObject:itemCell];
  if (index == NSNotFound) return;
  
  // 修改指示器的位置
  [self.itemScrollView moveIndicatorToSelectedItemCell:itemCell animation:animation];
	
	[self loadViewControllerAtIndex:index];
  
  leftItemCell = nil;
  rightItemCell = nil;
  
  if (index > 0) {
    leftItemCell = [self.itemScrollView.itemCells objectAtIndex:index - 1];
  }
  
  if (index + 1 < self.itemScrollView.itemCells.count) {
    rightItemCell = [self.itemScrollView.itemCells objectAtIndex:index + 1];
  }
}

#pragma mark -- UIScrollViewDelegare

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
	
	float contentOffsetX = scrollView.contentOffset.x;
	
	if (contentOffsetX >= self.pageScrollView.contentSize.width - self.pageScrollView.width ||
			contentOffsetX <= 0) {
		return;
	}
	
	float bothItemDiffX = 0;
	float bothItemDiffWidth = 0;
	float increaseValue = 0;
	float currentX = [self getWillVisibleRectFromItemCell:selectedItemCell].origin.x;
	BOOL direction = contentOffsetX > currentX;
	
	if (direction) {
		// 左滑
		bothItemDiffX = rightItemCell.x - selectedItemCell.x;
		bothItemDiffWidth = rightItemCell.width - selectedItemCell.width;
		increaseValue = contentOffsetX - currentX;
	} else {
		// 右滑
		bothItemDiffX = selectedItemCell.x - leftItemCell.x;
		bothItemDiffWidth = leftItemCell.width - selectedItemCell.width;
		increaseValue = currentX - contentOffsetX;
	}
	
	// 位置同比平移
	
	float	scaleX = bothItemDiffX / self.pageScrollView.width;
	float offsetItemCellX = 0;
	if (direction) {
		offsetItemCellX = selectedItemCell.x + ceil(increaseValue * scaleX);
	} else {
		offsetItemCellX = selectedItemCell.x - ceil(increaseValue * scaleX);
	}
	
	// 大小同比改变
	
	float scaleWith = bothItemDiffWidth / self.pageScrollView.width;
	float offsetItemCellWidth = selectedItemCell.width + ceilf(increaseValue * scaleWith);
	
	// 移动指示器
	[self.itemScrollView updateIndicatorViewWithFrame:CGRectMake(offsetItemCellX, selectedItemCell.y, offsetItemCellWidth  , selectedItemCell.height)];
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  selectedItemCell = [self getWillShowItemCellByPageScrollViewContentOffset:scrollView.contentOffset];
  [self showViewControllerWithSelectedItemCell:selectedItemCell animation:YES];
}


#pragma mark -- private method

/**
 *  加载一个 viewController 到 pageScrollView 上
 *
 *  @param index self.itemScrollView.itemCells 中的索引
 *
 *  @return 要显示的 viewController
 */
- (UIViewController *) loadViewControllerAtIndex:(NSInteger) index {
	if (index >= self.itemScrollView.itemCells.count) return nil;
	
	ItemCell *itemCell = [self.itemScrollView.itemCells objectAtIndex:index];
	
	UIViewController *selectedVC = [self.loadedViewControllers objectForKey:itemCell.model.itemName];
	if (selectedVC) {
		
		// 把 itemCell 放到最大索引的位置
		// 数据的销毁是按索引从小到大
		[self.loadedItemCell removeObject:itemCell];
		[self.loadedItemCell addObject:itemCell];
		
		return selectedVC;
	}
	
  UIViewController *vc = self.viewControllerPicker(itemCell.model);
  if (!vc) return nil;
  
  // 要显示的 viewController 的位置
  CGRect frame = CGRectMake(kWidth * index, 0, self.pageScrollView.width, self.pageScrollView.height);
  
  [vc.view setFrame:frame];
  [vc willMoveToParentViewController:self];
  [self addChildViewController:vc];
  [self.pageScrollView addSubview:vc.view];
  [self didMoveToParentViewController:self];
  
  // 保存当前显示的 itemCell 和 viewController ，并保留了显示顺序，有利于销毁数据的顺序
  [self.loadedViewControllers setObject:vc forKey:itemCell.model.itemName];
  [self.loadedItemCell addObject:itemCell];
  
  return vc;
}

/**
 *  从 self.loadedViewControllers 删除一项数据，同时要删除 self.loadedItemCell 内对应的数据
 *
 *  @param index self.loadedItemCell 的索引
 */
- (void) removeViewControllerAtIndex: (NSInteger)index {
  ItemCell *item = [self.loadedItemCell objectAtIndex:index];
  
  [self.loadedViewControllers removeObjectForKey:item.model.itemName];
  [self.loadedItemCell removeObject:item];
}

/**
 *  根据 itemCell 计算出 对应的 viewController 的 frame
 *
 *  @param itemCell 目标选项卡
 *
 *  @return viewController 的 frame
 */
- (CGRect) getWillVisibleRectFromItemCell: (ItemCell *)itemCell {
  
  NSInteger index = [self.itemScrollView.itemCells indexOfObject:itemCell];
  if (index == NSNotFound) return CGRectZero;
  
  return CGRectMake(self.pageScrollView.width * index , 0, self.pageScrollView.width, self.pageScrollView.height);
}

/**
 *  根据 viewController 的 origin 获取对应的 ItemCell
 *
 *  @param point viewController.frame 的 origin
 *
 *  @return ItemCell 对象
 */
- (ItemCell *) getWillShowItemCellByPageScrollViewContentOffset: (CGPoint) point {
  
  NSInteger index = point.x / self.pageScrollView.width;

  if (index < self.itemScrollView.itemCells.count) {
    return [self.itemScrollView.itemCells objectAtIndex:index];
  }
  
  return selectedItemCell;
}


- (void) dealloc {

}


@end
