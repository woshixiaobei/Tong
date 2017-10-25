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
    //清除按钮
    self.loginMainView.clearButton.hidden = YES;
    self.loginMainView.phoneNumberTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"你的手机号" attributes:@{NSForegroundColorAttributeName: UIColorFromRGBA(255.0,255.0,255.0,0.3)}];
    
    self.loginMainView.clearCodeButton.hidden = YES;
    self.loginMainView.VerificationCodeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName: UIColorFromRGBA(255.0,255.0,255.0,0.3)}];
    
}

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
