//
//  HXMCompanyModuleNewsModel.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/22.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXMDetailNewsCellModel.h"

@interface HXMCompanyModuleNewsModel : NSObject

@property (nonatomic, assign) NSInteger module;
//
@property (nonatomic, strong) NSArray <HXMDetailNewsCellModel *>*news;

@end
