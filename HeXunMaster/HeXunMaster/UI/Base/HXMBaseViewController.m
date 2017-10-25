
//
//  HXMBaseViewController.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/8.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMBaseViewController.h"
#if __has_include(<MobClickInOne/MobClick.h>)&&__has_include(<MobClickInOne/DplusMobClick.h>)//dplus兼容
#import <MobClickInOne/MobClick.h>
#import <MobClickInOne/DplusMobClick.h>
#elif __has_include(<UMMobClick/MobClick.h>)
#import <UMMobClick/MobClick.h>
#else
#import "MobClick.h"
#endif
#import "MobClick+HXDataAnalytics.h"

@interface HXMBaseViewController ()

@end

@implementation HXMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    
}

//
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

//
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

//
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

//
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
