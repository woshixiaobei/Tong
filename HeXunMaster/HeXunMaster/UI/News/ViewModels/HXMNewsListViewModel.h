//
//  HXMNewsListViewModel.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/31.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HXMNewsModuleModel;

@interface HXMNewsListViewModel : NSObject
// 请求首页命令
@property (nonatomic, strong, readonly) RACSignal *requestNewsListSignal;
//请求参数
@property (nonatomic, strong)  NSMutableDictionary *params;
//分类id
@property (nonatomic, copy) NSString *typeId;
//新闻列表数组
@property (nonatomic, strong) NSArray *newsListArray;
//新闻模型
@property (nonatomic, strong) HXMNewsModuleModel *model;
@end
