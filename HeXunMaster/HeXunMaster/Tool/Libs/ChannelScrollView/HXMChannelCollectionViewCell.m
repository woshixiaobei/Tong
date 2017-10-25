//
//  HXMChannelCollectionViewCell.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/8.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMChannelCollectionViewCell.h"

@implementation HXMChannelCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setShowsVc:(UIViewController *)showsVc {
    _showsVc = showsVc;
    [self addSubview:showsVc.view];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.showsVc.view.frame = self.contentView.bounds;
}

@end
