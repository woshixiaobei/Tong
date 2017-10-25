//
//  HXMStatisticsHeaderCell.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/15.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMStatisticsHeaderCell.h"

@interface HXMStatisticsHeaderCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerIconView;
@property (weak, nonatomic) IBOutlet UILabel *totalNewsLabel;
@property (weak, nonatomic) IBOutlet UILabel *positiveNewsLabel;
@property (weak, nonatomic) IBOutlet UILabel *negativeNewsLabel;

@property (nonatomic, weak) UIImageView *headIcon;//头像
@property (nonatomic, weak) UILabel *totoalNews;//新闻总量
@property (nonatomic, weak) UILabel *PositiveNews;//正面新闻
@property (nonatomic, weak) UILabel *NegativeNews;//负面新闻


@end

@implementation HXMStatisticsHeaderCell

- (void)awakeFromNib {

    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"headerbackground_icon"]];
}

- (void)setModel:(HXMNewsStatisticsCountModel *)model {
    _model = model;
    
    self.headerIconView.layer.cornerRadius = 5;
    self.headerIconView.layer.masksToBounds = YES;
//    self.totalNewsLabel.text = [NSString stringWithFormat:@"%ld",[self caculationNumber:model.totle_num]];
//    self.positiveNewsLabel.text = [NSString stringWithFormat:@"%ld",[self caculationNumber:model.positive_num]];
//    self.negativeNewsLabel.text = [NSString stringWithFormat:@"%ld",[self caculationNumber:model.negative_num]];
    [self.headerIconView sd_setImageWithURL:[NSURL URLWithString:model.company_logo]
                           placeholderImage:[UIImage imageNamed:@"placeholder_icon"]
                                    options:SDWebImageRefreshCached];

}



@end
