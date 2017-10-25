//
//  HXMPushToastViewController.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/5/5.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMPushToastViewController.h"
#import "HXMAlertView.h"
#import "NSString+HXMAdd.h"
#import "HXMNewsDetailVC.h"

#define laterCheckButtonTag 100
@interface HXMPushToastViewController ()
@property (nonatomic, strong)HXMAlertView *alertView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *messageLabel;
@end

@implementation HXMPushToastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)checkInformationClick:(UIButton *)button {
    
    if (button.tag == laterCheckButtonTag) {
        
         [self.alertView hide];
    } else if (button.tag == laterCheckButtonTag + 1) {
        //跳转相应的控制器
        HXMNewsDetailVC *vc = [[HXMNewsDetailVC alloc]init];
        [self.navigationController pushViewController:vc animated:NO];
    }
}
- (void)alertView:(HXMAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"------%ld", (long)buttonIndex);
}


- (void)setAlertType:(alertViewStyleType)alertType {

    switch (alertType) {
        case alertViewStyleTypeNeedOpenPush:
            
            break;
        case alertViewStyleTypeCheckInformation:
            
            break;
            
        default:
            break;
    }

}

- (void)setupUI {
    
    self.alertView= [[HXMAlertView alloc] init];
    UIView * parentview = [[UIView alloc] init];
    parentview.backgroundColor = [UIColor whiteColor];
    parentview.layer.cornerRadius = 10;
    self.alertView.contentView =parentview;
    [parentview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.alertView);
        make.width.mas_equalTo(SCREEN_WIDTH - 200.0f);
        make.height.mas_equalTo(196.5f);
        
    }];
    
    UIImageView * headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 80, 90)];
    UIImage *image = [UIImage imageNamed:@"headerAlertView_icon"];
    headerImageView.image = image;
    headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [parentview addSubview:headerImageView];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(parentview).offset(-20);
        make.left.right.equalTo(parentview);
        make.height.mas_equalTo(90);
    }];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"这个是标题这个是标题这个是标题这个是标题这个是标题这个是标题这个是标题这个是标题这个是标题这个是标题";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.numberOfLines = 0;
    [parentview addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerImageView.mas_bottom).offset(26);
        make.left.equalTo(parentview).offset(15);
        make.right.equalTo(parentview).offset(-15);
    }];
    self.titleLabel = titleLabel;
    
    UILabel *message = [[UILabel alloc] init];
    message.text = @"文中可能涉及公司敏感信息";
    message.textColor = [UIColor lightGrayColor];
    message.font = [UIFont systemFontOfSize:12];
    message.numberOfLines = 0;
    [parentview addSubview:message];
    [message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(14);
        make.left.equalTo(parentview).offset(30);
        make.right.equalTo(parentview).offset(-15);
    }];
    self.messageLabel = message;
    
    UIImageView * tipImageView = [[UIImageView alloc] init];
    UIImage *image1 = [UIImage imageNamed:@"sensitiveWarning_icon"];
    tipImageView.image = image1;
    [parentview addSubview:tipImageView];
    [tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(message);
        make.left.equalTo(parentview).offset(15);
        make.width.height.mas_equalTo(12);
        
    }];
    
    UIButton * laterCheckButton = [[UIButton alloc] init];
    laterCheckButton.layer.cornerRadius = 18;
    laterCheckButton.tag = laterCheckButtonTag;
    laterCheckButton.backgroundColor = [UIColor colorWithHexString:@"#3c5c8c"];
    laterCheckButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [laterCheckButton setTitle:@"稍后查看" forState:UIControlStateNormal];
    [laterCheckButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [laterCheckButton addTarget:self action:@selector(checkInformationClick:) forControlEvents:UIControlEventTouchUpInside];
    [parentview addSubview:laterCheckButton];
    [laterCheckButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(message.mas_bottom).offset(26);
        make.left.equalTo(parentview).offset(14);
        //make.bottom.equalTo(parentview).offset(-11);
        make.height.mas_equalTo(36);
    }];
    
    UIButton * nowCheckButton = [[UIButton alloc] init];
    nowCheckButton.layer.cornerRadius = 18;
    nowCheckButton.tag = laterCheckButtonTag + 1;
    nowCheckButton.backgroundColor = [UIColor colorWithHexString:@"#3c5c8c"];
    nowCheckButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [nowCheckButton setTitle:@"现在查看" forState:UIControlStateNormal];
    [nowCheckButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [nowCheckButton addTarget:self action:@selector(checkInformationClick:) forControlEvents:UIControlEventTouchUpInside];
    [parentview addSubview:nowCheckButton];
    
    [nowCheckButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(laterCheckButton);
        make.left.equalTo(laterCheckButton.mas_right).offset(8);
        make.right.equalTo(parentview).offset(-14);
        make.height.equalTo(laterCheckButton);
        make.width.equalTo(laterCheckButton);
    }];
    
    CGFloat height = [titleLabel.text textHeightWithWidth:SCREEN_WIDTH - 110.0f Font:titleLabel.font] + [message.text textHeightWithWidth:SCREEN_WIDTH - 80.0f - 45.0f Font:[UIFont systemFontOfSize:12.0f]];
    NSLog(@"%f,%f",titleLabel.frame.size.height,message.frame.size.height);
    
    [parentview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self.alertView);
        make.width.mas_equalTo(SCREEN_WIDTH - 80.0f);
        make.height.mas_equalTo(height + 133 + 50);
    }];
    [self.alertView show];

}

