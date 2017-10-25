//
//  HXMCommonModuleCell.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/23.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXMNewsStatisticsCountModel.h"
#import "HXMCommonModuleModel.h"

@interface HXMCommonModuleCell : UITableViewCell
@property (nonatomic, strong) HXMNewsStatisticsCountModel *model;

@property (nonatomic, strong) HXMCommonModuleModel *selectedModel;
@property (nonatomic, copy) void(^selectedItemBlock)(NSIndexPath *indexPath);
@property (nonatomic, strong) NSArray *allModuleArray;
@end
