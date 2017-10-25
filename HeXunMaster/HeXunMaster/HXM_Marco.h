//
//  HXM_Marco.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/9.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *HXAppId;
#ifndef HXM_Marco_h
#define HXM_Marco_h

typedef NS_ENUM(NSInteger, NewsRateByType){
    NewsRateByTypePositiveRate = 0,
    NewsRateByTypeRateVariousMedia = 1,
    NewsRateByTypeSubCompany = 2,
};

typedef NS_ENUM(NSInteger, NewsDetailByNewsType){
    NewsDetailByNewsTypeNormal = 0,//所有普通的进入详情页类型
    NewsDetailByNewsTypeCollection//我的收藏进入详情页类型
};

typedef NS_ENUM(NSInteger, NewsListRequestType){
    NewsListRequestTypeNewsNormalModule = 0,//正常的新闻模块
    NewsListRequestTypeQingBaoModule, //情报模块
    NewsListRequestTypeTotalVolumeModule //全部声量(正负新闻)
};
/**
 *  获取RGB颜色
 */
#define UIColorFromRGBA(colorRed,colorGreen,colorBlue,a)  [UIColor colorWithRed:(colorRed)/255.0 green:(colorGreen)/255.0 blue:(colorBlue)/255.0 alpha:a]


#pragma mark- define
#define kAllModuleFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"allModule.plist"]

#pragma mark - 通知登录
#define NOTIFICATION_LOGOUT_SUCCESS   @"NOTIFICATION_LOGOUT_SUCCESS"
#define NOTIFICATION_LOGOUT_FAILED   @"NOTIFICATION_LOGOUT_FAILED"
#define NOTIFICATION_LOGIN_SUCCESS   @"NOTIFICATION_LOGIN_SUCCESS"


/// 当前系统版本
#define IOS_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define iOS7 (IOS_SYSTEM_VERSION >= 7.0)
#define iOS8OrLater (IOS_SYSTEM_VERSION >= 8.0)

/// 屏幕高度、宽度
#define Screen_height [[UIScreen mainScreen] bounds].size.height
#define Screen_width [[UIScreen mainScreen] bounds].size.width

/// 状态栏宽度、高度
#define StatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
#define StatusBarWidth [UIApplication sharedApplication].statusBarFrame.size.width

/// 导航栏宽度、高度
#define NavigationBarHeight self.navigationController.navigationBar.frame.size.height
#define NavigationBarWidth self.navigationController.navigationBar.frame.size.width

/// 底部菜单宽度、高度
#define TabBarHeight self.tabBarController.tabBar.frame.size.height
#define TabBarWidth self.tabBarController.tabBar.frame.size.width


/**尺寸以及手机类型判断 */
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_5_OR_LESS (SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_6_OR_MORE (SCREEN_MAX_LENGTH >= 667.0)
#define IS_IPHONE_5 (SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6_OR_7   (SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P_OR_7R (SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_6_OR_LESS (SCREEN_MAX_LENGTH <= 667.0)
/// 是否iPad
#define is_Pad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#pragma mark - 打开系统级应用
// 拨打电话
extern void ApplicationOpenTelWithPhoneNumber(NSString*phoneNum);
// 发短信
//extern void ApplicationOpenSMSWithPhoneNumber(NSString*phoneNum);
// 打开应用
extern void ApplicationOpenURLWithString(NSString*string);

/** 根据给定字体计算单位高度 */
extern CGFloat UnitHeightOfFont(UIFont*font);

/** 根据字符串、最大尺寸、字体计算字符串最合适尺寸 */
extern CGSize CGSizeOfString(NSString * text, CGSize maxSize, UIFont * font);
/** 设置视图大小，原点不变 */
extern void SetViewSize(UIView *view, CGSize size);
/** 设置视图宽度，其他不变 */
extern void SetViewSizeWidth(UIView *view, CGFloat width);
/** 设置视图高度，其他不变 */
extern void SetViewSizeHeight(UIView *view, CGFloat height);
/** 设置视图原点，大小不变 */
extern void SetViewOrigin(UIView *view, CGPoint pt);
/** 设置视图原点x坐标，大小不变 */
extern void SetViewOriginX(UIView *view, CGFloat x);
/** 设置视图原点y坐标，大小不变 */
extern void SetViewOriginY(UIView *view, CGFloat y);

extern void setSubviewDelaysContentTouchesNO(UIView * v);

#pragma mark - 可变参数格式化
extern NSString* StringWithFormat(NSString*format,...);

#pragma mark - DEBUG
/** ======================= 调试相关宏定义 ========================== */
/// 添加调试控制台输出
#ifdef DEBUG

#define DDLog(fmt, ...) NSLog((@"%s [Line %d]\n😄 " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define ELog(fmt, ...) NSLog((@"%s [Line %d]\n😥 " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define NSLogRect(...)
#define DDLog(...)
#define ELog(...)
#define NSLog(...)
#define print(...)
#endif
/// 是否输出dealloc log
//#define Dealloc
#ifdef Dealloc
#define DeallocLog(fmt, ...) NSLog((fmt @"dealloc ..."), ##__VA_ARGS__);
#else
#define DeallocLog(...)
#endif

#endif /* HXM_Marco_h */
