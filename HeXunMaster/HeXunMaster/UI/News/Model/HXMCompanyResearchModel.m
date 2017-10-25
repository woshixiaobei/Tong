//
//  HXMCompanyResearchModel.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/5/22.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMCompanyResearchModel.h"

@implementation HXMCompanyResearchModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"report_news_types":@"HXMCompanyChannelModel",
             @"news":@"HXMDetailNewsCellModel"
             };
}

@end
