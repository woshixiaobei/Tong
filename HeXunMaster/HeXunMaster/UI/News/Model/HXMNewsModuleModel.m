//
//  HXMNewsModuleModel.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/4/1.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMNewsModuleModel.h"

@implementation HXMNewsModuleModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"news_types":@"HXMnewsTypeModel",
             @"news":@"HXMDetailNewsCellModel"
             };
    
}
@end
