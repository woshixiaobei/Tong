//
//  HXMLoginMainView.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/13.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMLoginMainView.h"
#import <Masonry.h>
#import "HXM_phoneCodeTool.h"
#import "UIAlertController+HXAlertViewController.h"
#import "HXMMainViewController.h"
#import "HXMUser.h"
#import "AccountTool.h"
#import "UMessage.h"
#import "HXMRemoveAliasManage.h"

@interface HXMLoginMainView()<UITextFieldDelegate>

//logo图标
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property(nonatomic, assign) NSInteger currentCountDown;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation HXMLoginMainView

+ (instancetype)shareLoginMainView {
    
    UINib *nib = [UINib nibWithNibName:@"HXMLoginMainView" bundle:nil];
    return [nib instantiateWithOwner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
    
    @weakify(self)
    [self setSuccessLoginBlock:^{
        @strongify(self)
        UIViewController *old = self.window.rootViewController;
        Class cls = NSClassFromString(@"HXMMainViewController");
        UIViewController *vc = [cls new];
        self.window.rootViewController = vc;
        
        old = nil;
    }];
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

#pragma mark -
- (void)setupUI {
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_backgroundColor"]];
    self.phoneNumberTextField.textColor = self.VerificationCodeTextField.textColor = [UIColor whiteColor];//文本颜色
    self.phoneNumberTextField.tintColor = self.VerificationCodeTextField.tintColor = [UIColor colorWithHexString:@"#ffffff"] ;//光标
    self.phoneNumberTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"你的手机号" attributes:@{NSForegroundColorAttributeName: UIColorFromRGBA(255.0,255.0,255.0,0.3)}];
    self.VerificationCodeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName: UIColorFromRGBA(255.0,255.0,255.0,0.3)}];
    
    [self.getVerficationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.getVerficationCodeButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateNormal];
    [self.getVerficationCodeButton setTitleColor:[UIColor colorWithHexString:@"#58d2ff"] forState:UIControlStateDisabled];

    self.getVerficationCodeButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    
    if (IS_IPHONE_5) {
        self.phoneNumberTextField.font = [UIFont systemFontOfSize:13];
        [self.phoneNumberTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.phoneNumberView).offset(48);
            make.centerY.equalTo(self.phoneNumberView);
//            make.width.mas_equalTo(300);
//            make.top.equalTo(self.phoneNumberView).offset(20);
//            make.height.mas_equalTo(20);
        }];
        self.VerificationCodeTextField.font = [UIFont systemFontOfSize:13];
        [self.VerificationCodeTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.VerificationCodeView).offset(48);
            make.centerY.equalTo(self.VerificationCodeView);
//            make.width.mas_equalTo(100);
//            make.top.equalTo(self.VerificationCodeView).offset(20);
//            make.height.mas_equalTo(20);
            
        }];
        self.getVerficationCodeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        
    }
    [self.clearButton addTarget:self action:@selector(clearEditText:) forControlEvents:UIControlEventTouchUpInside];
    [self.clearCodeButton addTarget:self action:@selector(clearEditText:) forControlEvents:UIControlEventTouchUpInside];
    self.clearButton.hidden = self.clearCodeButton.hidden = YES;
    self.phoneNumberTextField.delegate = self;
    self.VerificationCodeTextField.delegate = self;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideClearButton) name:UITextFieldTextDidBeginEditingNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showClearButton) name:UITextFieldTextDidEndEditingNotification object:nil];
    ///
    [self init_racSignal];
    [self.phoneNumberTextField becomeFirstResponder];
}

#pragma mark - 通知方法
- (void)hideClearButton {

    if ([self.phoneNumberTextField isFirstResponder] && self.phoneNumberTextField.text.length > 0) {
        self.clearButton.hidden = NO;
    } else if ([self.VerificationCodeTextField isFirstResponder] && self.VerificationCodeTextField.text.length > 0) {
        self.clearCodeButton.hidden = NO;
    }
}

