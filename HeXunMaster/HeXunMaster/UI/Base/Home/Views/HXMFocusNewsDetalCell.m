//
//  HXMFocusNewsDetalCell.m
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/3/20.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMFocusNewsDetalCell.h"

@implementation HXMFocusNewsDetalCell

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
    //标题
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议";
    titleLabel.numberOfLines = 2;
    titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    titleLabel.font = [UIFont systemFontOfSize:19];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(24);
        make.top.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-24);
    }];
    //详情
    UILabel * detalLabel = [[UILabel alloc] init];
    detalLabel.text = @"十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议";
    detalLabel.numberOfLines = 2;
    detalLabel.textColor = [UIColor colorWithHexString:@"#727272"];
    detalLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:detalLabel];
    [detalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).offset(5);
        make.right.equalTo(titleLabel);
    }];
    //等级
    UILabel * levelLabel = [[UILabel alloc] init];
    levelLabel.text = @"中性";
    levelLabel.textAlignment = 2;
    levelLabel.textColor = [UIColor colorWithHexString:@"#7b496"];
    levelLabel.layer.cornerRadius = 3;
    levelLabel.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithHexString:@"#7b496"]);
    levelLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:levelLabel];
    [levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(detalLabel.mas_bottom).offset(10);
        make.width.mas_equalTo(26.5);
        make.height.mas_equalTo(14);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    //来源
    UILabel * sourceLabel = [[UILabel alloc] init];
    sourceLabel.text = @"中国投资网";
    sourceLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    sourceLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:sourceLabel];
    [sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(levelLabel.mas_right).offset(10);
        make.top.equalTo(levelLabel);
    }];
    //来源
    UILabel * timeLabel = [[UILabel alloc] init];
    timeLabel.text = @"22-22-22";
    timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    timeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sourceLabel.mas_right).offset(14);
        make.top.equalTo(levelLabel);
    }];
    
    //相似新闻
    UIButton * likeNewBtn = [[UIButton alloc] init];
    [likeNewBtn setTitle:@"10条相似新闻" forState:UIControlStateNormal];
    [likeNewBtn setTitleColor:[UIColor colorWithHexString:@"#3d68ad"] forState:UIControlStateNormal];
    likeNewBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:likeNewBtn];
    [likeNewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.equalTo(levelLabel);
        make.right.equalTo(self).offset(-24);
    }];
    
}
@end
