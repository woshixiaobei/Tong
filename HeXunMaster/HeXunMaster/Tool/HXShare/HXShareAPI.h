//
//  HXShareAPI.h
//  TouGuBackStage
//
//  Created by EasonWang on 16/9/13.
//  Copyright © 2016年 hexun. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include("UMSocialConfig.h")

#import "UMSocialDataService.h"

#define kHXShareAPIDidFinishGetUMSocialData @"kHXShareAPIDidFinishGetUMSocialData"

typedef NS_ENUM(NSInteger,HXSharePlatformType) {
    HXSharePlatformType_Sina = 20,                   ///< 新浪微博
    HXSharePlatformType_WeChatSeesion,               ///< 微信好友
    HXSharePlatformType_WeChatTimeline,              ///< 微信朋友圈
    HXSharePlatformType_QQ,                          ///< 手机QQ
    HXSharePlatformType_QQzone,                      ///< 手机QQ空间
    HXSharePlatformType_CopyLink,                    ///< 复制链接
};

#endif

@interface HXShareAPI : NSObject

#if __has_include("UMSocialConfig.h")

/// shareTitle
@property(copy ,nonatomic) NSString *shareTitle;
/// shareContent
@property(copy ,nonatomic) NSString *shareContent;
/// shareURL
@property(copy ,nonatomic) NSString *shareUrl;
/// shareImage
@property(strong ,nonatomic) UIImage *shareImage;
/// 分享回调对象
@property (nonatomic, weak) UIViewController *preController;
/// 分享类型
@property (nonatomic, assign) HXSharePlatformType shareType;
/// 统计事件的 eventId
@property (nonatomic, strong) NSString *eventId;


/**
 *	@brief	开始分享，并进行结果回调
 */
- (void)shareResult:(void(^)(UMSResponseCode code))result;

#endif

@end
