//
//  UIAlertController+HXMPushToastViewController.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/5/3.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "UIAlertController+HXMPushToastViewController.h"

@implementation UIAlertController (HXMPushToastViewController)

- (void)pushWithTitle:(NSString *)titleName massage:(NSString *)message imageName:(NSString *)imageName withCancleButton:(NSString *)cancleButtonName settingButton:(NSString *) settingButtonnName{

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:titleName message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:cancleButtonName style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:settingButtonnName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }]];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 126, 114)];
    view.backgroundColor = [UIColor redColor];
    UIImageView *tipIconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 126, 114)];
    [view addSubview:tipIconView];
    [alertVC.view addSubview:view];
    
    [self presentViewController:alertVC animated:YES completion:nil];

}
@end
