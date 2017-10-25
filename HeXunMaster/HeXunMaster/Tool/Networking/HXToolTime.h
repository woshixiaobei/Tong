//
//  HXToolTime.h
//  TouGuBackStage
//
//  Created by 蔡建海 on 16/11/17.
//  Copyright © 2016年 hexun. All rights reserved.
//

#import <Foundation/Foundation.h>


// 时间工具类
@interface HXToolTime : NSObject

/**
 格式说明
 
 G: 公元时代，例如AD公元
 yy: 年的后2位
 yyyy: 完整年
 MM: 月，显示为1-12
 MMM: 月，显示为英文月份简写,如 Jan
 MMMM: 月，显示为英文月份全称，如 Janualy
 dd: 日，2位数表示，如02
 d: 日，1-2位显示，如 2
 EEE: 简写星期几，如Sun
 EEEE: 全写星期几，如Sunday
 aa: 上下午，AM/PM
 H: 时，24小时制，0-23
 K：时，12小时制，0-11
 m: 分，1-2位
 mm: 分，2位
 s: 秒，1-2位
 ss: 秒，2位
 S: 毫秒
 
 */


// serverTime 为标准时间戳
+ (NSString *)dateStringWithServerTime:(double)serverTime;

// serverTime 为标准时间戳
+ (NSString *)dateStringWithServerTime:(double)serverTime withForm:(NSString *)form;

//
+ (NSTimeInterval)secondsWithDateString:(NSString *)dataString;

// 字符串类型
+ (NSTimeInterval)secondsWithDateString:(NSString *)dateString withForm:(NSString *)form;

// 获取 当前0 时区的日期  serverTime 为标准时间戳
+ (NSDate *)dateWithSeconds:(double)serverTime;


// 获取 星期    serverTime 为标准时间戳
+ (NSString *)weekDayWithSeconds:(double)serverTime;

//获取当前时间的字符串
+ (NSString *)getcurrentDateString:(NSString *)format;

@end
