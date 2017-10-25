//
//  HXToolTime.m
//  TouGuBackStage
//
//  Created by 蔡建海 on 16/11/17.
//  Copyright © 2016年 hexun. All rights reserved.
//

#import "HXToolTime.h"

@implementation HXToolTime

// serverTime 为标准时间戳
+ (NSString *)dateStringWithServerTime:(double)serverTime
{
    return [self dateStringWithServerTime:serverTime withForm:@"yyyy-MM-dd HH:mm:ss"];
}

//
+ (NSString *)dateStringWithServerTime:(double)serverTime withForm:(NSString *)form
{
    // date 是0时区的时间
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:serverTime];
    
    // 系统会默认转化为东八区时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:form];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

// serverTime 为标准时间戳
+ (NSTimeInterval)secondsWithDateString:(NSString *)dateString withForm:(NSString *)form
{
    //系统会认为字符串是东八区的时间, 转乘NSDate是零时区的
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //另中文（真机）环境下也能正常转换
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:form];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    //    //将转换回来的对象手动加上8小时，回到北京时间
    //    NSDate *date2 = [date dateByAddingTimeInterval:8 * 60 * 60];
    //    // 添加默认系统时差 为当前时间
    //    NSTimeInterval interVal = [[NSTimeZone defaultTimeZone] secondsFromGMTForDate:[NSDate date]];
    //    NSDate *date3 = [date dateByAddingTimeInterval:interVal];
    
    
    return [date timeIntervalSince1970];
}

//
+ (NSTimeInterval)secondsWithDateString:(NSString *)dataString
{
    return [self secondsWithDateString:dataString withForm:@"yyyy-MM-dd HH:mm:ss"];
}

// 获取 当前0时区的日期  serverTime 为标准时间戳
+ (NSDate *)dateWithSeconds:(double)serverTime
{
    return [NSDate dateWithTimeIntervalSince1970:serverTime];
}

// 获取 星期    serverTime 为标准时间戳
+ (NSString *)weekDayWithSeconds:(double)serverTime
{
    NSDate *date = [self dateWithSeconds:serverTime];
    
    NSUInteger weekDay = [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date] weekday];
    NSString *strWeek = @"周一";
    if (weekDay == 1) {
        strWeek = @"周日";
    }else if (weekDay == 2)
    {
        strWeek = @"周一";
    }else if (weekDay == 3)
    {
        strWeek = @"周二";
    }else if (weekDay == 4)
    {
        strWeek = @"周三";
    }else if (weekDay == 5)
    {
        strWeek = @"周四";
    }else if (weekDay == 6)
    {
        strWeek = @"周五";
    }else if (weekDay == 7)
    {
        strWeek = @"周六";
    }
    return strWeek;
}

////获取当前时间日期字符串
+ (NSString *)getcurrentDateString:(NSString *)format {
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

@end
