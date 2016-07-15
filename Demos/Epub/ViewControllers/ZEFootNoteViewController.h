//
//  ZEFootNoteViewController.h
//  Demos
//
//  Created by taffy on 16/7/13.
//  Copyright © 2016年 taffy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZEBook;

@interface ZEFootNoteViewController : UIViewController

+ (instancetype)newWithBook:(ZEBook *)book footNoteURL:(NSURL *)URL;


@end
