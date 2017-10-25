//
//  HXMProblemFeedbackViewController.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/4/28.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMProblemFeedbackViewController.h"
#import "UIAlertController+HXAlertViewController.h"
#import "HXMFeedBackView.h"
#import "HXHttpHelper+HXMaster.h"
#import "HXHttpHelper.h"
#import "AccountTool.h"
#import <UIKit/UIViewController.h>
@interface HXMProblemFeedbackViewController ()
@property (nonatomic, weak)HXMFeedBackView *feedBackView;
@end

@implementation HXMProblemFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//提交反馈
- (void)commitWithContent:(NSString *) content {
    
    NSString *userMobile = [AccountTool userInfo].username;
    @weakify(self)
    [HXMProgressHUD showInView:self.view];
    [HXHttpHelper api_getTextFeedbackActionRequestWithUserMobile:userMobile content:content success:^(id responseObject) {
        
        @strongify(self)
        if ([responseObject[@"state"] integerValue] == 0) {
            [HXMProgressHUD hide];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"您的问题反馈已成功提交" preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *settingAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                self.feedBackView.contentTextView.text = @"";
                [self.feedBackView.contentTextView resignFirstResponder];
            }];
            [alertController addAction:settingAction];
            [self presentViewController:alertController animated:YES completion:nil];

        }
    } failure:^(NSError *error) {
        @strongify(self)
        [HXMProgressHUD hide];
        [HXMProgressHUD showError:@"网络出错，请重新提交.." inview:self.view];
    }];
}

//点击打电话响应
- (void)selectedBtn:(UIButton *)button {
    
    NSString *defaultPhoneNumber = @"010-85650934";

    NSString *phoneNumber = [AccountTool userInfo].hoteline?:defaultPhoneNumber;
     [UIAlertController alertWithTitle:nil handleVC:self WithMessage:@"是否要拨打责编电话" withSettingBtnName:@"是" withDefaultBtnName:@"否"phoneNumber:phoneNumber];
}


#pragma mark - 设置界面
- (void)setupUI {
    
    self.view.backgroundColor  = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"问题反馈";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:19.0], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor ]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:([UIColor colorWithHexString:@"#3c5c8e"]) size:CGSizeMake(Screen_width, Screen_height)] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"feedback_phone_icon"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(selectedBtn:)];
    
    HXMFeedBackView * feedBackView = [[HXMFeedBackView alloc] init];
    [self.view addSubview:feedBackView];
    [feedBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(564);
    }];
    [feedBackView setButtonClicked:^(NSString * str){
        [self commitWithContent:str];
        
    }];
    self.feedBackView = feedBackView;
}

@end
