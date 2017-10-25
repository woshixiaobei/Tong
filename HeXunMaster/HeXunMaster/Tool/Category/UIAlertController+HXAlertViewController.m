//
//  UIAlertController+HXAlertViewController.m
//  
//
//  Created by wangmingzhu on 16/10/23.
//  Copyright © 2016年 wangmingzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAlertController+HXAlertViewController.h"

@implementation UIAlertController (HXAlertViewController)

+ (void)alertWithTitle:(NSString *)title handleVC:(UIViewController *)vc WithMessage:(NSString *)message withSettingBtnName:(NSString *)settingBtnName withDefaultBtnName:(NSString *)defaultBtnName {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:defaultBtnName style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *settingAction = [UIAlertAction actionWithTitle:settingBtnName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
        
        
    }];
    [alertController addAction:defaultAction];
    [alertController addAction:settingAction];
    [vc presentViewController:alertController animated:YES completion:nil];
    
    
}

+ (void)alertWithTitle:(NSString *)title handleVC:(UIViewController *)vc WithMessage:(NSString *)message withSettingBtnName:(NSString *)settingBtnName withDefaultBtnName:(NSString *)defaultBtnName phoneNumber:(NSString *)phoneNumber{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:defaultBtnName style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *settingAction = [UIAlertAction actionWithTitle:settingBtnName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //开启拨打电话
        ApplicationOpenTelWithPhoneNumber(phoneNumber);
    }];
    [alertController addAction:settingAction];
    [alertController addAction:defaultAction];
    [vc presentViewController:alertController animated:YES completion:nil];
    
    
}
@end
