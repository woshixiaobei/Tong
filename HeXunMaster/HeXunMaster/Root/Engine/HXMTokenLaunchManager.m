//
//  HXMTokenLaunchManager.m
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/6/7.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMTokenLaunchManager.h"
#import "HXHttpHelper.h"
#import "AccountTool.h"
#import "HXMProgressHUD.h"
#import "HXMLoginViewController.h"
#import "UMessage.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@implementation HXMTokenLaunchManager

//+ (void)sharedManager {
//
//    HXMTokenLaunchManager *manager = [[HXMTokenLaunchManager alloc]init];
//    
//    [manager loginWithToken];
//}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        [self autoLogin];
    }
    return self;
}

- (void)autoLogin {

    [self loginWithToken];
}

- (void)loginWithToken {
    
    @weakify(self)
    HXMUser *user = [AccountTool userInfo];
    NSString *token = user.token;
    
    if (token.isNotBlank) {
        
        [HXMProgressHUD showInView:[UIApplication sharedApplication].delegate.window];
        [HXHttpHelper api_postSendVerficationCodeToGetTokenWithUsername:user.username withAccessToken:token success:^(id responseObject) {
            @strongify(self)
            
            [HXMProgressHUD hide];
            if ([responseObject[@"state"] integerValue] == 0) {
                if ([responseObject[@"data"][@"result"] integerValue] == 0) { // 获取token成功且有效
                    // 跳转首页
                 
                    HXMUser *user = [HXMUser mj_objectWithKeyValues:responseObject[@"data"]];
                    user.token = token;
                    [AccountTool save:user];
                    
                    //注册友盟获取alias
                    NSString *companyCode = [AccountTool userInfo].company_code;
                    [UMessage addAlias:companyCode type:kUMessageAliasTypeCompanyCode response:^(id responseObject, NSError *error) {
                        NSLog(@"----------------------%@",responseObject);
                    }];
      
                } else if ([responseObject[@"data"][@"result"] integerValue] == 1) { // 获取token错误
                     [self resetUserInfoThenToLoginWithMessage:@"账号已登录其它设备，请重新登录" showingToast:YES];

                } else if ([responseObject[@"data"][@"result"] integerValue] == 2) { // 获取token无效
                    [self resetUserInfoThenToLoginWithMessage:@"获取token失效" showingToast:YES];
                    
                }
            } else {
                // 其他state情况
                HXMLoginViewController *vc = [[HXMLoginViewController alloc]init];
                [UIApplication sharedApplication].keyWindow.rootViewController = vc;
                
                [HXMProgressHUD showError:@"网络出错，请重新加载..." inview: [UIApplication sharedApplication].keyWindow];
            }
        } failure:^(NSError *error) {
            
            //            [HXMProgressHUD hide];
            [HXMProgressHUD showError:@"网络出错，请重新加载..." inview:[UIApplication sharedApplication].keyWindow];
            NSLog(@"获取token %@", error);
        }];
    }
    
}

// 重置用户信息并去登录
- (void)resetUserInfoThenToLoginWithMessage:(NSString *)message showingToast:(BOOL)isShow {
    //清除友盟获取alias
    NSString *companyCode = [AccountTool userInfo].company_code;
    [UMessage removeAlias:companyCode type:kUMessageAliasTypeCompanyCode response:^(id responseObject, NSError *error) {
        NSLog(@"----%@",responseObject);
    }];
    
    if (isShow) {
        [HXMProgressHUD showError:message inview: [UIApplication sharedApplication].keyWindow];

    }
    // 清除用户信息
    [AccountTool deleteUserInfo];
    // 清除coolie
    [AccountTool deleteCookies];
    
    
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        HXMLoginViewController *vc = [[HXMLoginViewController alloc]init];
        [vc.loginMainView resetLogin];
        [UIApplication sharedApplication].keyWindow.rootViewController = vc;

    });
}


@end
