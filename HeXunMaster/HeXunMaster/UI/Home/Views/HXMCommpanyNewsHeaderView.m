//
//  HXMCommpanyNewsHeaderView.m
//  HeXunMaster
//
//  Created by 小贝 on 17/3/26.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMCommpanyNewsHeaderView.h"

@implementation HXMCommpanyNewsHeaderView

#pragma mark - 设置界面
- (instancetype)initWithTitle:(NSString *)title WithTitleColor:(UIColor *)titleColor withImageView:(NSString *)imageName {
    
    self = [super init];
    if (self) {
        UIView *headerLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        headerLine.backgroundColor = [UIColor colorWithHexString:@"#f4f5f6"];
        [self addSubview:headerLine];
        
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview: bottomView];
        
        self.iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        [bottomView addSubview:self.iconView];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.text = title;
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#3c5c8e"];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        [bottomView addSubview:self.titleLabel];
        
        UIView *lightGrayLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 24*2, 0.5)];
        lightGrayLine.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
        [bottomView addSubview:lightGrayLine];
        
        [headerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(10);
        }];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerLine.mas_bottom);
            make.left.right.bottom.equalTo(self);
        }];
        
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomView).offset(24);
            make.centerY.equalTo(bottomView);
            make.width.height.equalTo(@15.f);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.mas_right).offset(6);
            make.centerY.equalTo(bottomView);
        }];
        
        [lightGrayLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomView).offset(24);
            make.right.equalTo(bottomView).offset(-24);
            make.bottom.equalTo(bottomView);
            make.height.mas_equalTo(0.5);
        }];
    }
    
    return self;
}
@end
