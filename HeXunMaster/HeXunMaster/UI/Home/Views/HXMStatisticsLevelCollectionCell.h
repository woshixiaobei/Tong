//
//  HXMStatisticsLevelCollectionCell.h
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/3/20.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXMCommonModuleModel.h"

@interface HXMStatisticsLevelCollectionCell : UICollectionViewCell
@property (nonatomic, strong) HXMCommonModuleModel *model;
@property (nonatomic, strong) UIImageView *appIcon;//功能图标
@property (nonatomic, strong) UILabel *titlleLabel;//功能名称

@end
