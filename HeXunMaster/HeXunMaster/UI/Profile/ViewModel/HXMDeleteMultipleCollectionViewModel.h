//
//  HXMDeleteMultipleCollectionViewModel.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/5/10.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
// 收藏列表编辑状态 -移除单个多个- cell

#import <Foundation/Foundation.h>

@interface HXMDeleteMultipleCollectionViewModel : NSObject
@property (nonatomic, strong, readonly)RACSignal *requestDeleMutipleSignal;
@property (nonatomic, strong) NSMutableDictionary *params;
@end
