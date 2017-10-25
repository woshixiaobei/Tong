//
//  HXServerTime.m
//  TouGuBackStage
//
//  Created by 蔡建海 on 16/11/16.
//  Copyright © 2016年 hexun. All rights reserved.
//

#import "HXServerTime.h"

@interface HXServerTime()

// 最后一次设置的时间
@property (nonatomic, assign) double lastTime;

// 最后一次设置时 系统启动的时间
@property (nonatomic, assign) double startTime;

@end

@implementation HXServerTime
singleton_m(HXServerTime);

- (double)serverTime
{
    // 取不到服务器时间，取本地时间
    if (self.lastTime == 0) {
        return [[NSDate date] timeIntervalSinceReferenceDate];
    }
    
    double currentTime = [[NSProcessInfo processInfo] systemUptime];
    return self.lastTime + ( currentTime - self.startTime );
}

//
- (void)setServerTime:(double)serverTime
{
    self.lastTime = serverTime;
    self.startTime = [[NSProcessInfo processInfo] systemUptime];
}



@end
