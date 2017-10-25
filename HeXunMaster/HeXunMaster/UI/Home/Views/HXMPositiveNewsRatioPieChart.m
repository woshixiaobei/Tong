//
//  HXMPositiveNewsRatioPieChart.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/23.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMPositiveNewsRatioPieChart.h"
#import "MYCircelChartView.h"
#import "MYStockInfoMoneyModel.h"
#import <Masonry.h>


@interface HXMPositiveNewsRatioPieChart()

//饼状图
@property (nonatomic, strong) MYCircelChartView *chartView;
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation HXMPositiveNewsRatioPieChart

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        [self initSubViews];
    }
    return self;
}

- (void)setCircleDataArray:(NSArray *)circleDataArray {
    _circleDataArray = circleDataArray;
    self.chartView.pCircleArrayM = circleDataArray;
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
    
//    self.chartView.nRadius = 50.f;
//    self.chartView.nCircleWidth = 225.f;
//    self.chartView.nStrokeTextSize = 12;
    self.chartView = [[MYCircelChartView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 330)];
    [self.contentView addSubview:self.chartView];
    
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];

}
@end
