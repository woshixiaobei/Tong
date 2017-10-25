//
//  HXMNewsModuleModel.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/4/1.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXMnewsTypeModel.h"
#import "HXMDetailNewsCellModel.h"

@interface HXMNewsModuleModel : NSObject

//
@property (nonatomic, strong) NSArray <HXMnewsTypeModel *>*news_types;
//
@property (nonatomic, strong) NSArray<HXMDetailNewsCellModel *> *news;

@property (nonatomic, copy) NSString *next_id;
@end
