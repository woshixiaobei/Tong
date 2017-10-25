//
//  NSString+date.h
//  TrainingClient
//
//  Created by 蔡建海 on 16/1/8.
//  Copyright © 2016年 HeXun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DateFormatType) {
    DateFormatOnlyDateString = 1,   // eg: 今天 
    DateFormatOnlyDateNumber,       // eg: 01-08
    DateFormatDateTimeString,        // eg: 今天 12:12
    DateFormatDateTimeStringWithoutSecond,        // eg: 今天 12
    DateFormatDateTimeNumber,       // eg: 01-08 12:12
    DateFormatDateTimeByYear,       // eg: 2016-01-08 12:12:12
    DateFormatDateByYear,           // eg: 2016-01-08
    DateFormatDateTimeWrap          // eg: 日期和时间之间换行显示
};

@interface NSString (date)

/**
 *  Create a string from the unix date by type.
 *
 *  @param unixDate unix date
 *
 *  @return A new string create from the date farmat
 */

+ (NSString *)stringFromUnixDate:(long long)unixDate withType:(DateFormatType)type;


/**
 *  格式化数字
 *
 *  @param number <#number description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)formatNumber:(NSInteger)number;

@end
