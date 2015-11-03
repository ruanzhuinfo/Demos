//
//  AppDelegate.m
//  Demos
//
//  Created by taffy on 15/9/20.
//  Copyright © 2015年 taffy. All rights reserved.
//

#import "AppDelegate.h"
#import "DemoListViewController.h"
#import "SpotlightManage.h"

@import CoreSpotlight;

@interface AppDelegate () <CSSearchableIndexDelegate>

@end



@implementation AppDelegate 


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  
  UINavigationController *nav = [[UINavigationController alloc]
                                 initWithRootViewController:
                                 [[DemoListViewController alloc] init]];
  
  [self.window setBackgroundColor:[UIColor whiteColor]];
  [self.window setRootViewController:nav];
  
  [[UINavigationBar appearance] setTranslucent:NO];
  
  
  if ([CSSearchableIndex isIndexingAvailable]) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
      [CSSearchableIndex defaultSearchableIndex].indexDelegate = self;
      [SpotlightManage addArticlesSearchableItems:DATA_LIST];
    });
  }
  
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didFailToContinueUserActivityWithType:(NSString *)userActivityType error:(NSError *)error {
//  if userActivity.activityType == CSSearchableItemActionType {
//    // This activity represents an item indexed using Core Spotlight, so restore the context related to the unique identifier.
//    // Note that the unique identifier of the Core Spotlight item is set in the activity’s userInfo property for the key CSSearchableItemActivityIdentifier.
//    let uniqueIdentifier = userActivity.userInfo? [CSSearchableItemActivityIdentifier] as? String
//    // Next, find and open the item specified by uniqueIdentifer.
//  }
  
  
  
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
  if ([userActivity.activityType isEqualToString:CSSearchableItemActionType]) {
    NSLog(@"success!");
  }
  
  return YES;
}

- (void)searchableIndex:(CSSearchableIndex *)searchableIndex reindexSearchableItemsWithIdentifiers:(NSArray<NSString *> *)identifiers acknowledgementHandler:(void (^)(void))acknowledgementHandler {
  
}

@end
