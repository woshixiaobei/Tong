//
//  HXMLoginViewController.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/13.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMLoginViewController.h"
#import "HXMLoginMainView.h"
#import "HXMUser.h"
#import "AccountTool.h"
#import "HXMMainViewController.h"

@interface HXMLoginViewController ()

@end

@implementation HXMLoginViewController


- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideClearButton) name:UITextFieldTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showClearButton) name:UITextFieldTextDidEndEditingNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [self.loginMainView endEditing:YES];
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
    [self.loginMainView endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 通知方法
- (void)hideClearButton {
    
    if ([self.loginMainView.phoneNumberTextField isFirstResponder] && self.loginMainView.phoneNumberTextField.text.length > 0) {
        self.loginMainView.clearButton.hidden = NO;
    } else if ([self.loginMainView.VerificationCodeTextField isFirstResponder] && self.loginMainView.VerificationCodeTextField.text.length > 0) {
        self.loginMainView.clearCodeButton.hidden = NO;
    }
}

- (void)showClearButton {
    
    self.loginMainView.clearButton.hidden = YES;
    self.loginMainView.phoneNumberTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"你的手机号" attributes:@{NSForegroundColorAttributeName: UIColorFromRGBA(255.0,255.0,255.0,0.3)}];
    
    self.loginMainView.clearCodeButton.hidden = YES;
    self.loginMainView.VerificationCodeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName: UIColorFromRGBA(255.0,255.0,255.0,0.3)}];
    
    
}

//- (void)loginWithToken {
//    
//    @weakify(self)
//    HXMUser *user = [AccountTool userInfo];
//    NSString *token = user.token;
//    if (token.isNotBlank) {
//        // hud
//        [HXMProgressHUD showInView:self.view];
//        [HXHttpHelper api_postSendVerficationCodeToGetTokenWithUsername:user.username withAccessToken:token success:^(id responseObject) {
//            @strongify(self)
//            // hide hud
//            [HXMProgressHUD hide];
//            if ([responseObject[@"state"] integerValue] == 0) {
//                if ([responseObject[@"data"][@"result"] integerValue] == 0) { // 获取token成功且有效
//                    // 跳转首页
//                    NSLog(@"%@",user.token);
//                    HXMMainViewController *mainViewController = [HXMMainViewController new];
//                    [self presentViewController:mainViewController animated:YES completion:nil];
//                } else if ([responseObject[@"data"][@"result"] integerValue] == 1) { // 获取token错误
//                    [HXMProgressHUD showError:@"账号已登录其它设备，请重新登录" inview:self.view];
//                    [self.loginMainView resetLogin];
//                    
//                } else if ([responseObject[@"data"][@"result"] integerValue] == 2) { // 获取token无效
//                    [HXMProgressHUD showError:@"获取token失效" inview:self.view];
//                    [self.loginMainView resetLogin];
//                }
//            } else {
//                // 其他state情况
//                [self setupUI];
//                [HXMProgressHUD showError:@"网络出错，请重新加载..." inview:self.view];
//            }
//        } failure:^(NSError *error) {
//            // hide hud
//            [HXMProgressHUD hide];
//            [HXMProgressHUD showError:@"网络出错，请重新加载..." inview:self.view];
//            NSLog(@"获取token %@", error);
//        }];
//    }
////    }
//}
#pragma mark - setupUI
- (void)setupUI {
    
    self.loginMainView = [HXMLoginMainView shareLoginMainView];
    [self.view addSubview:self.loginMainView];
    [self.loginMainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self.loginMainView endEditing:YES];
}

@end
