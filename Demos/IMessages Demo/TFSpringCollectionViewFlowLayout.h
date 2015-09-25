//
//  TFSpringCollectionViewFlowLayout.h
//  Demos
//
//  Created by taffy on 15/9/25.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFSpringCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, assign) CGFloat latestDelta;
@property (nonatomic, strong) NSMutableSet *visibleIndexPathSet;

- (id)init: (CGSize) size;

@end
