//
//  HXMAnimationIndictateView.m
//  HeXunMaster
//
//  Created by 小贝 on 17/5/24.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMAnimationIndictateView.h"

@interface HXMAnimationIndictateView()

@property (nonatomic, strong)UIImageView *indictorImageView;

@property (nonatomic, strong) UILabel *indictorLabel;//

@end

@implementation HXMAnimationIndictateView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.backgroundColor = [UIColor colorWithHexString:@"#f7f7f7"];
    }
    return self;
}
#pragma mark - 

- (void)setupUI {

    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"indictorLoading_icon_1"],[UIImage imageNamed:@"indictorLoading_icon_2"],[UIImage imageNamed:@"indictorLoading_icon_3"],[UIImage imageNamed:@"indictorLoading_icon_4"],[UIImage imageNamed:@"indictorLoading_icon_5"],nil];
    
    self.indictorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 200, 20, 20)];
    
    self.indictorImageView.animationImages = array; //动画图片数组
    self.indictorImageView.animationDuration = 1.0; //执行一次完整动画所需的时长
    self.indictorImageView.animationRepeatCount = 0;//动画重复次数 0表示无限次，默认为0
    [self.indictorImageView startAnimating];
    [self addSubview:self.indictorImageView];

    self.indictorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    self.indictorLabel.textColor = [UIColor colorWithHexString:@"#dddcdd"];
    self.indictorLabel.font = [UIFont systemFontOfSize:15.0f];
    self.indictorLabel.text = @"加载中请稍后...";
    [self addSubview:self.indictorLabel];
    
    [self.indictorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.indictorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.indictorImageView.mas_bottom).offset(15);
        make.centerX.equalTo(self.indictorImageView);
    }];
    
    

}
@end
