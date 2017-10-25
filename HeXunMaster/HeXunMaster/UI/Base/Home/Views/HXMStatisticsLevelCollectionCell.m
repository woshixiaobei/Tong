//
//  HXMStatisticsLevelCollectionCell.m
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/3/20.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMStatisticsLevelCollectionCell.h"

@interface HXMStatisticsLevelCollectionCell()

@property (nonatomic, weak) UIImage *appIcon;//功能图标
@property (nonatomic, weak) UILabel *appLabel;//功能名称


@end

@implementation HXMStatisticsLevelCollectionCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

#pragma mark - 设置界面
- (void)setupUI {
    
    //右边背景
    UIImageView * BgIv = [[UIImageView alloc] init];
    UIImage * BgImage = [UIImage imageNamed:@"tabar_icon_home_highlight"];
    BgIv.image = BgImage;
    [self.contentView addSubview:BgIv];
    [BgIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(36);
        make.top.equalTo(self.contentView).offset(13);
        make.width.height.mas_equalTo(30);
    }];
    //预警等级
    UILabel * titlleLabel = [[UILabel alloc] init];
    titlleLabel.text = @"公司新闻";
    titlleLabel.textColor = [UIColor colorWithHexString:@"#3c5c8e"];
    titlleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:titlleLabel];
    [titlleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(BgIv.mas_bottom).offset(10);
        make.centerX.equalTo(BgIv);
    }];
    _appIcon = BgImage;
    _appLabel = titlleLabel;
    
}
@end
