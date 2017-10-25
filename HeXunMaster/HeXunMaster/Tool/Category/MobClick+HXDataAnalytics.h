//
//  MobClick+HXDataAnalytics.h
//  TrainingClient
//
//  Created by EasonWang on 16/8/18.
//  Copyright © 2016年 HeXun. All rights reserved.
//

//兼容 统计新老版本
#if __has_include(<MobClickInOne/MobClick.h>)&&__has_include(<MobClickInOne/DplusMobClick.h>)//dplus兼容
#import <MobClickInOne/MobClick.h>
#import <MobClickInOne/DplusMobClick.h>
#elif __has_include(<UMMobClick/MobClick.h>)
#import <UMMobClick/MobClick.h>
#else
#import "MobClick.h"
#endif

@interface MobClick (HXDataAnalytics)

+ (void)hook;

@end
