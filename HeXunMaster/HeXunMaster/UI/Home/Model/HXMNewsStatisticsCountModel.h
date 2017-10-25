//
//  HXMNewsStatisticsCountModel.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/23.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXMCommonModuleModel.h"
#import "HXMSubCompanyModel.h"

@interface HXMNewsStatisticsCountModel : NSObject

@property (nonatomic, strong) NSArray<NSArray *> *circleArrayM;
@property (nonatomic, strong) NSArray *positiveCircleArrayM;
//公司名称
@property (nonatomic, copy) NSString *company_name;
//公司logo地址
@property (nonatomic, copy) NSString *company_logo;
//公司编号
@property (nonatomic, copy) NSString *company_code;

//-------------------新闻总声量-----------------------
//新闻总声量
@property (nonatomic, assign) NSInteger totle_num;
//负面新闻总声量
@property (nonatomic, assign) NSInteger negative_num;
//正面新闻总声量
@property (nonatomic, assign) NSInteger positive_num;


//-------------------今日总声量---------------------
//今日正面总声量
@property (nonatomic, assign) NSInteger today_positive_num;
//今日负面总声量
@property (nonatomic, assign) NSInteger today_negative_num;
//今日中性总声量
@property (nonatomic, assign) NSInteger today_neutral_num;

//今日总量统计
@property (nonatomic, assign) CGFloat sumPositive;

//今日总声量
@property (nonatomic, assign) NSInteger today_totle_num;
//预警新闻数量
@property (nonatomic, assign) NSInteger today_sens_num;
//今日预警级别（非常低）
@property (nonatomic, copy) NSString *today_sens_level;

@property (nonatomic, assign) NSInteger today_sens_tag;
//--------------------省级、中央级占比-------------------------
//中央级
@property (nonatomic, assign) NSInteger centre_num;
//省级
@property (nonatomic, assign) NSInteger province_num;
//其他
@property (nonatomic, assign) NSInteger other_num;

@property (nonatomic, assign) CGFloat sumProvinceNum;
//-------------------非集团公司新闻渠道占比图---------------

//微信新闻量
@property (nonatomic, assign) NSInteger weixin_num;
//公司新闻量
@property (nonatomic, assign) NSInteger media_num;
//微博新闻量
@property (nonatomic, assign) NSInteger weibo_num;
//社区新闻量
@property (nonatomic, assign) NSInteger club_num;

@property (nonatomic, assign) CGFloat sumChannel;
//常用模块
@property (nonatomic, strong) NSArray<HXMCommonModuleModel *> *common_module;
//集团公司的时候才会有分子公司数据，分子公司新闻占比图(集团公司时显示)
@property (nonatomic, strong) NSArray<HXMSubCompanyModel *> *sub_company;


@end
