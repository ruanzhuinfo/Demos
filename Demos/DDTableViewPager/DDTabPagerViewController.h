//
//  DDTabPagerViewController.h
//  Demos
//
//  Created by taffy on 16/4/25.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDItemScrollView.h"

typedef UIViewController* (^DDViewControllerPicker)(id model);

@interface DDTabPagerViewController : UIViewController

+ (instancetype) newWithViewControllerPicker: (DDViewControllerPicker)viewControllerPicker
                              itemScrollView: (DDItemScrollView *)itemScrollView
                            selectedItemCell: (ItemCell *)itemCell;


@end
