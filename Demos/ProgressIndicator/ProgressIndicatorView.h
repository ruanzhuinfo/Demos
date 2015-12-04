//
//  ProgressIndicatorView.h
//  Demos
//
//  Created by taffy on 15/12/3.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompletionProgressBlock)();

@interface ProgressIndicatorView : UIView

- (void) showProgressAddToView: (UIView *)inView;
- (void) finishedProgress:(BOOL)finished completionProgress: (CompletionProgressBlock)completionProgress;

@end
