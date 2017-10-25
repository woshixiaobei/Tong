//
//  HXMOpinionAnalysisChartView.h
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/7/18.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXMNewsStatisticsCountModel.h"

@interface HXMOpinionAnalysisChartView : UIView
@property (nonatomic, strong) NSMutableDictionary *dataList;
@property (nonatomic, strong) HXMNewsStatisticsCountModel *analysisChartModel;//返回数据模型
@end
