//
//  HXMAllCommonModel.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/28.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXMCommonModuleModel.h"

@interface HXMAllCommonModel : NSObject
@property (nonatomic, strong)  NSArray<HXMCommonModuleModel *>*features_module;
@property (nonatomic, strong)  NSArray<HXMCommonModuleModel *>*news_module;
@property (nonatomic, strong)  NSArray<HXMCommonModuleModel *>*intelligence_module;
@end
