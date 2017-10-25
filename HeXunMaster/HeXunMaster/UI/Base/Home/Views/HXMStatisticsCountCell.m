//
//  HXMStatisticsCountCell.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/15.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMStatisticsCountCell.h"


@interface HXMStatisticsCountCell()

@property (nonatomic, copy) UIImage *totoalNews;//总声量
@property (nonatomic, weak) UILabel *NegativeNews;//负面新闻篇数
@property (nonatomic, weak) UILabel *level;//等级
@property (nonatomic, weak) UILabel *warnNews;//预警新闻篇数


@end

@implementation HXMStatisticsCountCell
//
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        
    }
    return self;
}

#pragma mark - 设置界面
- (void)setupUI {

    //左边视图
    UIView * leftView = [[UIView alloc] init];
    leftView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(Screen_width/2 - 0.5);
    }];
    //左边背景
    UIImageView * leftBgIv = [[UIImageView alloc] init];
    UIImage * bgImage = [UIImage imageNamed:@"totalCount_icon"];
    leftBgIv.image = bgImage;
    [leftView addSubview:leftBgIv];
    [leftBgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(leftView);
    }];
    //今日总声量
    UILabel * totoalNewsLabel = [[UILabel alloc] init];
    totoalNewsLabel.text = @"今日总声量";
    totoalNewsLabel.textColor = [UIColor colorWithHexString:@"#3c5c8e"];
    totoalNewsLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:totoalNewsLabel];
    [totoalNewsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(24);
        make.top.equalTo(self.contentView).offset(20);
    }];
    UILabel * totoalNews = [[UILabel alloc] init];
    totoalNews.text = @"2564";
    totoalNews.textColor = [UIColor colorWithHexString:@"#3c5c8e"];
    totoalNews.font = [UIFont systemFontOfSize:33];
    [self.contentView addSubview:totoalNews];
    [totoalNews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(totoalNewsLabel);
        make.top.equalTo(totoalNewsLabel.mas_bottom).offset(2);
    }];
    UILabel * NegativeNews = [[UILabel alloc] init];
    NegativeNews.text = @"当前负面新闻0篇";
    NegativeNews.textColor = [UIColor colorWithHexString:@"#727272"];
    NegativeNews.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:NegativeNews];
    [NegativeNews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(totoalNewsLabel);
        make.top.equalTo(totoalNews.mas_bottom).offset(6);
    }];
    
    
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_right);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(1);
    }];
    
    
    //右边视图
    UIView * rightView = [[UIView alloc] init];
    rightView.backgroundColor = [UIColor whiteColor];
    [self addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(Screen_width/2 - 0.5);
    }];
    //右边背景
    UIImageView * rightBgIv = [[UIImageView alloc] init];
    UIImage * rightBgImage = [UIImage imageNamed:@"verylow_level_icon"];
    rightBgIv.image = rightBgImage;
    [rightView addSubview:rightBgIv];
    [rightBgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(rightView);
    }];
    //预警等级
    UILabel * todayLevelLabel = [[UILabel alloc] init];
    todayLevelLabel.text = @"今日舆情预警等级";
    todayLevelLabel.textColor = [UIColor colorWithHexString:@"#3c5c8e"];
    todayLevelLabel.font = [UIFont systemFontOfSize:16];
    [rightView addSubview:todayLevelLabel];
    [todayLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rightView).offset(24);
        make.top.equalTo(rightView).offset(20);
    }];
    UILabel * todayLevel = [[UILabel alloc] init];
    todayLevel.text = @"非常低";
    todayLevel.textColor = [UIColor colorWithHexString:@"#3c5c8e"];
    todayLevel.font = [UIFont systemFontOfSize:33];
    [rightView addSubview:todayLevel];
    [todayLevel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(todayLevelLabel);
        make.top.equalTo(todayLevelLabel.mas_bottom).offset(2);
    }];
    UILabel * warnNews = [[UILabel alloc] init];
    warnNews.text = @"当前预警新闻篇数0篇";
    warnNews.textColor = [UIColor colorWithHexString:@"#727272"];
    warnNews.font = [UIFont systemFontOfSize:12];
    [rightView addSubview:warnNews];
    [warnNews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(todayLevelLabel);
        make.top.equalTo(todayLevel.mas_bottom).offset(6);
    }];
    
    
    
}

@end
