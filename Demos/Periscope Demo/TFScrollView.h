//
//  TFScrollView.h
//  Demos
//
//  Created by taffy on 15/9/22.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFScrollViewDelegate <NSObject>

- (UIView *) customScrollViewHistTest: (CGPoint)point withEvent:(UIEvent *)event ;
- (BOOL) customGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
- (void) customHandlPanView: (UIPanGestureRecognizer *)pan withView: (UIView *)view;
@end

@interface TFScrollView : UIScrollView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) id<TFScrollViewDelegate>scrollViewDelegate;

@end
