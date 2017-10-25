//
//  HXMStatisticsHeaderCell.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/15.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMStatisticsHeaderCell.h"

@interface HXMStatisticsHeaderCell()

@property (nonatomic, copy) UIImage *headIcon;//头像
@property (nonatomic, weak) UILabel *totoalNews;//新闻总量
@property (nonatomic, weak) UILabel *PositiveNews;//正面新闻
@property (nonatomic, weak) UILabel *NegativeNews;//负面新闻


@end

@implementation HXMStatisticsHeaderCell

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
//
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
    //背景
    UIImageView * bgIv = [[UIImageView alloc] init];
    UIImage * bgImage = [UIImage imageNamed:@"headerbackground_icon"];
    bgIv.image = bgImage;
    bgIv.frame = self.backgroundView.frame;
    self.backgroundView = bgIv;
    
    //头像
    UIImageView * iv = [[UIImageView alloc] init];
    UIImage * image = [UIImage imageNamed:@"placeholder_icon"];
    iv.image = image;
    [self.contentView addSubview:iv];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(24);
        make.bottom.equalTo(self.contentView).offset(-16);
        make.width.height.mas_equalTo(65);
    }];
    
    //新闻总数
    UILabel * totalNews = [[UILabel alloc] init];
    totalNews.text = @"2564";
    totalNews.textAlignment = NSTextAlignmentLeft;
    totalNews.textColor = [UIColor colorWithHexString:@"#ffffff"];
    totalNews.font = [UIFont systemFontOfSize:20];
    [self.contentView addSubview:totalNews];
    [totalNews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iv.mas_right).offset(18);
        make.top.equalTo(self.contentView).offset(65);
    }];
    UILabel * totalNewsLabel = [[UILabel alloc] init];
    totalNewsLabel.text = @"新闻总声量";
    totalNewsLabel.textColor = [UIColor colorWithHexString:@"#c1cbdf"];
    totalNewsLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:totalNewsLabel];
    [totalNewsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iv.mas_right).offset(18);
        make.top.equalTo(totalNews.mas_bottom);
    }];

    
    //正面新闻
    UILabel * PositiveNews = [[UILabel alloc] init];
    PositiveNews.text = @"280";
    PositiveNews.textAlignment = NSTextAlignmentLeft;
    PositiveNews.textColor = [UIColor colorWithHexString:@"#ffffff"];
    PositiveNews.font = [UIFont systemFontOfSize:20];
    [self.contentView addSubview:PositiveNews];
    [PositiveNews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(totalNews);
        make.left.equalTo(totalNewsLabel.mas_right).offset(32);
    }];
    UILabel * PositiveNewsLabel = [[UILabel alloc] init];
    PositiveNewsLabel.text = @"正面新闻";
    PositiveNewsLabel.textColor = [UIColor colorWithHexString:@"#c1cbdf"];
    PositiveNewsLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:PositiveNewsLabel];
    [PositiveNewsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(PositiveNews.mas_bottom);
        make.left.equalTo(PositiveNews);
    }];
    //负面新闻
    UILabel * NegativeNews = [[UILabel alloc] init];
    NegativeNews.text = @"64";
    NegativeNews.textColor = [UIColor colorWithHexString:@"#ffffff"];
    NegativeNews.font = [UIFont systemFontOfSize:20];
    [self addSubview:NegativeNews];
    [NegativeNews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(PositiveNews);
        make.left.equalTo(PositiveNewsLabel.mas_right).offset(32);
    }];
    UILabel * NegativeNewsLabel = [[UILabel alloc] init];
    NegativeNewsLabel.text = @"负面新闻";
    NegativeNewsLabel.textColor = [UIColor colorWithHexString:@"#c1cbdf"];
    NegativeNewsLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:NegativeNewsLabel];
    [NegativeNewsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(NegativeNews.mas_bottom);
        make.left.equalTo(NegativeNews);
    }];
    
    _headIcon = image;
    _totoalNews = totalNews;
    _PositiveNews = PositiveNews;
    _NegativeNews = NegativeNews;
    
    
    
}

@end
