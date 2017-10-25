//
//  HXMConstantHeader.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/28.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXMConstantHeader : NSObject

extern NSString * const kBundleShortVersionStringKey;
/** 无网络连接提示文字 */
extern NSString * const kNotNetworkError;
/** 网络超时提示文字 */
extern NSString * const kTimeoutNetworkError;

//注册友盟alias_type
extern NSString * const kUMessageAliasTypeCompanyCode;

//无网
#define kNetworkNotReachability ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus<=0)

/** 友盟Appkey */
#define kUMAppKey @"591a5ffa9f06fd78db002408"
/** 微信Appid */
#define kWechatAppId @"wx376e5f1928831631"
/** 微信Appkey */
#define kWechatAppKey @"a5877e9113f53676fe81d79f71af5d21"
/** QQAppid */
#define kQQAppId @"1106113516"
/** QQAppkey */
#define kQQAppKey @"bLSCQdj5tw5Iu3fI"
/** sinaAppid */
#define kSinaAppKey @"225119467"
/** sinaAppkey */
#define kSinaAppSecret @"46b25cdc6f2a9432d00a57f4b039e772"

#define kWeiboRedirect @"http://sns.whalecloud.com/sina2/callback"

/** 动画时间 */
#define kAnimationDurationTime 0.25
/** 输入框高度 */
#define kInputBoxHeight 49.0f
@end
