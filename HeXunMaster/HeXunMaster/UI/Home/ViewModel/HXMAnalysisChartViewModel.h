//
//  HXMAnalysisChartViewModel.h
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/7/20.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXMAnalysisChartViewModel : NSObject

@property (nonatomic, strong) RACCommand *requestAnalysisChartNewsCommand;//
@property (nonatomic, strong) NSDictionary *params;

@end
