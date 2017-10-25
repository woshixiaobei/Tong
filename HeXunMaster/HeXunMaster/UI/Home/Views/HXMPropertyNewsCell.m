//
//  HXMPropertyNewsCell.m
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/4/14.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMPropertyNewsCell.h"
#import "MYCircelChartView.h"
#import "MYStockInfoMoneyModel.h"

@interface HXMPropertyNewsCell ()
//饼状图
@property (nonatomic, strong) MYCircelChartView *chartView;
@property (nonatomic, weak) UILabel * centre_numLabel;
@property (nonatomic, weak) UILabel * province_numLabel;
@property (nonatomic, weak) UILabel * other_numLabel;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, strong) UIView *bottomView;

@end


@implementation HXMPropertyNewsCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        
        [self initSubViews];
//        [self setupUI];
    }
    return self;
}
- (void)setCircleDataArray:(NSArray *)circleDataArray {
    _circleDataArray = circleDataArray;
    self.chartView.pCircleArrayM = circleDataArray;
}

- (void)setModel:(HXMNewsStatisticsCountModel *)model {
    _model = model;
//    
//    CGFloat totalCount = model.today_positive_num + model.today_negative_num + model.today_neutral_num;
//    _centre_numLabel.text = [NSString stringWithFormat:@"正面新闻\n%ld(%.2f%%)",(long)model.today_positive_num,(model.today_positive_num / totalCount) *100];
//    
//    _province_numLabel.text = [NSString stringWithFormat:@"负面新闻\n%ld(%.2f%%)",(long)model.today_negative_num,(model.today_negative_num / totalCount) *100];
//    
//    _other_numLabel.text = [NSString stringWithFormat:@"中性新闻\n%ld(%.2f%%)",(long)model.today_neutral_num,(model.today_neutral_num / totalCount) *100];
}

#pragma mark - initSubViews
- (void)initSubViews {
    
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    self.bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"e8e8e8"];
    [self.contentView addSubview:self.bottomView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(24);
        make.right.equalTo(self.contentView).offset(-24);
        make.height.equalTo(@0.5f);
    }];
    
    self.chartView = [[MYCircelChartView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    self.chartView.isFull = YES;
    self.chartView.nRadius = 0;
    self.chartView.nCircleWidth = 100;
    [self.contentView addSubview:self.chartView];
    
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(30);
        make.left.right.equalTo(self.contentView);
       make.bottom.equalTo(self.contentView).offset(-20);
    }];
}

#pragma mark - 设置界面
- (void)setupUI {
    
    NSArray * colorArr = @[@"#688fca",@"#f89679",@"#e3cfae"];
    for (NSInteger i = 0; i < 3; i++) {
        UIView * colorView = [[UIView alloc] init];
        colorView.backgroundColor = [UIColor colorWithHexString:colorArr[i]];
        if (IS_IPHONE_6_OR_LESS) {
            colorView.frame = CGRectMake((SCREEN_WIDTH/3 -10) * i + 28, 290, 11, 11);
            
        } else {
            
            colorView.frame = CGRectMake((SCREEN_WIDTH/3 + 5) * i + 28, 290, 11, 11);
        }
        [self.contentView addSubview:colorView];
        
        UILabel * dataLabel = [[UILabel alloc] init];
        dataLabel.text = @"负面新闻\n35(21.42%)";
        dataLabel.textColor = [UIColor colorWithHexString:colorArr[i]];
        dataLabel.tag = i + 1;
        switch (dataLabel.tag) {
            case 1:
                _centre_numLabel = dataLabel;
                break;
            case 2:
                _province_numLabel = dataLabel;
                break;
            case 3:
                _other_numLabel = dataLabel;
                break;
                
            default:
                break;
        }
        
        [self.contentView addSubview:dataLabel];
        dataLabel.numberOfLines = 2;
        [dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (IS_IPHONE_6_OR_LESS) {
                make.left.equalTo(self.contentView).offset((SCREEN_WIDTH/3 - 10)*i + 47);
                dataLabel.font = [UIFont systemFontOfSize:10];
            }else{
                dataLabel.font = [UIFont systemFontOfSize:12];
                make.left.equalTo(self.contentView).offset((SCREEN_WIDTH/3 + 5)*i + 47);
            }
            make.top.equalTo(colorView);
        }];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
