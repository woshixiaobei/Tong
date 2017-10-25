//
//  NSString+date.m
//  TrainingClient
//
//  Created by 蔡建海 on 16/1/8.
//  Copyright © 2016年 HeXun. All rights reserved.
//

#import "NSString+date.h"

@implementation NSString (date)

+ (NSString *)stringFromUnixDate:(long long)unixDate withType:(DateFormatType)type {
    if (!unixDate) {
        return @"";
    }
    
    // current date
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *currentDateComponent = [calendar components:unitFlags fromDate:currentDate];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd HH:mm"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixDate];
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    
    switch (type) {
        case DateFormatOnlyDateString: {
            if ([currentDateComponent year] == [dateComponent year]) {
                if ([currentDateComponent month] == [dateComponent month]) {
                    if ([currentDateComponent day] == [dateComponent day]) {
                        return @"今天";
                    } else if ([currentDateComponent day] - 1 == [dateComponent day]) {
                        return @"昨天";
                    } else {
                        [dateFormat setDateFormat:@"MM-dd"];
                        return [dateFormat stringFromDate:date];
                    }
                } else {
                    [dateFormat setDateFormat:@"MM-dd"];
                    return [dateFormat stringFromDate:date];
                }
            } else {
                [dateFormat setDateFormat:@"MM-dd"];
                return [dateFormat stringFromDate:date];
            }
            break;
        }
        case DateFormatDateTimeStringWithoutSecond:
        {
            if ([currentDateComponent year] == [dateComponent year]) {
                if ([currentDateComponent month] == [dateComponent month]) {
                    if ([currentDateComponent day] == [dateComponent day]) {
                        [dateFormat setDateFormat:@"今天"];
                        return [dateFormat stringFromDate:date];
                    } else if ([currentDateComponent day] - 1 == [dateComponent day]) {
                        [dateFormat setDateFormat:@"昨天"];
                        return [dateFormat stringFromDate:date];
                    } else {
                        return [dateFormat stringFromDate:date];
                    }
                } else {
                    [dateFormat setDateFormat:@"MM-dd"];
                    return [dateFormat stringFromDate:date];
                }
            } else {
                [dateFormat setDateFormat:@"MM-dd"];
                return [dateFormat stringFromDate:date];
            }
            break;
        }
        case DateFormatOnlyDateNumber: {
            [dateFormat setDateFormat:@"MM-dd"];
            return [dateFormat stringFromDate:date];
            break;
        }
        case DateFormatDateTimeString: {
            if ([currentDateComponent year] == [dateComponent year]) {
                if ([currentDateComponent month] == [dateComponent month]) {
                    if ([currentDateComponent day] == [dateComponent day]) {
                        [dateFormat setDateFormat:@"今天 HH:mm"];
                        return [dateFormat stringFromDate:date];
                    } else if ([currentDateComponent day] - 1 == [dateComponent day]) {
                        [dateFormat setDateFormat:@"昨天 HH:mm"];
                        return [dateFormat stringFromDate:date];
                    } else {
                        return [dateFormat stringFromDate:date];
                    }
                } else {
                    [dateFormat setDateFormat:@"MM-dd HH:mm"];
                    return [dateFormat stringFromDate:date];
                }
            } else {
                [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
                return [dateFormat stringFromDate:date];
            }
            break;
        }
        case DateFormatDateTimeNumber: {
            return [dateFormat stringFromDate:date];
            break;
        }
        case DateFormatDateTimeByYear: {
            if ([currentDateComponent year] == [dateComponent year]) {
                if ([currentDateComponent month] == [dateComponent month]) {
                    if ([currentDateComponent day] == [dateComponent day]) {
                        [dateFormat setDateFormat:@"HH:mm:ss"];
                    }else {
                        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        
                    }
                }
            }
            break;
        }
        case DateFormatDateByYear: {
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            return [dateFormat stringFromDate:date];
            break;
        }

        case DateFormatDateTimeWrap: {
            if ([currentDateComponent year] == [dateComponent year]) {
                if ([currentDateComponent month] == [dateComponent month]) {
                    if ([currentDateComponent day] == [dateComponent day]) {
                        [dateFormat setDateFormat:@"今天 \nHH:mm"];
                        return [dateFormat stringFromDate:date];
                    } else if ([currentDateComponent day] - 1 == [dateComponent day]) {
                        [dateFormat setDateFormat:@"昨天 \nHH:mm"];
                        return [dateFormat stringFromDate:date];
                    } else {
                        [dateFormat setDateFormat:@"MM-dd \nHH:mm"];
                        return [dateFormat stringFromDate:date];
                    }
                } else {
                    [dateFormat setDateFormat:@"MM-dd \nHH:mm"];
                    return [dateFormat stringFromDate:date];
                }
            } else {
                [dateFormat setDateFormat:@"MM-dd \nHH:mm"];
                return [dateFormat stringFromDate:date];
            }
            break;
        }
    }
    return @"";
}

+ (NSString *)formatNumber:(NSInteger)number {
    if( number <= 0 ){
        return @"";
    }
    
    double ff = 0.f;
    if( number / 10000 >= 1 ){
        ff = (double)number / 10000;
        if( (ff / 10000) >= 1 ){
            ff = ff / 10000;
            if( ff - (int)ff > 0.1 ){
                return [NSString stringWithFormat:@"%@亿", [self notRounding:ff afterPoint:1]];
            }else{
                return [NSString stringWithFormat:@"%d亿", (int)ff];
            }
        }else{
            
            if( ff - (int)ff > 0.1 ){
                return [NSString stringWithFormat:@"%@万", [self notRounding:ff afterPoint:1]];
            }else{
                return [NSString stringWithFormat:@"%d万", (int)ff];
            }
        }
    }
    
    return [NSString stringWithFormat:@"%ld",number];
}

+ (NSString *)notRounding:(double)value afterPoint:(int)position {
    
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    NSDecimalNumber *ouncesDecimal = [[NSDecimalNumber alloc] initWithDouble:value];
    NSDecimalNumber *roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

@end
