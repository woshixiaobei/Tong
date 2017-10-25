//
//  HXMFocusNewsCell.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/15.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//公司要闻列表cell

#import <UIKit/UIKit.h>
#import "HXMDetailNewsCellModel.h"
@class HXMFocusNewsCell;

@protocol pushToSimilarNewsControllerDelegate <NSObject>

- (void)pushToSimilarNewsCell:(HXMFocusNewsCell *)cell news_id:(NSString *)news_id;

@end

@interface HXMFocusNewsCell : UITableViewCell
@property (nonatomic, assign) id<pushToSimilarNewsControllerDelegate> delegate;
@property (nonatomic, strong) HXMDetailNewsCellModel *model;
@property (nonatomic, copy) NSString *btnTitle;
@property (nonatomic, copy) NSString *module_id;
//@property (nonatomic, copy) void(^selectedItemBlock)(NSString *module_id , NSString *news_id);
@property (nonatomic, assign) BOOL isInformationNews;//是否是情报新闻
@property (weak, nonatomic) IBOutlet UIButton *similarNewsButton;
//收藏
@property (weak, nonatomic) IBOutlet UIButton *collectionButton;
@property (nonatomic, assign) BOOL isCollection;//判断是否收藏
@end
