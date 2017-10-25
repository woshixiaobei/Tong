//
//  HXMStatisticsCountCell.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/15.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMStatisticsCountCell.h"
#import "HXMHistoryPushViewController.h"
#import "HXMNewsViewController.h"
#import "HXMTotalVolumeNewsViewController.h"
#import "HXMOpinonAnalysisChartViewController.h"

#define KtapLeftViewTag 1000
typedef enum : NSUInteger {
    todayWarningVeryLowLevel = 1,
    todayWarningLowLevel,
    todayWarningMiddleLevel,
    todayWarningHighLevel,
    todayWarningVeryHighLevel,
    
} TodayWarningLevel;

@interface HXMStatisticsCountCell()
@property (weak, nonatomic) IBOutlet UILabel *todayTotalNewsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayNegativeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayLevelDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *warnCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightBGImageView;

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;

@end

@implementation HXMStatisticsCountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.height = 122;
    UITapGestureRecognizer *leftViewtapGecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
     UITapGestureRecognizer *rightViewtapGecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [self.leftView addGestureRecognizer:leftViewtapGecognizer];
    [self.rightView addGestureRecognizer:rightViewtapGecognizer];
}

- (void)tapClick:(UITapGestureRecognizer *)gesture {

    UIView *tapView = gesture.view;
    if (self.clickSeparateView != nil) {
        self.clickSeparateView(tapView.tag);
    }   
}

- (void)setModel:(HXMNewsStatisticsCountModel *)model {
    
    _model = model;
    self.todayTotalNewsCountLabel.text = [NSString stringWithFormat:@"%ld",model.today_totle_num>0?model.today_totle_num:0] ;
    self.todayNegativeCountLabel.text = [NSString stringWithFormat:@"当前负面新闻%ld篇",(model.today_negative_num>0) ? model.today_negative_num : 0];
    self.todayLevelDescriptionLabel.text = model.today_sens_level;
    self.warnCountLabel.text = [NSString stringWithFormat:@"当前预警新闻篇数%ld篇",(model.today_sens_num>0 ?model.today_sens_num : 0)];
    self.todayLevelDescriptionLabel.text = model.today_sens_level?:@"非常低";
    
    switch (model.today_sens_tag) {
        case 1:
            self.todayLevelLabel.textColor = self.todayLevelDescriptionLabel.textColor = self.warnCountLabel.textColor = [UIColor colorWithHexString:@"3c5c8e"];
            self.rightBGImageView.image = [UIImage imageNamed:@"verylow_level_icon"];
            break;
        case 2:
            self.todayLevelLabel.textColor = self.todayLevelDescriptionLabel.textColor = self.warnCountLabel.textColor = [UIColor colorWithHexString:@"5a5076"];
            self.rightBGImageView.image = [UIImage imageNamed:@"low_level_icon"];
            break;
        case 3:
            self.todayLevelLabel.textColor = self.todayLevelDescriptionLabel.textColor = self.warnCountLabel.textColor = [UIColor colorWithHexString:@"76445e"];
            self.rightBGImageView.image = [UIImage imageNamed:@"middle_level_icon"];
            break;
        case 4:
            self.todayLevelLabel.textColor = self.todayLevelDescriptionLabel.textColor = self.warnCountLabel.textColor = [UIColor colorWithHexString:@"913846"];
            self.rightBGImageView.image = [UIImage imageNamed:@"high_level_icon"];
            break;
        case 5:
            self.todayLevelLabel.textColor = self.todayLevelDescriptionLabel.textColor = self.warnCountLabel.textColor = [UIColor colorWithHexString:@"b52929"];
            self.rightBGImageView.image = [UIImage imageNamed:@"veryhigh_level_icon"];
            break;
            
        default:
            break;
    }
}


@end
