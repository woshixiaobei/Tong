//
//  HXMHomeListModel.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/22.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXMNewsStatisticsCountModel.h"
#import "HXMCompanyModuleNewsModel.h"

@interface HXMHomeListModel : NSObject

//统计新闻数量模型
@property (nonatomic, strong) HXMNewsStatisticsCountModel *statData;
//公司要闻新闻
@property (nonatomic, strong) HXMCompanyModuleNewsModel *companyModuleNews;
//社会热点新闻
@property (nonatomic, strong) HXMCompanyModuleNewsModel *societyModuleNews;
//同行要闻新闻
@property (nonatomic, strong) HXMCompanyModuleNewsModel *sameIndustryModuleNews;
//行业要闻新闻
@property (nonatomic, strong) HXMCompanyModuleNewsModel *industryModuleNews;

@end
