//
//  HXMSimilarNewsCell.h
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/3/23.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXMDetailNewsCellModel.h"
#import "HXMFocusNewsCell.h"
//@class HXMSimilarNewsCell;
@class HXMSimilarNewsCell;

@protocol similarListPushToSimilarNewsControllerDelegate <NSObject>

- (void)similarListPushToSimilarNewsViewController:(HXMSimilarNewsCell *)cell news_id:(NSString *)news_id;
@end

@interface HXMSimilarNewsCell : UITableViewCell
@property (nonatomic, assign) id<similarListPushToSimilarNewsControllerDelegate> delegate;

@property (nonatomic, strong) HXMDetailNewsCellModel *model;

@end
