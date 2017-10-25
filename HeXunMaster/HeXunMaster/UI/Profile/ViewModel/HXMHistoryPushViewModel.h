//
//  HXMHistoryPushViewModel.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/5/9.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXMHistoryPushViewModel : NSObject
@property (nonatomic, strong, readonly)RACSignal *requestHistoryPushSignal;
@property (nonatomic, strong) NSMutableDictionary *params;

@end
