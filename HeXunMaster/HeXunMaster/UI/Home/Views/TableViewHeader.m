//
//  TableViewHeader.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/8.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//



#import "TableViewHeader.h"

@interface TableViewHeader ()

@property (nonatomic,strong) UIImageView* loadingView;
@property (nonatomic, weak) UIImageView *headIcon;//头像
@property (nonatomic, weak) UILabel *totoalNews;//新闻总量
@property (nonatomic, weak) UILabel *PositiveNews;//正面新闻
@property (nonatomic, weak) UILabel *NegativeNews;//负面新闻
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat margin;

@end

@implementation TableViewHeader

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
        
    }
    return self;
}

- (void)setModel:(HXMNewsStatisticsCountModel *)model {
    
    _model = model;

    self.totoalNews.text = [self caculationNumber:model.totle_num];
    self.PositiveNews.text = [self caculationNumber:model.positive_num];
    self.NegativeNews.text = [self caculationNumber:model.negative_num];
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:model.company_logo]
                     placeholderImage:[UIImage imageNamed:@"placeholder_icon"]
                              options:SDWebImageRefreshCached];
}

- (NSString *)caculationNumber:(NSInteger)numberCount {
    
    if (numberCount<0) {
        return [NSString stringWithFormat:@"0"];
    } else if (numberCount<99999){
        return [NSString stringWithFormat:@"%ld",(long)numberCount] ;
    } else {
        return [NSString stringWithFormat:@"%ld万",(long)(numberCount/10000)];
    }
}


- (UIImageView *)loadingView {
    if (_loadingView) {
        return _loadingView;
    }
    _loadingView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 35.0f,-50.0f,25.0f,25.0f)];
    _loadingView.contentMode = UIViewContentModeScaleAspectFill;
    _loadingView.image = [UIImage imageNamed:@"refresh_go"];
    _loadingView.clipsToBounds = YES;
    _loadingView.backgroundColor = [UIColor clearColor];
    return _loadingView;
}

- (void)loadingViewAnimateWithScrollViewContentOffset:(CGFloat)offset {
    if (offset <= 0 && offset > - 150.0f) {
        self.loadingView.transform = CGAffineTransformMakeRotation(offset* 0.3);
        
    }
    //    NSLog(@"%f",offset);
    if (offset > -99 && offset<0) {
        _refreshLabel.text = @"下拉刷新";
    }else
        if (offset < - 125) {
            _refreshLabel.text = @"释放刷新";
        }
}

- (void)refreshingAnimateBegin {
    _refreshLabel.text = @"正在刷新";
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.duration = 0.5f;
    rotationAnimation.autoreverses = NO;
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    rotationAnimation.toValue = [NSNumber numberWithFloat:2 * M_PI];
    [self.loadingView.layer addAnimation:rotationAnimation forKey:@"rotationAnimations"];
}

- (void)refreshingAnimateStop {
    [self.loadingView.layer removeAllAnimations];
    _refreshLabel.text = @"刷新成功";
}

