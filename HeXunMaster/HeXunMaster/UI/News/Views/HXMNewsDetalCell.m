//
//  HXMNewsDetalCell.m
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/3/21.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMNewsDetalCell.h"

@interface HXMNewsDetalCell()<TTTAttributedLabelDelegate>

@property(nonatomic, weak) UILabel *titleLabel;//标题
@property (nonatomic, weak) UILabel *sourceLabel;//来源
@property (nonatomic, weak) UILabel *timeLabel;//时间
@property (nonatomic, weak) UILabel *sourceNewsMediaLabel;//转自
@property (nonatomic, weak) UILabel *detalLabel;//详情
@property (nonatomic, weak) UILabel *detalLabel1;//详情

@end

@implementation HXMNewsDetalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        
    }
    return self;
}

//- (void)setModel:(HXMDetailModel *)model {
//    
//    _model = model;
//    if ([self.btnTitle isEqual:@"微博新闻"]) {
//        _titleLabel.text = model.newsAuthor;
//        _detalLabel.hidden = YES;
//        _detalLabel1.text = model.newsContent;
//    } else {
//        _detalLabel1.hidden = YES;
//        _titleLabel.text = model.newsTitle;
//        NSString * str = [NSString stringWithFormat:@"%@",model.newsContent];
//        NSData *bodyData = [str dataUsingEncoding:NSUTF8StringEncoding];
//        NSAttributedString *body = [[NSAttributedString alloc] initWithHTMLData:bodyData options:nil documentAttributes:NULL];
//        _detalLabel.attributedString = body;
//    }
//    _sourceLabel.text = model.newsMedia;
//    _sourceNewsMediaLabel.text = ([model.sourceNewsMedia isEqual:@""]||[model.sourceNewsMedia isEqual:nil])?@"":[NSString stringWithFormat:@"转自:%@",model.sourceNewsMedia];
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.model.postTime/1000];
//    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
//    fmt.dateFormat = @"HH:mm:ss";
//    NSString *createdTime = [fmt stringFromDate:date];
//    _timeLabel.text = [NSString stringWithFormat:@"%@",createdTime];
//    
//    
//    
//}
#pragma mark - 设置界面
- (void)setupUI {
    //标题
    UILabel *titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(10, 80, SCREEN_WIDTH - 20, SCREEN_HEIGHT - 200)];
    titleLabel.numberOfLines = 0;
    //    titleLabel.delegate = self;
    titleLabel.text = @"十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议十二届全国人大五次会议";
    titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    titleLabel.font = [UIFont boldSystemFontOfSize:24];
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(14);
        make.left.equalTo(self.contentView).offset(24);
        make.right.equalTo(self.contentView).offset(-24);
    }];
    _titleLabel = titleLabel;
    
    //来源
    UILabel * sourceLabel = [[UILabel alloc] init];
    sourceLabel.text = @"中国投资网";
    sourceLabel.textColor = [UIColor colorWithHexString:@"#505050"];
    sourceLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:sourceLabel];
    [sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
        make.left.equalTo(titleLabel);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(14);
        // make.bottom.equalTo(self.contentView).offset(-5);
    }];
    _sourceLabel = sourceLabel;
    //时间
    UILabel * timeLabel = [[UILabel alloc] init];
    timeLabel.text = @"";
    timeLabel.textColor = [UIColor colorWithHexString:@"#505050"];
    timeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sourceLabel);
        make.left.equalTo(sourceLabel.mas_right).offset(13);
        
    }];
    _timeLabel = timeLabel;
    
    //转自
    UILabel * sourceNewsMediaLabel = [[UILabel alloc] init];
    sourceNewsMediaLabel.text = @"中性";
    sourceNewsMediaLabel.text = @"22-22-22";
    sourceNewsMediaLabel.textColor = [UIColor colorWithHexString:@"#505050"];
    sourceNewsMediaLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:sourceNewsMediaLabel];
    
    [sourceNewsMediaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLabel);
        make.left.equalTo(timeLabel.mas_right).offset(13);
        make.right.equalTo(self.contentView).offset(-24);
    }];
    _sourceNewsMediaLabel = sourceNewsMediaLabel;
    //详情
    UILabel * detalLabel = [[UILabel alloc] init];
    [self.contentView addSubview:detalLabel];
    [detalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sourceLabel);
        make.top.equalTo(sourceLabel.mas_bottom).offset(30);
        make.right.equalTo(self.contentView).offset (-24);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    _detalLabel = detalLabel;
    //微博新闻详情
    UILabel * detalLabel1 = [[UILabel alloc] init];
    detalLabel1.font = [UIFont systemFontOfSize:18];
    detalLabel1.textColor = [UIColor colorWithHexString:@"#505050"];
    detalLabel1.numberOfLines = 0;
    [self.contentView addSubview:detalLabel1];
    [detalLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sourceLabel);
        make.top.equalTo(sourceLabel.mas_bottom).offset(30);
        make.right.equalTo(self.contentView).offset (-24);
    }];
    _detalLabel1 = detalLabel1;
    
}


@end
