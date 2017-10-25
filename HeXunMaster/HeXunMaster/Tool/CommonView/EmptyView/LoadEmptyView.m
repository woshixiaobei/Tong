//
//  LoadEmptyView.m
//  TrainingClient
//
//  Created by 蔡建海 on 16/1/22.
//  Copyright © 2016年 HeXun. All rights reserved.
//

#import "LoadEmptyView.h"
//#import "ConstantHeader.h"
#import <YYCategories/YYCategories.h>

@interface LoadEmptyView ()


@property (nonatomic, strong) UILabel *labelLoading;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, copy) BlockNoArgument reload;

@end

@implementation LoadEmptyView

+ (instancetype)emptyViewWithFrame:(CGRect)frame reloadBlock:(BlockNoArgument)reloadBlock
{
    LoadEmptyView *view = [[self alloc]initWithFrame:frame];
    view.reload = reloadBlock;
    return view;
}

- (void)endLoading
{
    [self.activityIndicator stopAnimating];
    self.labelLoading.hidden = NO;
}

// Tap event
- (void)reloadData
{
    self.labelLoading.hidden = YES;
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
    CGFloat heightGap = 30.0f;
    
//    UIImage *imageFail = [UIImage imageNamed:@"loadFailLogo"];
    UIImage *imageEmpty = [UIImage imageNamed:@"empty_cowlogo_1"];
    
    UIImageView *fail = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, imageEmpty.size.width, imageEmpty.size.height)];
    fail.backgroundColor = [UIColor clearColor];
    fail.image = imageEmpty;
    [self addSubview:fail];
    self.iEmptyView = fail;
    
    UILabel *text1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
    text1.backgroundColor = [UIColor clearColor];
    text1.textAlignment = NSTextAlignmentCenter;
    text1.font = [UIFont systemFontOfSize:14];
    text1.textColor = [UIColor blackColor];
    [self addSubview:text1];
    self.labelDetail = text1;
    
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
    text.backgroundColor = [UIColor clearColor];
    text.textAlignment = NSTextAlignmentCenter;
    text.font = [UIFont systemFontOfSize:14];
//    text.text = @"点击屏幕，重新加载";
    text.textColor = [UIColor colorWithHexString:@"#999999"];
    [self addSubview:text];
    self.labelLoading = text;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0, 0, 20, 20);
    indicator.hidesWhenStopped = YES;
    indicator.backgroundColor = [UIColor clearColor];
    [self addSubview:indicator];
    self.activityIndicator = indicator;
    
    
    CGFloat totalHeight = self.iEmptyView.height + heightGap + text.height + heightGap + text1.height+100;
    
    self.iEmptyView.centerX =self.width/2;
    self.iEmptyView.top = (self.height - totalHeight)/2;
    
    self.labelDetail.centerX = self.iEmptyView.centerX;
    self.labelDetail.top = self.iEmptyView.bottom + heightGap;
    
    self.labelLoading.centerX = self.iEmptyView.centerX;
    self.labelLoading.top = self.labelDetail.bottom + heightGap;
    
    self.activityIndicator.center = self.labelLoading.center;
    
    self.backgroundColor = [UIColor colorWithHexString:@"#c5c5c5"];

}



@end
