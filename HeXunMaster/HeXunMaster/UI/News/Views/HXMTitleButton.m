//
//  HXMTitleButton.m
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/9/19.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMTitleButton.h"

@implementation HXMTitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {

    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    [self setImage:[UIImage imageNamed:@"pull_up_icon"] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"push_down_icon"] forState:UIControlStateSelected];
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.frame = CGRectMake(0, 0, 150, 20);
//    self.titleLabel.centerX = self.centerX;
//    self.titleLabel.left = 0;
//    self.imageView.size = CGSizeMake(14, 8);
//    self.imageView.centerY = self.titleLabel.centerY;
//    self.imageView.left = CGRectGetMaxX(self.titleLabel.frame) + 8;
    // 还可增设间距
    CGFloat spacing = 8.0;
    
    // 图片右移
    CGSize imageSize = self.imageView.frame.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width * 2 - spacing, 0.0, 0.0);

    // 文字左移
    CGSize titleSize = self.titleLabel.frame.size;
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, - titleSize.width * 2 - spacing);
    self.imageView.size = CGSizeMake(14, 8);
    self.imageView.centerY = self.titleLabel.centerY;
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
    [super setImage:image forState:state];
    [self sizeToFit];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    [self sizeToFit];
}

@end
