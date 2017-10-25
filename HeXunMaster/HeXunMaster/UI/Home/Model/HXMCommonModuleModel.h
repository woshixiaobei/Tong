//
//  HXMCommonModuleModel.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/22.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HXMCommonModuleModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *module_id;//模块id
@property (nonatomic, copy) NSString *app_module_logo;//模块logo
@property (nonatomic, copy) NSString *module_name;//模块名称
@property (nonatomic, assign) NSInteger module_tag;// 模型标识

@end
