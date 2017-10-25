//
//  HXMCompanyResearchModel.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/5/22.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXMDetailNewsCellModel.h"
#import "HXMCompanyChannelModel.h"
@interface HXMCompanyResearchModel : NSObject

//新闻类型
@property (nonatomic, strong) NSArray <HXMCompanyChannelModel *>*report_news_types;
//新闻列表
@property (nonatomic, strong) NSArray<HXMDetailNewsCellModel *> *news;

@end
