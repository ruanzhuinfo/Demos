//
//  TFSpringCollectionViewFlowLayout.m
//  Demos
//
//  Created by taffy on 15/9/25.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import "TFSpringCollectionViewFlowLayout.h"

@implementation TFSpringCollectionViewFlowLayout

- (id)init: (CGSize)size {
  
  if (!(self = [super init])) return nil;
  
  self.minimumInteritemSpacing = 10;
  self.minimumInteritemSpacing = 10;
  self.itemSize = size;
  self.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
  
  self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
  
  return self;
}

- (void)prepareLayout {
  [super prepareLayout];
  
//  CGRect originalRect = (CGRect){.origin = self.collectionView.bounds.origin, .size = self.collectionView.frame.size};
//  CGRect visibleRect = CGRectInset(originalRect, -100, -100);
//  
//  NSArray *itesInVisibleRectArray = [super layoutAttributesForElementsInRect:visibleRect];
//  NSSet *itemsIndexPathsInVisibleRectSet = [NSSet setWithArray:[itesInVisibleRectArray valueForKey:@"indexPath"]];
//  
//  NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
//    BOOL currentlyVisible = [itemsIndexPathsInVisibleRectSet member:[[evaluatedObject items] firstObject]] != nil;
//    return !currentlyVisible;
//  
//  }];
//  
//  NSArray *noLongerVisibleBehaviours = [self.dynamicAnimator.behaviors filteredArrayUsingPredicate:predicate];
//  [noLongerVisibleBehaviours enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//    [self.dynamicAnimator removeBehavior:obj];
//    [self.visibleIndexPathSet removeObject:[obj items].firstObject];
//  }];
//  NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
//    BOOL currentlyVisible = [self.visibleIndexPathSet member:evaluatedObject.indexPath] != nil;
//    
//    return !currentlyVisible;
//  }];
//  
//  NSArray *newlyVisibleItems = [itemsInVisibleRectArray filteredArrayUsingPredicate:predicate];
//  
//  
  CGSize contentSize = self.collectionView.contentSize;
  NSArray *items = [super layoutAttributesForElementsInRect:CGRectMake(0.0f, 0.0f, contentSize.width, contentSize.height)];
  
  if (self.dynamicAnimator.behaviors.count == 0) {
    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      
      UIAttachmentBehavior *behaviour = [[UIAttachmentBehavior alloc] initWithItem:obj
                                                                  attachedToAnchor:[(UIView *)obj center]];
      behaviour.length = 0.0f;
      behaviour.damping = 0.8f;
      
      behaviour.frequency = 1.0f;
      [self.dynamicAnimator addBehavior:behaviour];
      
    }];
  }
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
  return (NSArray<UICollectionViewLayoutAttributes *> *)[self.dynamicAnimator itemsInRect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
  return [self.dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
}


- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
  
  UIScrollView *scrollView = self.collectionView;
  CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;
  CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
  
  self.latestDelta = delta;

  [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(__kindof UIDynamicBehavior * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    UIAttachmentBehavior *behavior = (UIAttachmentBehavior *)obj;
    CGFloat yDistanceFromTouch = fabs(touchLocation.y - behavior.anchorPoint.y);
    CGFloat xDistanceFromTouch = fabs(touchLocation.x - behavior.anchorPoint.x);
    CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0f;
    
    UICollectionViewLayoutAttributes *item = (UICollectionViewLayoutAttributes *)(behavior.items.firstObject);
    CGPoint center = item.center;
    
    if (delta < 0) {
      center.y += MAX(delta, delta * scrollResistance);
    }
    else {
      center.y += MIN(delta, delta*scrollResistance);
    }
    
    item.center = center;
    
    [self.dynamicAnimator updateItemUsingCurrentState:item];
  }];
  
  return NO;
}

@end
