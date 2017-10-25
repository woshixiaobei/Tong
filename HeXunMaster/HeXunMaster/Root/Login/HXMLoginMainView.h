//
//  HXMLoginMainView.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/13.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXMLoginMainView : UIView

//@property (nonatomic, weak) id<loginVCDelegate> delegate;
//@property (nonatomic, copy) void (^ _Nullable dismissCompletion)();
@property (nonatomic, copy) void(^ successLoginBlock)();
//输入手机号视图
@property (weak, nonatomic) IBOutlet UIView *phoneNumberView;
//输入验证码视图
@property (weak, nonatomic) IBOutlet UIView *VerificationCodeView;
//登录按钮
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
//输入手机号输入框
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
//输入验证码输入框
@property (weak, nonatomic) IBOutlet UITextField *VerificationCodeTextField;
//联系我们
@property (weak, nonatomic) IBOutlet UIButton *contactMeButton;
//获取验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *getVerficationCodeButton;
//清除按钮
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *clearCodeButton;
- (void)resetLogin;
+ (instancetype)shareLoginMainView;

@end
