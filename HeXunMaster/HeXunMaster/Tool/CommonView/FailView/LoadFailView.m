//
//  LoadFailView.m
//  TrainingClient
//
//  Created by 李帅 on 15/12/31.
//  Copyright © 2015年 HeXun. All rights reserved.
//

#import "LoadFailView.h"
#import <YYCategories/YYCategories.h>
//#import "macro.h"

@interface LoadFailView ()

@end

@implementation LoadFailView

+ (instancetype)failViewWithFrame:(CGRect)frame reloadBlock:(BlockNoArgument)reloadBlock
{
    LoadFailView *view =  [[self alloc]initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    view.reload = reloadBlock;
    return view;
}

- (void)endLoading
{
    [self.activityIndicator stopAnimating];
    self.labelFail.hidden = NO;
}

// Tap event
- (void)reloadData
{
    self.labelFail.hidden = YES;
    [self.activityIndicator startAnimating];
    self.reload();
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self drawMainUI];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadData)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

//
- (void)drawMainUI
{
    CGFloat heightGap = 40.0f;
    
    UIImage *imageFail = [UIImage imageNamed:@"HXM_noWifi_icon"];
    
    UIImageView *fail = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageFail.size.width, imageFail.size.height)];
    fail.backgroundColor = [UIColor clearColor];
    fail.image = imageFail;
    [self addSubview:fail];
    self.iFailView = fail;
    
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 20)];
    text.backgroundColor = [UIColor clearColor];
    text.textAlignment = NSTextAlignmentCenter;
    text.font = [UIFont systemFontOfSize:14.0f];
    text.text = @"网络不给力，点击屏幕重试";
    text.textColor = [UIColor colorWithHexString:@"#999999"];
    [self addSubview:text];
    self.labelFail = text;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0, 0, 50, 50);
    indicator.hidesWhenStopped = YES;
    indicator.backgroundColor = [UIColor clearColor];
    [self addSubview:indicator];
    self.activityIndicator = indicator;
    
    
    CGFloat totalHeight = self.iFailView.height + text.height + heightGap+100;
    
    self.iFailView.centerX =self.width/2;
    self.iFailView.top = (self.height - totalHeight)/2;
    
    self.labelFail.centerX = self.iFailView.centerX;
    self.labelFail.top = self.iFailView.bottom + heightGap;
    
    self.activityIndicator.center = self.labelFail.center;
}


@end

