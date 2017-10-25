//
//  UIEngine.h
//  Train
//
//  Created by 蔡建海 on 15/11/30.
//  Copyright © 2015年 HeXun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CoreEngine;

@interface UIEngine : NSObject

@property (nonatomic, readonly) UIViewController *rootVC;
@property (nonatomic, strong) CoreEngine *engineCore;

// 远程通知处理
- (void)engineUIApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;

@end
