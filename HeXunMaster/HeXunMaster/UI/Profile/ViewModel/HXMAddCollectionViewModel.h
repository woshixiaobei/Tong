//
//  HXMAddCollectionViewModel.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/5/10.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//正文详情页中 -添加到收藏- 视图模型

#import <Foundation/Foundation.h>

@interface HXMAddCollectionViewModel : NSObject
@property (nonatomic, strong, readonly)RACSignal *requestAddSignal;
@property (nonatomic, strong) NSMutableDictionary *params;
@end