- (void)showClearButton {
    
    self.clearButton.hidden = YES;
    self.phoneNumberTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"你的手机号" attributes:@{NSForegroundColorAttributeName: UIColorFromRGBA(255.0,255.0,255.0,0.3)}];
    
    self.clearCodeButton.hidden = YES;
    self.VerificationCodeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName: UIColorFromRGBA(255.0,255.0,255.0,0.3)}];
    
    
}
//监听UITextField输入框，清除按钮的状态
-(void)init_racSignal{
    
    @weakify(self);
    RAC(self.clearButton, hidden) = [self.phoneNumberTextField.rac_textSignal map:^id(NSString * value) {
        @strongify(self)
        return ((value.length > 0) ? [NSNumber numberWithBool:NO] : [NSNumber numberWithBool:YES]);
    }];
    
    RAC(self.clearCodeButton, hidden) = [self.VerificationCodeTextField.rac_textSignal map:^id(NSString * value) {
        @strongify(self)
        return ((value.length > 0) ? [NSNumber numberWithBool:NO] : [NSNumber numberWithBool:YES]);
    }];
 
}

#pragma mark - UIButton
//清空按钮事件
- (IBAction)clearEditText:(UIButton *)sender {
    if (sender.tag == 100 && self.phoneNumberTextField.text.length) {
        self.phoneNumberTextField.text  = nil;
        [self.phoneNumberTextField endEditing:YES];
        [self.phoneNumberTextField becomeFirstResponder];
    } else if (sender.tag == 200 && self.VerificationCodeTextField.text.length) {
        self.VerificationCodeTextField.text = nil;
        [self.VerificationCodeTextField endEditing:YES];
        [self.VerificationCodeTextField becomeFirstResponder];
    }
    
}

