//
//  HXMProgressHUD.h
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/3/22.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//


#import <Foundation/Foundation.h>
//#import <MBProgressHUD/MBProgressHUD.h>
#import "HXMProgressHUD.h"
//  提示类型
typedef NS_ENUM(NSInteger, HXMProgressHUDType){
    HXMProgressHUDTypeOnlyText=10,           //文字底部
    HXMProgressHUDTypeCenterText,            //文字中间
    HXMProgressHUDTypeLoading,               //加载菊花
    HXMProgressHUDTypeCircleLoading,         //加载圆形
    HXMProgressHUDTypeSuccess,               //成功
    HXMProgressHUDTypeError,                 //失败
    HXMProgressHUDTypeCustomAnimation,       //自定义加载动画（序列帧实现）
};

@interface HXMProgressHUD : NSObject

//  属性
@property (nonatomic,strong) MBProgressHUD  *hud;

//  单例
+ (instancetype)shareinstance;

//  显示
+ (void)show:(NSString *)msg inView:(UIView *)view mode:(HXMProgressHUDType)myMode;

//  隐藏
+ (void)hide;

//  加载菊花,不带文字
+ (void)showInView:(UIView *)view;

//  显示文字,在屏幕中心
+ (void)showCenterMessage:(NSString *)msg;

//  显示提示（1秒后消失）
+ (void)showMessage:(NSString *)msg inView:(UIView *)view;

//  显示提示（N秒后消失）
+ (void)showMessage:(NSString *)msg inView:(UIView *)view afterDelayTime:(NSInteger)delay;

//  显示进度(转圈)
+ (MBProgressHUD *)showProgressCircle:(NSString *)msg inView:(UIView *)view;

//  显示进度(菊花)
+ (void)showProgress:(NSString *)msg inView:(UIView *)view;

//  显示成功提示
+ (void)showSuccess:(NSString *)msg inview:(UIView *)view;

//  显示失败提示
+ (void)showError:(NSString *)msg inview:(UIView *)view;

//  在最上层显示
+ (void)showMsgWithoutView:(NSString *)msg;

//  显示自定义动画
+ (void)showCustomAnimation:(NSString *)msg withImgArry:(NSArray *)imgArry inview:(UIView *)view;


@end
