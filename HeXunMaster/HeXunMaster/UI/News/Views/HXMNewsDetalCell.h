//
//  HXMNewsDetalCell.h
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/3/21.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXMDetailModel.h"

@interface HXMNewsDetalCell : UITableViewCell

@property (nonatomic, strong) HXMDetailModel *model;
@property (nonatomic, copy) NSString *btnTitle;
@end
