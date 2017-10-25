
//
//  TableViewHeader.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/8.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "HXMNewsStatisticsCountModel.h"

@interface TableViewHeader : UIView

@property (nonatomic, strong) HXMNewsStatisticsCountModel *model;
@property (nonatomic, weak) UILabel *refreshLabel;//刷新显示的标签
- (void)loadingViewAnimateWithScrollViewContentOffset:(CGFloat)offset;
- (void)refreshingAnimateBegin;
- (void)refreshingAnimateStop;

@end
