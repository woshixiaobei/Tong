//
//  HXMCancleCollectionNewsDetailViewModel.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/6/1.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//正文详情页中 -取消收藏- 视图模型

#import <Foundation/Foundation.h>

@interface HXMCancleCollectionNewsDetailViewModel : NSObject

@property (nonatomic, strong, readonly)RACSignal *cancleCollectionNewsSignal;
@property (nonatomic, strong) NSMutableDictionary *params;

@end
