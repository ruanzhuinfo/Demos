//
//  DDItemScrollView.m
//  Demos
//
//  Created by taffy on 16/4/22.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import "DDItemScrollView.h"

#define kHeight 48
#define kItemCellEdgeInsetsTop 5
#define kItemCellEdgeInsetsLeft 10
#define kItemsMarginLeft 15
#define kItemsMarginTop 9


#pragma mark - ItemModel implementation
@implementation ItemModel
@end


#pragma mark - ItemCell implementation
@interface ItemCell()
@property (nonatomic) UILabel *nameLabel;

- (id) initWithFrame:(CGPoint)point model: (ItemModel *)model style: (ItemCellBorderStyle)style;
- (void) updateItemCellLayout;
- (void) updateItemCellBorderWithStyle:(ItemCellBorderStyle)style;
@end

@implementation ItemCell

- (id)initWithFrame:(CGPoint)point model:(ItemModel *)model style:(ItemCellBorderStyle)style {
  self = [super init];
  if (self) {
    self.model = model;
    self.frame = CGRectMake(point.x, point.y, 0, 0);
    self.nameLabel = [[UILabel alloc] init];
    
    [self addSubview:self.nameLabel];
    [self updateItemCellLayout];
  }
  
  return self;
}

- (void) updateItemCellLayout {
  NSString *itemNameString = self.model.itemName;
  NSString *countString = nil;
  NSString *newTipString = nil;
  NSMutableAttributedString *attributed = nil;
  
  // 未读数
  if (self.model.unReadCount > 10) {
    countString = @" 10+";
  }
  else if (self.model.unReadCount > 0) {
    countString = [NSString stringWithFormat:@" %ld", (long)self.model.unReadCount];
  }
  
  if (countString) {
    itemNameString = [itemNameString stringByAppendingString:countString];
  }
  
  // 新增的 item
  if (self.model.isNew) {
    newTipString = @" NEW";
    itemNameString = [itemNameString stringByAppendingString:newTipString];
  }
  
  attributed = [[NSMutableAttributedString alloc] initWithString:itemNameString
                                                      attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                                   NSForegroundColorAttributeName: [UIColor blackColor]}];
  if (countString) {
    [attributed addAttributes:@{NSForegroundColorAttributeName: [UIColor grayColor], NSFontAttributeName: [UIFont boldSystemFontOfSize:12]}
                        range:[itemNameString rangeOfString:countString]];
  }
  if (newTipString) {
    [attributed addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10 weight:3],
                                NSForegroundColorAttributeName: [UIColor orangeColor]}
                        range:[itemNameString rangeOfString:newTipString]];
  }
  
  //    UIImage *img = [UIImage imageNamed:imgName];
  //    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
  //    textAttachment.image = img;
  //    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
  //    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
  //    [attrStr appendAttributedString:attrStringWithImage];

  [self.nameLabel setAttributedText:attributed];
  CGRect estimate = [attributed boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20)
                                             options:NSStringDrawingUsesLineFragmentOrigin context:nil];
  
  [self setWidth:ceilf(CGRectGetWidth(estimate)) + kItemCellEdgeInsetsLeft * 2];
  [self setHeight:ceilf(CGRectGetHeight(estimate)) + kItemCellEdgeInsetsTop * 2];
  [self.nameLabel setFrame:CGRectMake(kItemCellEdgeInsetsLeft,
                                      kItemCellEdgeInsetsTop,
                                      ceil(CGRectGetWidth(estimate)),
                                      ceilf(CGRectGetHeight(estimate)))];
  [self.layer setCornerRadius: self.height / 2];
  [self.layer setBorderWidth:0.5];
}

- (void) updateItemCellBorderWithStyle:(ItemCellBorderStyle)style {
  [self.layer setBorderColor:((UIColor *)[self.class itemCellBorderColor:style]).CGColor];
}


#pragma mark -- private method

+ (id) itemCellBorderColor: (ItemCellBorderStyle) style {
  id borderColorPicker = nil;
  switch(style) {
    case ItemCellBorderLightGrey:
      borderColorPicker = [UIColor grayColor];
      break;
    case ItemCellBorderGrey:
      borderColorPicker = [UIColor lightGrayColor];
      break;
    case ItemCellBorderNone:
    default:
      borderColorPicker = [UIColor clearColor];
  }
  return borderColorPicker;
}

@end



#pragma mark - DDItemScrollView implementation

@interface DDItemScrollView()

@property (nonatomic) UIScrollView *itemScrollView;
@property (nonatomic) UIView *indicatorView;                // 选中的 itemCell 标示
@property (nonatomic) UIView *shadowView;

@end

@implementation DDItemScrollView

+ (instancetype) newWithPoint:(CGPoint)point
                        items:(NSArray *)items
             makeItemCallback: (MakeItemModelBlock) makeItemCallback
              tapItemCallback:(TapItemBlock)tapItemCallback {
  
  DDItemScrollView *view = [DDItemScrollView new];
  view.items = items;
  view.tapItemBlock = [tapItemCallback copy];
  view.makeItemBlock = [makeItemCallback copy];
	
  __weak typeof(view) weakView = view;
  [view itemCellCollection:^(UIScrollView *scrollView, NSArray *itemCells) {
    
    __strong typeof(weakView) strongView = weakView; if (!strongView) return;
    strongView.itemScrollView = scrollView;
    strongView.itemCells = itemCells;
    
    [strongView addSubview:scrollView];
    [strongView setFrame:CGRectMake(point.x, point.y, kWidth, scrollView.height)];
		[strongView setShadowView:[weakView getShadowView]];
  }];
  
  return view;
}

