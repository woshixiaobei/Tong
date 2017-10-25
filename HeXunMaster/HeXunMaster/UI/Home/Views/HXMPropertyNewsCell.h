//
//  HXMPropertyNewsCell.h
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/4/14.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXMNewsStatisticsCountModel.h"
@interface HXMPropertyNewsCell : UITableViewCell
//返回数据
@property (nonatomic, strong) NSArray *circleDataArray;
@property (nonatomic, strong) HXMNewsStatisticsCountModel *model;

@end
