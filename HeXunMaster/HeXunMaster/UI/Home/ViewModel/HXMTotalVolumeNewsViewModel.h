//
//  HXMTotalVolumeNewsViewModel.h
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/7/24.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXMNewsModuleModel.h"

@interface HXMTotalVolumeNewsViewModel : NSObject
@property (nonatomic, strong) RACCommand *requestTotalVolumeNewsCommand;//
@property (nonatomic, strong) NSDictionary *params;
//新闻模型
@property (nonatomic, strong) HXMNewsModuleModel *model;
//新闻列表数组
@property (nonatomic, strong) NSArray *newsListArray;
@end