- (void) itemCellCollection: (void (^)(UIScrollView *, NSArray *)) callback {
  UIScrollView *sv = [[UIScrollView alloc] initWithFrame:self.bounds];
  [sv setBackgroundColor:[UIColor clearColor]];
  [sv setShowsHorizontalScrollIndicator:NO];
  [sv setShowsVerticalScrollIndicator:NO];
  [sv setAlwaysBounceHorizontal:YES];
  
  NSMutableArray *itemCells = [[NSMutableArray alloc] init];
  
  ItemCell *tempItemCell = nil;
  
  for (int i = 0; i < self.items.count; i++) {
    tempItemCell = [[ItemCell alloc] initWithFrame:CGPointMake(tempItemCell.right + kItemsMarginLeft, kItemsMarginTop)
                                             model:self.makeItemBlock([self.items objectAtIndex:i])
                                             style:ItemCellBorderLightGrey];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapItemCell:)];
    [tempItemCell addGestureRecognizer:tap];
    
    [sv addSubview:tempItemCell];
    [itemCells addObject:tempItemCell];
  }
  
  [sv setFrame:CGRectMake(0, 0, kWidth, tempItemCell.height + kItemsMarginTop * 2)];
  sv.contentSize = CGSizeMake(tempItemCell.right + kItemsMarginLeft, sv.height);
  
  callback(sv, [itemCells copy]);
}

- (void) setItemScrollViewSelectedState:(BOOL)itemScrollViewSelectedtate {

  if (itemScrollViewSelectedtate) {
    for (ItemCell *cell in self.itemCells) {
      [cell updateItemCellBorderWithStyle:ItemCellBorderNone];
    }
		
		[self.shadowView setOrigin:CGPointMake(0, self.height - 4)];
  } else {
    for (ItemCell *cell in self.itemCells) {
      [cell updateItemCellBorderWithStyle:ItemCellBorderGrey];
    }
		
		[self.shadowView setOrigin:CGPointZero];
  }
}

- (void) moveIndicatorToSelectedItemCell:(ItemCell *)itemCell animation:(BOOL)animation {

  void (^runCode)() = ^{
    [self updateIndicatorViewWithFrame:itemCell.frame];
  };
  
  [UIView animateWithDuration:0.2 animations:^{
    itemCell.model.unReadCount = 0;
    itemCell.model.isNew = NO;
    [itemCell updateItemCellLayout];
    [self layoutScollViewSubviewsWithIndex:[self.itemCells indexOfObject:itemCell]];
		
    // 移动指示器到屏障中心位置
    [self.itemScrollView scrollRectToVisible:CGRectMake(itemCell.center.x - self.itemScrollView.width / 2, itemCell.y, self.itemScrollView.width, 1) animated:YES];
		
    if (animation) runCode();
  }];
  
  if (!animation) runCode();
}

- (void) updateIndicatorViewWithFrame: (CGRect) rect {
  
  if (!self.indicatorView) {
    self.indicatorView = [[UIView alloc] init];
    [self.indicatorView.layer setBorderWidth:0.5];
    [self.indicatorView.layer setBorderColor:((UIColor *)[ItemCell itemCellBorderColor:ItemCellBorderLightGrey]).CGColor];
    [self.itemScrollView addSubview:self.indicatorView];
  }
  
  [self.indicatorView setFrame:rect];
  [self.indicatorView.layer setCornerRadius: CGRectGetHeight(rect) / 2];
}


#pragma mark -- itemCell tap gesture selector
- (void) didTapItemCell: (UITapGestureRecognizer *)tap {
  ItemCell *cell = (ItemCell *)tap.view;
  if (!cell) return;

  self.tapItemBlock(cell);
}


#pragma mark -- private method


/**
 *  ItemCell 的大小会改变，itemScrollView 中只要有一个改变了，那么其后边的都要跟着改变
 *
 *  @param index itemCells 中的一个索引，为了高效，所以只改 index 之后的 frame
 */
- (void) layoutScollViewSubviewsWithIndex: (NSInteger) index  {
  
  ItemCell *tempCell = [self.itemCells objectAtIndex:index];
  
  for (NSInteger i = index + 1; i < self.itemCells.count; i++) {
    ItemCell *cell = [self.itemCells objectAtIndex:i];
    [cell setOrigin:CGPointMake(tempCell.right + kItemsMarginLeft, kItemsMarginTop)];
    tempCell = cell;
  }
  
  [self.itemScrollView setContentSize:CGSizeMake(tempCell.right + kItemsMarginLeft, self.itemScrollView.height)];
}

- (UIView *)getShadowView {
	UIImageView *barShadow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, 4)];
	[barShadow setContentMode:UIViewContentModeScaleToFill];
	[barShadow setImage:[UIImage imageNamed:@"Feed_barShadow"]];
	[self addSubview:barShadow];
	return barShadow;
}







@end