- (void)setupAlertView {

    //
    //    alert= [[HXMAlertView alloc] init];
    //
    //    UIView * parentview = [[UIView alloc] init];
    //    parentview.backgroundColor = [UIColor whiteColor];
    //    parentview.layer.cornerRadius = 10;
    //    alert.contentView =parentview;
    //    [parentview mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.centerX.equalTo(alert);
    //        make.width.mas_equalTo(SCREEN_WIDTH - 80.0f);
    //        make.height.mas_equalTo(196.5f);
    //
    //    }];
    //
    //
    //    UIImageView * imageView = [[UIImageView alloc] init];
    //    UIImage *image = [UIImage imageNamed:@"pushToast_icon"];
    //    imageView.image = image;
    //    [parentview addSubview:imageView];
    //    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerX.equalTo(parentview);
    //        make.top.equalTo(parentview).offset(-52.5);
    //        make.height.mas_equalTo(114);
    //        make.width.mas_equalTo(126);
    //    }];
    //
    //    UILabel * title = [[UILabel alloc] init];
    //    title.text = @"这个是的标题";
    //    title.textColor = [UIColor blackColor];
    //    title.font = [UIFont systemFontOfSize:17];
    //    title.textAlignment = NSTextAlignmentCenter;
    //    title.numberOfLines = 0;
    //    [parentview addSubview:title];
    //    [title mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.right.equalTo(parentview);
    //        make.top.equalTo(imageView.mas_bottom).offset(14);
    //    }];
    //
    //
    //    UILabel * message = [[UILabel alloc] init];
    //    message.text = @"这个是内容";
    //    message.textColor = [UIColor lightGrayColor];
    //    message.font = [UIFont systemFontOfSize:15];
    //    message.textAlignment = NSTextAlignmentCenter;
    //    [parentview addSubview:message];
    //    [message mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.right.equalTo(parentview);
    //        make.top.equalTo(title.mas_bottom).offset(14);
    //    }];
    //
    //    UIButton * cancle = [[UIButton alloc] init];
    //    [cancle setTitle:@"不用打开" forState:UIControlStateNormal];
    //    [cancle setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //    cancle.titleLabel.contentMode = UIViewContentModeCenter;
    //    [cancle addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    //    [parentview addSubview:cancle];
    //    [cancle mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(message.mas_bottom).offset(14);
    //        make.left.equalTo(parentview);
    //        make.bottom.equalTo(parentview);
    //        make.width.mas_equalTo((SCREEN_WIDTH - 80.0f)/2);
    //        make.height.mas_equalTo(42);
    //
    //    }];
    //    UIButton * sureBtn = [[UIButton alloc] init];
    //    [sureBtn setTitle:@"确定打开" forState:UIControlStateNormal];
    //    [sureBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //    sureBtn.titleLabel.contentMode = UIViewContentModeCenter;
    //    [sureBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    //    [parentview addSubview:sureBtn];
    //    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(cancle);
    //        make.left.equalTo(cancle.mas_right);
    //        make.right.equalTo(parentview);
    //        make.width.equalTo(cancle);
    //        make.height.equalTo(cancle);
    //
    //    }];
    //
    //    UIView * line1 = [[UIView alloc] init];
    //    line1.backgroundColor = [UIColor blueColor];
    //    [parentview addSubview:line1];
    //    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(cancle.mas_top);
    //        make.left.right.equalTo(parentview);
    //        make.height.mas_equalTo(1);
    //    }];
    //    UIView * line2 = [[UIView alloc] init];
    //    line2.backgroundColor = [UIColor blueColor];
    //    [parentview addSubview:line2];
    //    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.centerX.equalTo(parentview);
    //        make.width.mas_equalTo(1);
    //        make.height.mas_equalTo(42);
    //    }];
    //       [alert show];
    //

}
@end
