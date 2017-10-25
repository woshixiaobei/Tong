//
//  NSDate+HXMdate.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/4/6.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HXMdate)
/**
 *  是否为今天
 */
- (BOOL)isToday;
/**
 *  是否为昨天
 */
- (BOOL)isYesterday;
/**
 *  是否为今年
 */
- (BOOL)isThisYear;

/**
 *  返回一个只有年月日的时间
 */
- (NSDate *)dateWithYMD;

/**
 *  获得与当前时间的差距
 */
- (NSDateComponents *)deltaWithNow;

/**
 * 开始到结束的时间差
 */
- (NSString *)difference:(NSDate *)time;
@end
