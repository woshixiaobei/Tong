//
//  HXMCompanyResearchReportViewModel.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/5/22.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXMCompanyResearchReportViewModel : NSObject

@property (nonatomic, strong, readonly) RACSignal *requestCompanyResearchSignal;

@property (nonatomic, strong)  NSMutableDictionary *params;
@end
