//
//  HXMProgressHUD.m
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/3/22.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//


#import "HXMProgressHUD.h"

@implementation HXMProgressHUD

+ (instancetype)shareinstance{
    
    static HXMProgressHUD *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HXMProgressHUD alloc] init];
    });
    return instance;
}


+ (void)show:(NSString *)msg inView:(UIView *)view mode:(HXMProgressHUDType) myMode{
    
    [self show:msg inView:view mode:myMode customImgView:nil];
}

+ (void)show:(NSString *)msg inView:(UIView *)view mode:(HXMProgressHUDType)myMode customImgView:(UIImageView *)customImgView{
    
    //  如果已有弹框，先消失
    if ([HXMProgressHUD shareinstance].hud != nil) {
        [[HXMProgressHUD shareinstance].hud hideAnimated:YES];
        [HXMProgressHUD shareinstance].hud = nil;
    }
    
    //  4\4s屏幕避免键盘存在时遮挡
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        [view endEditing:YES];
    }
    
    [HXMProgressHUD shareinstance].hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [HXMProgressHUD shareinstance].hud.backgroundColor = [UIColor clearColor];
    
    //  是否设置黑色背景，这两句配合使用
    [HXMProgressHUD shareinstance].hud.bezelView.backgroundColor = [UIColor blackColor];
    [HXMProgressHUD shareinstance].hud.contentColor = [UIColor whiteColor];
    
    [[HXMProgressHUD shareinstance].hud setRemoveFromSuperViewOnHide:YES];
    if(msg)[HXMProgressHUD shareinstance].hud.detailsLabel.text = msg;
    [HXMProgressHUD shareinstance].hud.detailsLabel.font = [UIFont systemFontOfSize:15];
    
    switch (myMode) {
            
        case HXMProgressHUDTypeOnlyText:
            [HXMProgressHUD shareinstance].hud.mode = MBProgressHUDModeText;
            [[HXMProgressHUD shareinstance].hud setMargin:13];
            [HXMProgressHUD shareinstance].hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            break;
            
            
        case HXMProgressHUDTypeCenterText:
            [HXMProgressHUD shareinstance].hud.mode = MBProgressHUDModeText;
            [[HXMProgressHUD shareinstance].hud setMargin:13];
            break;
            
        case HXMProgressHUDTypeLoading:
            [HXMProgressHUD shareinstance].hud.mode = MBProgressHUDModeIndeterminate;
            break;
            
        case HXMProgressHUDTypeCircleLoading:
            [HXMProgressHUD shareinstance].hud.mode = MBProgressHUDModeDeterminate;
            break;
            
        case HXMProgressHUDTypeSuccess:
            [HXMProgressHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
            [HXMProgressHUD shareinstance].hud.customView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"success"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            break;
            
        case HXMProgressHUDTypeError:
            [HXMProgressHUD shareinstance].hud.mode = MBProgressHUDModeCustomView;
            [HXMProgressHUD shareinstance].hud.customView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"error"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            break;
            
            
        default:
            break;
    }
}


+ (void)hide{
    if ([HXMProgressHUD shareinstance].hud != nil) {
        [[HXMProgressHUD shareinstance].hud hideAnimated:YES];
    }
}

+ (void)showInView:(UIView *)view{
      [self show:nil inView:view mode:HXMProgressHUDTypeLoading];
}


+ (void)showCenterMessage:(NSString *)msg{
    [self show:msg inView:[UIApplication sharedApplication].keyWindow mode:HXMProgressHUDTypeCenterText];
    [[HXMProgressHUD shareinstance].hud hideAnimated:YES afterDelay:1];
}


+ (void)showMessage:(NSString *)msg inView:(UIView *)view{
    [self show:msg inView:view mode:HXMProgressHUDTypeOnlyText];
    [[HXMProgressHUD shareinstance].hud hideAnimated:YES afterDelay:1];
}



+ (void)showMessage:(NSString *)msg inView:(UIView *)view afterDelayTime:(NSInteger)delay{
    [self show:msg inView:view mode:HXMProgressHUDTypeOnlyText];
    [[HXMProgressHUD shareinstance].hud hideAnimated:YES afterDelay:delay];
}

+ (void)showSuccess:(NSString *)msg inview:(UIView *)view{
    [self show:msg inView:view mode:HXMProgressHUDTypeSuccess];
    [[HXMProgressHUD shareinstance].hud hideAnimated:YES afterDelay:1.0];
    
}

+ (void)showError:(NSString *)msg inview:(UIView *)view{
    [self show:msg inView:view mode:HXMProgressHUDTypeError];
    [[HXMProgressHUD shareinstance].hud hideAnimated:YES afterDelay:2.0];
}


+ (void)showProgress:(NSString *)msg inView:(UIView *)view{
    [self show:msg inView:view mode:HXMProgressHUDTypeLoading];
}

+ (MBProgressHUD *)showProgressCircle:(NSString *)msg inView:(UIView *)view{
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = msg;
    return hud;
}


+ (void)showMsgWithoutView:(NSString *)msg{
    UIWindow *view = [[UIApplication sharedApplication].windows lastObject];
    [self show:msg inView:view mode:HXMProgressHUDTypeOnlyText];
    [[HXMProgressHUD shareinstance].hud hideAnimated:YES afterDelay:1.0];
    
}

+ (void)showCustomAnimation:(NSString *)msg withImgArry:(NSArray *)imgArry inview:(UIView *)view{
    
    UIImageView *showImageView = [[UIImageView alloc] init];
    showImageView.animationImages = imgArry;
    [showImageView setAnimationRepeatCount:0];
    [showImageView setAnimationDuration:(imgArry.count + 1) * 0.075];
    [showImageView startAnimating];
    [self show:msg inView:view mode:HXMProgressHUDTypeCustomAnimation customImgView:showImageView];
    [[HXMProgressHUD shareinstance].hud hideAnimated:YES afterDelay:8.0];
}

@end