//获取验证码事件
- (IBAction)getVerficationCodeClick:(UIButton *)sender {
    [self.phoneNumberTextField resignFirstResponder];
    if ((!self.phoneNumberTextField.text||self.phoneNumberTextField.text.length == 0)) {
        [self showMessageWithTitle:nil
                           message:@"手机号不能为空\n请填写正确的手机号"
                   leftButtonTitle:@"确定"
                            others:nil];
        
    } else if (![self isMobileNumber:self.phoneNumberTextField.text]) {
        
        [self showMessageWithTitle:nil
                           message:@"您输入的手机号码错误\n请重新输入"
                   leftButtonTitle:@"确定"
                            others:nil];

    } else {
        //监听网络状态
        //        [self checkLink];
        if (![AFNetworkReachabilityManager sharedManager].reachable) {
            [HXMProgressHUD showError:@"网络连接错误" inview:self];
            return;
        }
        NSLog(@"get code button click");

        sender.enabled = NO;
        [self.getVerficationCodeButton setTitle:@"获取验证码" forState:UIControlStateDisabled];

        //发送给服务器信息
        [HXMProgressHUD showInView:self];
        @weakify(self)
        [HXHttpHelper api_postSendMobileCodeToGetNumber:self.phoneNumberTextField.text success:^(id responseObject) {
            
            [HXMProgressHUD hide];
            @strongify(self)
            NSInteger responseCode = [responseObject[@"data"][@"result"] integerValue];
            if (responseCode == 0) {
                [HXMProgressHUD showSuccess:@"已发送验证码" inview:self];
                [self startCount];
                [self.VerificationCodeTextField becomeFirstResponder];
                
            } else if (responseCode == 1) {
                [self showMessageWithTitle:nil
                                   message:@"手机号不能为空\n请填写正确的手机号"
                           leftButtonTitle:@"确定"
                                    others:nil];
                self.getVerficationCodeButton.enabled = YES;
                
            } else if (responseCode == 2) {
                [self showMessageWithTitle:nil
                                   message:@"您输入的手机号码错误\n请重新输入"
                           leftButtonTitle:@"确定"
                                    others:nil];
                self.getVerficationCodeButton.enabled = YES;
                
            } else if (responseCode == 3) {
                [self showMessageWithTitle:nil
                                   message:@"您输入的手机号码没有登录权限"
                           leftButtonTitle:@"确定"
                                    others:nil];
                self.getVerficationCodeButton.enabled = YES;
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [HXMProgressHUD hide];
            [HXMProgressHUD showError:@"获取验证码失败，请重新获取..." inview:self];
            self.getVerficationCodeButton.enabled = YES;
            [self.getVerficationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        }];
    }
    
}
//获取登录事件
- (IBAction)loginClick:(UIButton *)sender {
    
    [self.VerificationCodeTextField resignFirstResponder];
    if (!self.phoneNumberTextField.text || self.phoneNumberTextField.text.length == 0) {
        [self showMessageWithTitle:nil
                           message:@"手机号不能为空\n请填写正确的手机号"
                   leftButtonTitle:@"确定"
                            others:nil];
    }else if (![self isMobileNumber:self.phoneNumberTextField.text]) {
        
        [self showMessageWithTitle:nil
                           message:@"您输入的手机号码错误\n请重新输入"
                   leftButtonTitle:@"确定"
                            others:nil];
        
    }else if (!self.VerificationCodeTextField.text||self.VerificationCodeTextField.text.length == 0) {
        [self showMessageWithTitle:nil
                           message:@"验证码不能为空\n请重新输入"
                   leftButtonTitle:@"确定"
                            others:nil];
    } else {
        
        //监听网络状态
        if (![AFNetworkReachabilityManager sharedManager].reachable) {
            [HXMProgressHUD showError:@"网络连接错误" inview:self];
            return;
        }
        
        @weakify(self)
        if (self.phoneNumberTextField.text && self.VerificationCodeTextField.text) {
            [HXMProgressHUD showInView:self];
            [HXHttpHelper api_postSendVerficationCodeToGetLogin:self.phoneNumberTextField.text withVerficationCode:self.VerificationCodeTextField.text success:^(id responseObject) {
                @strongify(self)
                [HXMProgressHUD hide];
                NSInteger responseCode = [responseObject[@"data"][@"result"] integerValue];
                if (responseCode == 0) {
                    sender.enabled = NO;
                    [self.phoneNumberTextField resignFirstResponder];
                    [self.VerificationCodeTextField resignFirstResponder];
                    //调取获取token的接口，保存token
                    HXMUser *user = [HXMUser mj_objectWithKeyValues:responseObject[@"data"]];
                    [AccountTool save:user];
                    
                    //移除之前的alias并添加alias
                    [[HXMRemoveAliasManage shareManage] removeAliasThenAddAliasIsSuccess:^(BOOL isSuccess, NSError *error) {
                        if (isSuccess) {
                            
                            NSLog(@"removeAliasTypes 移除成功 ");
                        }
                        else{
                            NSLog(@"removeAliasTypes 移除失败 ");
                        }
                    }];

                    if (self.successLoginBlock) {
                        self.successLoginBlock();
                    }
                    
                } else if (responseCode == 1) {
                    
                    [self showMessageWithTitle:nil
                                       message:@"验证码不能为空\n请重新获取验证码"
                               leftButtonTitle:@"确定"
                                        others:nil];
                    
                } else if (responseCode == 2) {
                    
                    [self showMessageWithTitle:nil
                                       message:@"您输入的验证码错误\n请重新输入"
                               leftButtonTitle:@"确定"
                                        others:nil];
                    //清除验证码
                    self.VerificationCodeTextField.text = @"";
                    
                } else if (responseCode == 3) {
                    
                    [self showMessageWithTitle:nil
                                       message:@"您输入的验证码失效\n请重新获取验证码"
                               leftButtonTitle:@"确定"
                                        others:nil];
                    //清除验证码
                    self.VerificationCodeTextField.text = @"";
                }
                
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
                [HXMProgressHUD showError:@"获取数据失败，请重新加载..." inview:self];
            }];
        }
    }
    
}
//联系我们
- (IBAction)contactMeClick:(id)sender {
    
    NSString *phoneNumber = @"010-85650934";
    [UIAlertController alertWithTitle:nil handleVC:self.viewController WithMessage:[NSString stringWithFormat:@"是否拨打电话%@\n联系我们",phoneNumber] withSettingBtnName:@"是" withDefaultBtnName:@"否"phoneNumber:phoneNumber];
}


////添加alias之前先删除alias
//- (void) removeAliasTypesBeforeAddAlias {
//    
//    //注册友盟获取alias, 手机不接收通知,alias = 0;
//    NSString *aliasTypeString = [AccountTool userInfo].aliasType;
//    NSString *companyCode = [AccountTool userInfo].company_code;
//    if (aliasTypeString.isNotBlank) {
//        //                        if (![aliasTypeString isEqualToString:@"0"])
//        //添加alias之前，还得先去掉alias
//        if ([aliasTypeString isEqualToString:@"1"]) {//移除2，可能循环
//            [self removeAliasWithTypeString:@"2"];
//            
//        } else if ([aliasTypeString isEqualToString:@"2"]) {//移除1，循环
//            [self removeAliasWithTypeString:@"1"];
//            
//        } else if ([aliasTypeString isEqualToString:@"0"]) {//移除1&&2，可能循环
//            //两个线程
//            dispatch_queue_t aDQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//            dispatch_group_t group = dispatch_group_create();
//            //移除1 && 2
//            dispatch_group_async(group, aDQueue, ^{
//                [self removeAliasWithTypeString:@"1"];
//            });
//            dispatch_group_async(group, aDQueue, ^{
//                [self removeAliasWithTypeString:@"2"];
//            });
//            
//        }
//        [UMessage addAlias:companyCode type:aliasTypeString response:^(id responseObject, NSError *error) {
//            NSLog(@"----------------------%@",responseObject);
//        }];
//    }
//    
//}

////移除aliastype类型参数
//- (void)removeAliasWithTypeString :(NSString *)typeString {
//    
//    NSString *companyCode = [AccountTool userInfo].company_code;
//    if (typeString.isNotBlank) {
//        [UMessage removeAlias:companyCode type:typeString response:^(id responseObject, NSError *error) {
//            
//            if (error) {
//                NSLog(@"----%@,%@",responseObject,error);
//                [self removeAliasWithTypeString:typeString];
//            }
//        }];
//    }
//}

#pragma mark - 倒计时
- (void)startCount
{
    NSLog(@"startCount ------");
    /**
     *  添加定时器
     */
    self.currentCountDown = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

- (void)countDown{

    if (self.currentCountDown >0) {
        //设置界面的按钮显示
        self.getVerficationCodeButton.enabled = NO;
        [self.getVerficationCodeButton setTitle:[NSString stringWithFormat:@"%ld秒后获取",(long)self.currentCountDown] forState:UIControlStateDisabled];
        self.currentCountDown--;

    }else{
        self.getVerficationCodeButton.enabled = YES;
        [self removeTimer];
    }
}

/**
 *  移除定时器
 */
- (void)removeTimer
{
    self.currentCountDown = 0;
    [self.timer invalidate];
    self.timer = nil;
}
#pragma mark - 判断手机号
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    return mobileNum.length == 11?YES:NO;
    //return [HXM_phoneCodeTool valiMobile:mobileNum];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

#pragma mark -
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSLog(@"%@, string = %@",textField.text, string);
    if (range.length + range.location > textField.text.length) {
        return NO;
    }
    
    NSUInteger newLength = textField.text.length + string.length - range.length;
    
    if (self.phoneNumberTextField == textField) {
        
        return newLength <= 11;
    } else if (self.VerificationCodeTextField == textField) {
        return newLength <= 6;
    }
    return [self validateNumber:string];
}

- (void)showMessageWithTitle:(NSString *) title message:(NSString *) message leftButtonTitle:(NSString *) leftTitle others:(NSString *) others {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:leftTitle otherButtonTitles:others, nil];
    [alert show];
    
}

- (void)resetLogin {
    self.phoneNumberTextField.text = [AccountTool userInfo].username;
    
}

@end
