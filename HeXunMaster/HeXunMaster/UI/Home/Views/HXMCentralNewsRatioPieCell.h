//
//  HXMCentralNewsRatioPieCell.h
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/4/13.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXMNewsStatisticsCountModel.h"

@interface HXMCentralNewsRatioPieCell : UITableViewCell
@property (nonatomic, strong) HXMNewsStatisticsCountModel *model;
@property (nonatomic, assign) CGFloat totalCount;
@end
