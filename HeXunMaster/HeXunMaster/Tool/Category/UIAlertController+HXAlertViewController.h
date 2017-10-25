//
//  UIAlertController+HXAlertViewController.h
//  
//
//  Created by wangmingzhu on 16/10/23.
//  Copyright © 2016年 wangmingzhu. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIAlertController (HXAlertViewController)

+ (void)alertWithTitle:(NSString *)title handleVC:(UIViewController *)vc WithMessage:(NSString *)message withSettingBtnName:(NSString *)settingBtnName withDefaultBtnName:(NSString *)defaultBtnName;

+ (void)alertWithTitle:(NSString *)title handleVC:(UIViewController *)vc WithMessage:(NSString *)message withSettingBtnName:(NSString *)settingBtnName withDefaultBtnName:(NSString *)defaultBtnName phoneNumber:(NSString *)phoneNumber;
@end