#pragma mark - 设置界面
- (void)setupUI {
    
    self.backgroundColor = [UIColor colorWithHexString:@"#3c5c8d"];
    _fontSize = 14;
    _margin = 32;
    
    if (IS_IPHONE_5_OR_LESS) {
        _fontSize -=2;
        _margin -=12;
    }
    UIView *displayView =
    [[UIView alloc] initWithFrame:CGRectMake(0.0f,- 120.0f,SCREEN_WIDTH,268.0f)];
    [self addSubview:displayView];
    UILabel * refreshLabel = [[UILabel alloc] init];
    _refreshLabel = refreshLabel;
    refreshLabel.text = @"下拉刷新";
    refreshLabel.font = [UIFont systemFontOfSize:12];
    refreshLabel.textColor = [UIColor colorWithHexString:@"#c5c5c5"];
    refreshLabel.frame = CGRectMake(SCREEN_WIDTH/2,-45.0f,50,15.0f);
    [self addSubview:refreshLabel];
    [self addSubview:self.loadingView];
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headerbackground_icon"]];
    bgImageView.frame = CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, displayView.bounds.size.height);
    bgImageView.clipsToBounds = YES;
    [displayView addSubview:bgImageView];
    
    //头像
    UIImageView * iv = [[UIImageView alloc] init];
    UIImage * image = [UIImage imageNamed:@"placeholder_icon"];
    iv.image = image;
    iv.layer.cornerRadius = 5;
    iv.layer.masksToBounds = YES;
    iv.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:iv];
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset (24);
        make.bottom.equalTo(self).offset(-16);
        make.width.height.mas_equalTo(65);
    }];
    
    //新闻总声量
    UILabel * totoallabel = [[UILabel alloc] init];
    totoallabel.text = @"新闻总声量";
    totoallabel.textColor = [UIColor whiteColor];
    [self addSubview:totoallabel];
    [totoallabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iv.mas_right).offset(18);
        make.bottom.equalTo(iv).offset(-3);
    }];
    UILabel * totoalNews = [[UILabel alloc] init];
    totoalNews.textColor = [UIColor whiteColor];
    [self addSubview:totoalNews];
    [totoalNews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(totoallabel);
        make.bottom.equalTo(totoallabel.mas_top).offset(-8);
    }];
    //正面新闻
    UILabel * Positivelabel = [[UILabel alloc] init];
    Positivelabel.text = @"正面新闻";
    Positivelabel.textColor = [UIColor whiteColor];
    [self addSubview:Positivelabel];
    [Positivelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(totoallabel.mas_right).offset(_margin);
        make.bottom.equalTo(iv).offset(-3);
    }];
    UILabel * PositiveNews = [[UILabel alloc] init];
    PositiveNews.textColor = [UIColor whiteColor];
    [self addSubview:PositiveNews];
    [PositiveNews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(Positivelabel);
        make.bottom.equalTo(Positivelabel.mas_top).offset(-8);
    }];
    //负面新闻
    UILabel * negativelabel = [[UILabel alloc] init];
    negativelabel.text = @"负面新闻";
    negativelabel.textColor = [UIColor whiteColor];
    [self addSubview:negativelabel];
    [negativelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(Positivelabel.mas_right).offset(_margin);
        make.bottom.equalTo(iv).offset(-3);
    }];
    UILabel * NegativeNews = [[UILabel alloc] init];
    NegativeNews.textColor = [UIColor whiteColor];
    
    [self addSubview:NegativeNews];
    [NegativeNews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(negativelabel);
        make.bottom.equalTo(negativelabel.mas_top).offset(-8);
    }];
    
    totoalNews.font = [UIFont systemFontOfSize:_fontSize + 6];
    totoallabel.font = [UIFont systemFontOfSize:_fontSize];
    negativelabel.font = [UIFont systemFontOfSize:_fontSize];
    NegativeNews.font = [UIFont systemFontOfSize:_fontSize + 6];
    Positivelabel.font = [UIFont systemFontOfSize:_fontSize];
    PositiveNews.font = [UIFont systemFontOfSize:_fontSize + 6];
    
    if (IS_IPHONE_5) {
        
        totoallabel.text = @"新闻总量";
        [totoallabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iv.mas_right).offset(10);
        }];
        
        [Positivelabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(totoallabel);
            make.left.equalTo(totoallabel.mas_right).offset(8);
            make.width.equalTo(totoallabel);
            make.height.equalTo(totoallabel);
        }];
        
        [negativelabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(Positivelabel);
            make.left.equalTo(Positivelabel.mas_right).offset(8);
            make.width.equalTo(Positivelabel);
            make.height.equalTo(Positivelabel);
            make.right.equalTo(self).offset(-10);
        }];
        
    }
    
    self.totoalNews = totoalNews;
    self.PositiveNews = PositiveNews;
    self.NegativeNews = NegativeNews;
    self.headIcon = iv;
    
}


@end
