//
//  TFView.h
//  Demos
//
//  Created by taffy on 15/9/20.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFViewDelegate <NSObject>

- (id) customViewHistTest: (CGPoint) point
                withEvent: (UIEvent *)event
                 withView: (UIView *)view;

@end


@interface TFView : UIImageView


@property (nonatomic, assign) id<TFViewDelegate>viewDelegate;
@end
