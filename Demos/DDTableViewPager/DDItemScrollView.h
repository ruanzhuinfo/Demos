//
//  DDItemScrollView.h
//  Demos
//
//  Created by taffy on 16/4/22.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kWidth [UIScreen mainScreen].bounds.size.width

typedef NS_OPTIONS(NSInteger, ItemCellBorderStyle) {
  ItemCellBorderNone = 0,
  ItemCellBorderLightGrey,
  ItemCellBorderGrey
};

@interface ItemModel : NSObject

@property (nonatomic) NSInteger unReadCount;
@property (nonatomic) NSString *itemName;
@property (nonatomic) BOOL isNew;

@end

@interface ItemCell : UIView

@property (nonatomic) ItemModel *model;

@end

typedef void (^TapItemBlock)(id);
typedef ItemModel *(^MakeItemModelBlock)(id model);

@interface DDItemScrollView : UIView

// 分两种状态，未点击 itemcell 状态 DDItemScrollView 上边缘有阴影和每个 itemCell 都有 border, 点击 itemcell  后会激活 itemScrollView ，下边缘会有阴影和选中的 itemCell 才会有 border
// NO: 为点击状态， YES: 点击后状态
@property (nonatomic, readwrite) BOOL itemScrollViewSelectedState;

// 原生数据集合，元素会生成 ItemModel 类型
@property (nonatomic) NSArray *items;

// 点击 ItemCell 时的回调
@property (nonatomic) TapItemBlock tapItemBlock;

// 生成一个 ItemModel 的回调
@property (nonatomic) MakeItemModelBlock makeItemBlock;

// 在 itemScrollView 上的所有 itemCell
@property (nonatomic) NSArray *itemCells;

+ (instancetype) newWithPoint: (CGPoint)point
                        items: (NSArray *)items
             makeItemCallback: (MakeItemModelBlock) makeItemCallback
              tapItemCallback: (TapItemBlock) tapItemCallback;

/**
 *  该方法的功能除了把指示器移动到选中的选项卡上之外，还修改了对应的 ItemModel 数据，isNew = 0, unreadCount = 0
 *
 *  @param itemCell  选项卡对象
 *  @param animation 动画
 */
- (void) moveIndicatorToSelectedItemCell: (ItemCell *)itemCell animation: (BOOL) animation;

/**
 *  选中 itemcell 后，要修改游标的位置
 *
 *  @param rect 选中 itemCell 的 frame
 */
- (void) updateIndicatorViewWithFrame: (CGRect) rect;


@end









