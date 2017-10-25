//
//  HXMSimilarNewsCell.m
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/3/23.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMSimilarNewsCell.h"


@interface HXMSimilarNewsCell ()
@property(nonatomic, weak) UILabel *titleLabel;//标题
@property (nonatomic, weak) UILabel *sourceLabel;//来源
@property (nonatomic, weak) UILabel *timeLabel;//时间
@property (nonatomic, weak) UILabel *levelLabel;//等级
@property (nonatomic, strong) UIButton *similarNewsButton;//相似新闻

@end

@implementation HXMSimilarNewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}


- (void)setModel:(HXMDetailNewsCellModel *)model {
    _model = model;
    NSString *titleName = nil;
    self.titleLabel.text = model.newsTitle;
    if (model.sameNewsCount>0&&model.sameNewsCount<999) {
        titleName = [NSString stringWithFormat:@"%ld条相似新闻",(long)model.sameNewsCount];
        [self.similarNewsButton setTitle:titleName forState:UIControlStateNormal];
        self.similarNewsButton.hidden = NO;
        
    } else if (model.sameNewsCount >999) {
        titleName = [NSString stringWithFormat:@"999+条相似新闻"];
        [self.similarNewsButton setTitle:titleName forState:UIControlStateNormal];
        self.similarNewsButton.hidden = NO;
    } else {
        self.similarNewsButton.hidden = YES;
    }
    if (model.newsMedia.length>6) {
        NSString *str = [model.newsMedia substringWithRange:NSMakeRange(0, 6)];
        NSString *newsMedia = [NSString stringWithFormat:@"%@...",str];
        self.sourceLabel.text = newsMedia;
    } else {
        
        self.sourceLabel.text = model.newsMedia;
    }

    if ([model.newsPositive isEqualToString:@"中性"]) {
        self.levelLabel.text = @"中性";
        self.levelLabel.layer.borderColor = ([UIColor colorWithHexString:@"#c7b496"]).CGColor;
        self.levelLabel.textColor = [UIColor colorWithHexString:@"#c7b496"];
        
    }else if ([model.newsPositive isEqualToString:@"正面"]) {
        self.levelLabel.text = @"正面";
        self.levelLabel.layer.borderColor = ([UIColor colorWithHexString:@"#688fca"]).CGColor;
        self.levelLabel.textColor = [UIColor colorWithHexString:@"#688fca"];
        
    }else if ([model.newsPositive isEqualToString:@"负面"]) {
        self.levelLabel.text = @"负面";
        self.levelLabel.layer.borderColor = ([UIColor colorWithHexString:@"#e0514c"]).CGColor;
        self.levelLabel.textColor = [UIColor colorWithHexString:@"#e0514c"];
    }

    NSString *createdTime = [self isToday:self.model.postTime/1000];
    self.timeLabel.text = createdTime;

}

- (void)clickToSimilarListViewController:(UIButton *)sender {
    
    if ( self.delegate && [self.delegate respondsToSelector:@selector(similarListPushToSimilarNewsViewController:news_id:)]) {
        [self.delegate similarListPushToSimilarNewsViewController:self news_id:self.model.id];
    }
}

- (NSString *)isToday:(NSTimeInterval )timeInterval {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *dateSMS = [dateFormatter stringFromDate:date];
    NSDate *now = [NSDate date];
    NSString *dateNow = [dateFormatter stringFromDate:now];
    if ([dateSMS isEqualToString:dateNow]) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    }
    else {
        [dateFormatter setDateFormat:@"YY-MM-dd HH:mm"];
    }
    dateSMS = [dateFormatter stringFromDate:date];
    
    return dateSMS;
}
#pragma mark - 设置界面
- (void)setupUI {
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    [self.contentView addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(24);
        make.right.equalTo(self.contentView).offset(-24);
        make.height.equalTo(@0.5);
    }];
    //标题
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议";
    titleLabel.numberOfLines = 2;
    titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    titleLabel.font = [UIFont systemFontOfSize:19.0];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView).offset(16);
        make.left.equalTo(lineView);
        make.right.equalTo(lineView);
    }];
    self.titleLabel = titleLabel;
    //等级
    UILabel * levelLabel = [[UILabel alloc] init];
    levelLabel.text = @"中性";
    levelLabel.backgroundColor = [UIColor whiteColor];
    levelLabel.textAlignment = NSTextAlignmentCenter;
    levelLabel.layer.borderColor = ([UIColor colorWithHexString:@"#c7b496"]).CGColor;
    levelLabel.textColor = [UIColor colorWithHexString:@"#c7b496"];
    levelLabel.layer.cornerRadius = 3;
    levelLabel.layer.masksToBounds = YES;
    levelLabel.layer.borderWidth = 1.0;
    levelLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:levelLabel];
    [levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.left.equalTo(titleLabel);
        make.width.equalTo(@27);
        make.height.equalTo(@14);
    }];
    self.levelLabel = levelLabel;

    //来源
    UILabel * sourceLabel = [[UILabel alloc] init];
    sourceLabel.text = @"中国投资网";
    sourceLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    sourceLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:sourceLabel];
    [sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(levelLabel);
        make.left.equalTo(levelLabel.mas_right).offset(10);
    }];
    self.sourceLabel = sourceLabel;
    
    //时间
    UILabel * timeLabel = [[UILabel alloc] init];
    timeLabel.text = @"22-22-22";
    timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    timeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sourceLabel);
        make.left.equalTo(sourceLabel.mas_right).offset(14);
        make.bottom.equalTo(self.contentView).offset(-16);
    }];
    self.timeLabel = timeLabel;
   
    self.similarNewsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.similarNewsButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.similarNewsButton setTitle:@"0条相似新闻" forState:UIControlStateNormal];
    [self.similarNewsButton setTitleColor:[UIColor colorWithHexString:@"#3d68ad"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.similarNewsButton];
    
    [self.similarNewsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeLabel);
        make.right.equalTo(self.contentView).offset(-24);
    }];
    
    [self.similarNewsButton addTarget:self action:@selector(clickToSimilarListViewController:) forControlEvents:UIControlEventTouchUpInside];
}
@end
