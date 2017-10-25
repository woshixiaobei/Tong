//
//  HXMobClick.h
//  HXMobClickTest
//
//  Created by EasonWang on 16/2/16.
//  Copyright © 2016年 EasonWang. All rights reserved.
//
//  Version : 2.3
//  Build   : 2.3.1

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>



@interface HXDataAnalytics : NSObject


#pragma mark basics


///-----------------------------------------------------------------------------------
/// @name  设置
///-----------------------------------------------------------------------------------

/** 设置是否打印sdk的log信息, 默认NO(不打印log).
 @param value 设置为YES,HXDataAnalytics SDK 会输出log信息可供调试参考. 除非特殊需要，否则发布产品时需改回NO.
 @return void.
 */
+ (void)setLogEnabled:(BOOL)value;



///-----------------------------------------------------------------------------------
/// @name  开启统计
///-----------------------------------------------------------------------------------

/**
 *	@brief	初始化和讯统计SDK
 *
 *	@param 	appID 	产品人员定义的产品唯一编号
 *	@param 	cid 	应用下载渠道名称,为nil或@""时,默认为@"App Store"渠道
 */
+ (void)startWithAppID:(NSString*)appID channelId:(NSString*)cid;



///-----------------------------------------------------------------------------------
/// @name  页面统计
///-----------------------------------------------------------------------------------

/**
 *  @brief  页面统计, 开始统计某个页面.【注：SDK2.0以上版本支持】
 *
 *  使用方法：必须配对调用beginLogPageView:和endLogPageView:两个函数来完成页面统计，若只调用某一个函数不会生成有效数据。
 *  在该页面展示时调用beginLogPageView:，当退出该页面时调用endLogPageView:
 *  @param pageName 统计的页面名称.
 *  @return void.
 */
+ (void)beginLogPageView:(NSString *)pageName;

/**
 *  @brief  页面统计, 结束统计某个页面.【注：SDK2.0以上版本支持】
 *
 *  使用方法：必须配对调用beginLogPageView:和endLogPageView:两个函数来完成页面统计，若只调用某一个函数不会生成有效数据。
 *  在该页面展示时调用beginLogPageView:，当退出该页面时调用endLogPageView:
 *  @param pageName 统计的页面名称.
 *  @return void.
 */
+ (void)endLogPageView:(NSString *)pageName;



///-----------------------------------------------------------------------------------
/// @name  用户登录/退出
///-----------------------------------------------------------------------------------

/**
 *	@brief	用户登录后调用此接口来记录当前用户的行为信息
 *
 *	@param 	userId 	和讯网用户唯一id
 */
+ (void)loginCompleteWithUserId:(NSString*)userId;

/**
 *	@brief	用户退出后调用此接口
 */
+ (void)logoutComplete;



///-----------------------------------------------------------------------------------
/// @name  webURL 、 apiURL 统计
///-----------------------------------------------------------------------------------

/**
 *	@brief	统计打开的 web 地址【注：SDK2.0以上版本支持】
 *
 *	@param 	webURL 	web地址
 */
+ (void)openWeb:(NSString*)webURL;

/**
 *	@brief	统计api接口【注：SDK2.0以上版本支持】
 *
 *	@param 	url 	api接口
 */
+ (void)apiURL:(NSString*)url;



///-----------------------------------------------------------------------------------
/// @name  事件统计
///-----------------------------------------------------------------------------------

/**
 *	@brief	自定义事件统计【注：SDK2.0以上版本支持】
 *
 *	@param 	eventId 	事件id
 */
+ (void)event:(NSString *)eventId;

/**
 *	@brief  自定义事件统计【注：SDK2.0以上版本支持】
 *
 *  此方法使用说明，请参考友盟统计的同名方法。
 *
 *	@param 	eventId 	事件id
 *	@param 	attributes  当前事件的属性和取值（键值对），不能为空。
 */
+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes;



@end
