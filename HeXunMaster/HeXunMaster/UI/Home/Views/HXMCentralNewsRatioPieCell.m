//
//  HXMCentralNewsRatioPieCell.m
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/4/13.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMCentralNewsRatioPieCell.h"
#import "ZZCircleProgress.h"

@interface HXMCentralNewsRatioPieCell()

@property (nonatomic, weak) UILabel * centre_numLabel;
@property (nonatomic, weak) UILabel * province_numLabel;
@property (nonatomic, weak) UILabel * other_numLabel;


@end
@implementation HXMCentralNewsRatioPieCell{
    ZZCircleProgress *circle1;
    ZZCircleProgress *circle2;
    ZZCircleProgress *circle3;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        [self initCircles];
    }
    return self;
}


- (void)setModel:(HXMNewsStatisticsCountModel *)model {
    _model = model;
    
    CGFloat maxNumber= MAX(model.centre_num, model.province_num);
    maxNumber = MAX(maxNumber, model.other_num);
    
    self.totalCount = model.centre_num + model.province_num + model.other_num;
    [circle1 setProgress:(model.centre_num / maxNumber)/2];
    [circle2 setProgress:(model.province_num / maxNumber)/2];
    [circle3 setProgress:(model.other_num / maxNumber)/2];
    
    _centre_numLabel.text = [NSString stringWithFormat:@"中央%ld(%.2f%%)",(long)model.centre_num,(model.centre_num / self.totalCount) *100];
    
    _province_numLabel.text = [NSString stringWithFormat:@"省级%ld(%.2f%%)",(long)model.province_num,(model.province_num / self.totalCount) *100];
    
    _other_numLabel.text = [NSString stringWithFormat:@"其它%ld(%.2f%%)",(long)model.other_num,(model.other_num / self.totalCount) *100];
    
}

- (void)initCustomLabels:(NSString *)signLabelName colorName:(NSString *)colorName position:(CGPoint *)centerPosition {
    
    UIView *signView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 28)];
    [self.contentView addSubview:signView];
    
    UILabel *signLabel = [[UILabel alloc]init];
    signLabel.text = @"其他";
    [self.contentView addSubview:signLabel];
    
}

//初始化
- (void)initCircles {
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"e8e8e8"];
    [self.contentView addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(24);
        make.right.equalTo(self.contentView).offset(-24);
        make.height.equalTo(@0.5f);
    }];
    
    CGFloat xCrack = (SCREEN_WIDTH/2 - 60);
    CGFloat yCrack = (330/2 - 50);
    CGFloat itemWidth = 112.5;
    //默认状态
    circle1 = [[ZZCircleProgress alloc] initWithFrame:CGRectMake(xCrack, yCrack, itemWidth, itemWidth) pathBackColor:[UIColor clearColor] pathFillColor:[UIColor colorWithHexString:@"#e0514c"] startAngle:90 strokeWidth:28];
    circle1.showPoint = NO;
    circle1.showProgressText = NO;
    [self.contentView addSubview:circle1];
    
    
    circle2 = [[ZZCircleProgress alloc] initWithFrame:CGRectMake(xCrack-28, yCrack-28, itemWidth+56, itemWidth+56) pathBackColor:[UIColor clearColor] pathFillColor:[UIColor colorWithHexString:@"#f89679"] startAngle:90 strokeWidth:28];
    circle2.showPoint = NO;
    circle2.showProgressText = NO;
    [self.contentView addSubview:circle2];
    
    circle3 = [[ZZCircleProgress alloc] initWithFrame:CGRectMake(xCrack-28 - 28, yCrack-28-28, itemWidth+56+56, itemWidth+56+56) pathBackColor:[UIColor clearColor] pathFillColor:[UIColor colorWithHexString:@"#e3cfae"] startAngle:90 strokeWidth:28];
    circle3.showPoint = NO;
    circle3.showProgressText = NO;
    [self.contentView addSubview:circle3];
    
    NSArray * colorArr = @[@"#e0514c",@"#f89679",@"#e3cfae"];
    for (NSInteger i = 0; i < 3; i++) {
        UIView * colorView = [[UIView alloc] init];
        colorView.backgroundColor = [UIColor colorWithHexString:colorArr[i]];
        colorView.frame = CGRectMake(SCREEN_WIDTH/2 + 5, yCrack - 28 * i, 8, 28);
        [self.contentView addSubview:colorView];
        
        UILabel * dataLabel = [[UILabel alloc] init];
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
        dataLabel.frame = CGRectMake(SCREEN_WIDTH/2 + 20, yCrack - 28 * i, 150, 28);
        dataLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:dataLabel];
    }
  
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
