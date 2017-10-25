//
//  HXMStatisticsLevelCollectionCell.m
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/3/20.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMStatisticsLevelCollectionCell.h"

@interface HXMStatisticsLevelCollectionCell()


@end

@implementation HXMStatisticsLevelCollectionCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setModel:(HXMCommonModuleModel *)model {
    _model = model;
    
    [self.appIcon sd_setImageWithURL:[NSURL URLWithString:
                                      [NSString stringWithFormat:@"%@",model.app_module_logo?:nil]]
                    placeholderImage:[UIImage imageNamed:@"placeholder_icon"]
                             options:(SDWebImageRefreshCached)];
    self.titlleLabel.text = model.module_name;

}
#pragma mark - 设置界面
- (void)setupUI {
    
    //新闻图标
    self.appIcon = [[UIImageView alloc] init];
    UIImage * BgImage = [UIImage imageNamed:@"tabbar_icon_home_highlight"];
    self.appIcon.image = BgImage;
    [self.contentView addSubview:self.appIcon];
    [self.appIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(13);
        make.width.height.mas_equalTo(30);
    }];
    //新闻名称
    self.titlleLabel = [[UILabel alloc] init];
    self.titlleLabel.text = @"公司新闻";
    self.titlleLabel.textColor = [UIColor colorWithHexString:@"#3c5c8e"];
    self.titlleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.titlleLabel];
    [self.titlleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.appIcon.mas_bottom).offset(10);
        make.centerX.equalTo(self.appIcon);
    }];
    
}
@end
