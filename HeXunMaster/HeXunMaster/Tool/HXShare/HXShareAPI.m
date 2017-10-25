//
//  HXShareAPI.m
//  TouGuBackStage
//
//  Created by EasonWang on 16/9/13.
//  Copyright © 2016年 hexun. All rights reserved.
//

#import "HXShareAPI.h"

#if __has_include("UMSocialConfig.h")

#import "UMSocialData.h"
#import "UMSocialControllerService.h"
#import "UMSocialSnsPlatformManager.h"
#if __has_include(<MobClickInOne/MobClick.h>)&&__has_include(<MobClickInOne/DplusMobClick.h>)//dplus兼容
#import <MobClickInOne/MobClick.h>
#import <MobClickInOne/DplusMobClick.h>
#elif __has_include(<UMMobClick/MobClick.h>)
#import <UMMobClick/MobClick.h>
#else
//#import "MobClick.h"
#endif
#import "HXM_Marco.h"
#import "UIView+Toast.h"

#import "UMSocialConfig.h"
#import "WeiboSDK.h"

#endif

@interface HXShareAPI ()
#if __has_include("UMSocialConfig.h")

<UMSocialUIDelegate,WeiboSDKDelegate,UMSocialDataDelegate>
#endif

#if __has_include("UMSocialConfig.h")
@property (nonatomic, copy) void(^resultBlock) (UMSResponseCode code);

#endif
@end

@implementation HXShareAPI

#if __has_include("UMSocialConfig.h")

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)shareResult:(void(^)(UMSResponseCode code))result
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(HXShareDidFinish) name:kHXShareAPIDidFinishGetUMSocialData object:nil];
    
    self.resultBlock = result;
    
    [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionTop];
    
    // 设置点击分享内容Url
    // 朋友圈 微信好友  设置点击分享内容跳转链接
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.shareUrl;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.shareTitle;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.shareUrl;
    
    // 设置qq qqzone 分享跳转链接
    [UMSocialData defaultData].extConfig.qqData.url = self.shareUrl;
    [UMSocialData defaultData].extConfig.qzoneData.url = self.shareUrl;
    // 设置qq qqzone 分享标题
    [UMSocialData defaultData].extConfig.qqData.title = self.shareTitle;
    [UMSocialData defaultData].extConfig.qzoneData.title = self.shareTitle;
    
    // 图片
    if (!self.shareImage || self.shareImage==nil) {
        self.shareImage = [UIImage imageNamed:@"icon60.png"];
    }
    
    // content
    
    
    NSDictionary *dict = nil;
    // 微信好友
    if (self.shareType == HXSharePlatformType_WeChatSeesion) {
        dict = @{@"UID" : [AccountTool userInfo].userid ? : @"", @"CID" : @"wechat"};
        [[UMSocialControllerService defaultControllerService] setShareText:self.shareContent shareImage:self.shareImage socialUIDelegate:self];
        //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession].snsClickHandler(self.preController,[UMSocialControllerService defaultControllerService],YES);
        
    }
    // 朋友圈
    else if (self.shareType == HXSharePlatformType_WeChatTimeline) {
        dict = @{@"UID" : [AccountTool userInfo].userid ? : @"", @"CID" : @"friend"};
        [[UMSocialControllerService defaultControllerService] setShareText:[[self.shareTitle stringByAppendingString:@"\n"] stringByAppendingString:self.shareContent] shareImage:self.shareImage socialUIDelegate:self];
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline].snsClickHandler(self.preController,[UMSocialControllerService defaultControllerService],YES);
        
    } else if (self.shareType == HXSharePlatformType_Sina) {
        dict = @{@"UID" : [AccountTool userInfo].userid ? : @"", @"CID" : @"weibo"};
        self.shareImage = nil;
        [[UMSocialControllerService defaultControllerService] setShareText:[NSString stringWithFormat:@"【%@】%@%@",self.shareTitle, self.shareContent.length<=100?self.shareContent: [self.shareContent substringWithRange:NSMakeRange(0, 100)], self.shareUrl] shareImage:self.shareImage ? self.shareImage : nil socialUIDelegate:self];
        
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(self.preController,[UMSocialControllerService defaultControllerService],YES);
        
        UINavigationController *nav = (UINavigationController *)self.preController.presentedViewController;
        if (nav) {
            [nav.navigationBar setTranslucent:YES];
            [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
            
            __block typeof(&*nav) blockNav = nav;
            @weakify(self)
            [RACObserve(nav.topViewController, navigationItem.title) subscribeNext:^(id x) {
                @strongify(self)
                if ([x isEqualToString:@"微博分享"] || [x isEqualToString:@"微博登录"]) {
                    [self changeTitleColor:blockNav.navigationBar];
                }
            }];
        }
        
    } else if (self.shareType == HXSharePlatformType_QQ) {
        
        dict = @{@"UID" : [AccountTool userInfo].userid ? : @"", @"CID" : @"qq"};
        [[UMSocialControllerService defaultControllerService] setShareText:self.shareContent shareImage:self.shareImage socialUIDelegate:self];
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ].snsClickHandler(self.preController,[UMSocialControllerService defaultControllerService],YES);
    } else if (self.shareType == HXSharePlatformType_QQzone) {
        
        dict = @{@"UID" : [AccountTool userInfo].userid ? : @"", @"CID" : @"qqzone"};
        [[UMSocialControllerService defaultControllerService] setShareText:self.shareContent shareImage:self.shareImage socialUIDelegate:self];
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQzone].snsClickHandler(self.preController,[UMSocialControllerService defaultControllerService],YES);
    }
    
    //友盟统计
    //[MobClick event:self.eventId attributes:dict];
}


- (void)changeTitleColor:(UINavigationBar *)navBar {
    for (UIView *view in navBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UINavigationItemView")]) {
            for (UILabel *titleLabel in view.subviews) {
                [RACObserve(titleLabel, textColor) subscribeNext:^(id x) {
                    if (![x isEqual:[UIColor whiteColor]]) {
                        [titleLabel setTextColor:[UIColor whiteColor]];
                    }
                }];
                [titleLabel setTextColor:[UIColor whiteColor]];
            }
        }
    }
}

//实现回调方法（可选）：
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    
//    if (self.resultBlock) {
//        self.resultBlock(response.responseCode);
//    }
    
    //根据`responseCode`得到发送结果,如果分享成功
    if (response.responseCode == UMSResponseCodeSuccess) {
        [self.preController.view makeToast:@"分享成功" duration:2.0 position:CSToastPositionCenter];
        
    } else {
        [self.preController.view makeToast:@"分享取消" duration:2.0 position:CSToastPositionCenter];
    }
}

- (void)HXShareDidFinish
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    if (self.resultBlock) {
        self.resultBlock(UMSResponseCodeSuccess);
    }
}

#endif

@end
