//
//  HXMConstantHeader.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/28.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMConstantHeader.h"

@implementation HXMConstantHeader

NSString * const kBundleShortVersionStringKey = @"CFBundleShortVersionString";

// 无网络连接提示toast
NSString * const kNotNetworkError            = @"网络不可用，请检查您的网络";

// 网络不佳（请求超时）
NSString * const kTimeoutNetworkError        = @"网络不给力";

//注册友盟alias_type
NSString * const kUMessageAliasTypeCompanyCode = @"alias";

@end
