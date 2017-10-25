//
//  HXMStatisticsCountCell.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/15.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXMNewsStatisticsCountModel.h"

typedef void(^clickViewBlock)(NSInteger tag);
@interface HXMStatisticsCountCell : UITableViewCell

@property (nonatomic, strong) HXMNewsStatisticsCountModel *model;
@property (nonatomic, copy) clickViewBlock clickSeparateView;
@end
