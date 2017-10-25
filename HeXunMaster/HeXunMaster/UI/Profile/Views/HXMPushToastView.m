//
//  HXMPushToastView.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/5/18.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMPushToastView.h"
#import "HXMAlertView.h"
#import "NSString+HXMAdd.h"
#import "HXMNewsDetailVC.h"
#import "HXNavigationViewController.h"
#import "UMessage.h"
#import "AppDelegate.h"
#import "HXMMainViewController.h"

#define laterCheckButtonTag 100
@interface HXMPushToastView()
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *backgroundView;
@property (nonatomic, weak) UIButton * nowCheckButton;
@property (nonatomic, strong) UIView *parentview;
@end
@implementation HXMPushToastView
- (instancetype)init
{
    self = [super init];
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds])  {
        
        self.backgroundColor = [UIColor clearColor];
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.backgroundColor = [UIColor blackColor];
        [self addSubview:_backgroundView];
        [self setupUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        _backgroundView.backgroundColor = [UIColor blackColor];
        [self addSubview:_backgroundView];
        [self setupUI];
    }
    return self;
}

#pragma mark - 按钮点击事件
- (void)checkInformationClick:(UIButton *)button {
    
    [UMessage sendClickReportForRemoteNotification:self.userInfo];
    NSString *moduleId = [self.userInfo objectForKey:@"module_id"];
    NSString *messageType = [self.userInfo objectForKey:@"message_type"];
    NSString *newsId = [self.userInfo objectForKey:@"news_id"];
    NSString *newsTitle = [self.userInfo objectForKey:@"news_title"];
    if (button.tag == laterCheckButtonTag) {
        
        [self hide];
    } else if (button.tag == laterCheckButtonTag + 1) {
        
        [self hide];
        //跳转相应的控制器
        HXMNewsDetailVC *vc = [[HXMNewsDetailVC alloc]init];
        vc.module_id = moduleId;
        vc.newsId =newsId;
        vc.newsIsPush = YES;
        //如果是登录页，跳转回详情页
        UIViewController *rootController = [UIApplication sharedApplication].delegate.window.rootViewController;
        
        if ([rootController isKindOfClass:[HXMMainViewController class]]) {
        
            UITabBarController *tabBar = (UITabBarController*)[UIApplication sharedApplication].delegate.window.rootViewController;
            HXNavigationViewController *navi = tabBar.selectedViewController;
            [navi.rt_topViewController.navigationController pushViewController:vc animated:YES];
            
        }
    }
}

#pragma mark -初始化界面
- (void)setupUI {
    
    self.parentview = [[UIView alloc] init];
    self.parentview.backgroundColor = [UIColor whiteColor];
    self.parentview.layer.cornerRadius = 10;
    [self addSubview:self.parentview];
//        parentview.layer.masksToBounds = YES;
    //    parentview.userInteractionEnabled = YES;
    
    [self.parentview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH - 120.f);
        make.height.mas_equalTo(196.5f);
        
    }];
    
    UIImageView * headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 80, 90)];
    UIImage *image = [UIImage imageNamed:@"headerAlertView_icon"];
    headerImageView.image = image;
    headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    headerImageView.layer.masksToBounds = YES;
    [self.parentview addSubview:headerImageView];
    [headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.parentview).offset(-20);
        make.left.right.equalTo(self.parentview);
        make.height.mas_equalTo(90);
    }];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"这个是标题这个是标题这个是标题这个是标题这个是标题这个是标题这个是标题这个是标题这个是标题这个是标题";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.numberOfLines = 3;
    [self.parentview addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerImageView.mas_bottom).offset(26);
        make.left.equalTo(self.parentview).offset(15);
        make.right.equalTo(self.parentview).offset(-15);
    }];
    
    self.titleLabel = titleLabel;
    
    UILabel * message = [[UILabel alloc] init];
    message.text = @"文中可能涉及公司敏感信息";
    message.textColor = [UIColor lightGrayColor];
    message.font = [UIFont systemFontOfSize:12];
    message.numberOfLines = 0;
    [self.parentview addSubview:message];
    [message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(14);
        make.left.equalTo(self.parentview).offset(30);
        make.right.equalTo(self.parentview).offset(-15);
    }];
    UIImageView * tipImageView = [[UIImageView alloc] init];
    UIImage *image1 = [UIImage imageNamed:@"sensitiveWarning_icon"];
    tipImageView.image = image1;
    [self.parentview addSubview:tipImageView];
    [tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(message);
        make.left.equalTo(self.parentview).offset(15);
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
    [self.parentview addSubview:laterCheckButton];
    
    [laterCheckButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(message.mas_bottom).offset(26);
        make.left.equalTo(self.parentview).offset(14);
        make.bottom.equalTo(self.parentview).offset(-11);
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
    [self.parentview addSubview:nowCheckButton];
    self.nowCheckButton = nowCheckButton;
    
    [nowCheckButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(laterCheckButton);
        make.left.equalTo(laterCheckButton.mas_right).offset(8);
        make.right.equalTo(self.parentview).offset(-14);
        make.height.equalTo(laterCheckButton);
        make.width.equalTo(laterCheckButton);
    }];
    
    CGFloat height = [titleLabel.text textHeightWithWidth:SCREEN_WIDTH - 120.0f Font:titleLabel.font] + [message.text textHeightWithWidth:SCREEN_WIDTH - 80.0f - 45.0f Font:[UIFont systemFontOfSize:12.0f]];
    NSLog(@"%f,%f",titleLabel.frame.size.height,message.frame.size.height);
    
    [self.parentview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.centerX.equalTo(self);
        make.width.mas_equalTo(SCREEN_WIDTH - 120.0f);
        make.height.mas_equalTo(height + 133 + 50);
    }];
}

#pragma mark - 展示动画
//展示
- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    NSArray *windowViews = [window subviews];
    if(windowViews && [windowViews count] > 0){
        UIView *subView = [windowViews objectAtIndex:[windowViews count]-1];
        for(UIView *aSubView in subView.subviews)
        {
            [aSubView.layer removeAllAnimations];
        }
        [subView addSubview:self];
        [self showBackground];
        [self showAlertAnimation];
    }
}
//隐藏
- (void)hide {
    _contentView.hidden = YES;
    [self hideAlertAnimation];
    [self removeFromSuperview];
}

- (void)showBackground {
    _backgroundView.alpha = 0;
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.35];
    _backgroundView.alpha = 0.6;
    [UIView commitAnimations];
}

-(void)showAlertAnimation {
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.30;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.contentView.layer addAnimation:animation forKey:nil];
}

- (void)hideAlertAnimation {
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView setAnimationDuration:0.35];
    _backgroundView.alpha = 0.0;
    [UIView commitAnimations];
}
@end
