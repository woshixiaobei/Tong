//
//  NSDate+HXMdate.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/4/6.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "NSDate+HXMdate.h"

@implementation NSDate (HXMdate)

/**
 *  是否为今天
 */
- (BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return
    (selfCmps.year == nowCmps.year) &&
    (selfCmps.month == nowCmps.month) &&
    (selfCmps.day == nowCmps.day);
}

/**
 *  是否为昨天
 */
- (BOOL)isYesterday
{
    
    NSDate *nowDate = [[NSDate date] dateWithYMD];
    
    
    NSDate *selfDate = [self dateWithYMD];
    
    // 获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

- (NSDate *)dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}

/**
 *  是否为今年
 */
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year;
}

- (NSDateComponents *)deltaWithNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}

/**
 * 开始到结束的时间差
 */
- (NSString *)difference:(NSDate *)time{
    
    NSTimeInterval start = [self timeIntervalSince1970];
    NSTimeInterval end = [time timeIntervalSince1970];
    NSTimeInterval value = end - start;
    NSLog(@"%f",value);
    int day = (int)value / (24 * 3600);
    if (day != 0) {
        return [NSString stringWithFormat:@"%d天前更新",day];
    }
    
    int house = (int)value / 3600;
    if (house != 0) {
        return [NSString stringWithFormat:@"%d小时前更新",house];
    }
    
    int minute = (int)value/60;
    if (minute!=0) {
        return [NSString stringWithFormat:@"%d分钟前更新",minute];
    }
    
    int second = (int)value %60;//秒
    if (second!=0) {
        return @"刚刚";
    }
    return @"刚刚";
}
@end
