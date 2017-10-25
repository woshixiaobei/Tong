//
//  SharePlatformButtoon.m
//  投顾志
//
//  Created by 李帅 on 15/6/19.
//  Copyright (c) 2015年 hexun. All rights reserved.
//  图片在上 文字在下

#import "SharePlatformButtoon.h"

@implementation SharePlatformButtoon

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 内部图标居中
        self.imageView.contentMode = UIViewContentModeCenter;
        // 文字对齐
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 字体
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        // 高亮的时候不需要调整内部的图片为灰色
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

/**
 *  设置内部图标的frame
 */
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageY = 20;
    CGFloat imageW = self.width;
    CGFloat imageH = 60;
    CGFloat imageX = 0;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

/**
 *  设置内部文字的frame
 */
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = 7 + 60;
    CGFloat titleX = 0;
    CGFloat titleH = self.height - titleY;
    CGFloat titleW = self.width;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

@end
