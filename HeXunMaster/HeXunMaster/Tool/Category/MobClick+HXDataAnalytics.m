//
//  MobClick+HXDataAnalytics.m
//  TrainingClient
//
//  Created by EasonWang on 16/8/18.
//  Copyright © 2016年 HeXun. All rights reserved.
//

#import "MobClick+HXDataAnalytics.h"
#import <objc/runtime.h>
#import <HXDataAnalytics/HXDataAnalytics.h>


@implementation MobClick (HXDataAnalytics)

+ (void)swizzledClassMethodWithOriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector
{
    Method originalMethod = class_getClassMethod(self, originalSelector);
    Method swizzledMethod = class_getClassMethod(self, swizzledSelector);
    
    class_addMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

+ (void)hook
{
    [self swizzledClassMethodWithOriginalSelector:@selector(beginLogPageView:) swizzledSelector:@selector(hxda_beginLogPageView:)];
    [self swizzledClassMethodWithOriginalSelector:@selector(endLogPageView:) swizzledSelector:@selector(hxda_endLogPageView:)];
    [self swizzledClassMethodWithOriginalSelector:@selector(event:) swizzledSelector:@selector(hxda_event:)];
    [self swizzledClassMethodWithOriginalSelector:@selector(event:attributes:) swizzledSelector:@selector(hxda_event:attributes:)];
}

/// 页面进入
+ (void)hxda_beginLogPageView:(NSString *)pageName
{
    [HXDataAnalytics beginLogPageView:pageName];
    [self hxda_beginLogPageView:pageName];
}
/// 页面离开
+ (void)hxda_endLogPageView:(NSString *)pageName
{
    [HXDataAnalytics endLogPageView:pageName];
    [self hxda_endLogPageView:pageName];
}
/// 事件统计
+ (void)hxda_event:(NSString *)eventId;
{
    [HXDataAnalytics event:eventId];
    [self hxda_event:eventId];
}
/// 事件属性统计
+ (void)hxda_event:(NSString *)eventId attributes:(NSDictionary *)attributes
{
    [HXDataAnalytics event:eventId attributes:attributes];
    [self hxda_event:eventId attributes:attributes];
}

@end
