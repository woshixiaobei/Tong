//
//  HXMCommonInfoModel.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/24.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMCommonInfoModel.h"

@implementation HXMCommonInfoModel

+ (instancetype)moneyModelWithColor:(UIColor *)color percent:(CGFloat)percent title:(NSString *)title
{
    return [HXMCommonInfoModel initModelWithColor:color percent:percent title:title];
}

+ (instancetype)initModelWithColor:(UIColor *)color percent:(CGFloat)percent title:(NSString *)title
{
    HXMCommonInfoModel *model = [[self alloc] init];
    if (model) {
        [model setModelWithColor:color percent:percent title:title];
    }
    
    return model;
}

- (void)setModelWithColor:(UIColor *)color percent:(CGFloat)percent title:(NSString *)title
{
    _pStokeColor = color;
    _nPercent = percent;
    _pTitle = title;
}

@end
