//
//  HXMCommpanyNewsHeaderView.h
//  HeXunMaster
//
//  Created by 小贝 on 17/3/26.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXMCommpanyNewsHeaderView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;

- (instancetype)initWithTitle:(NSString *)title WithTitleColor:(UIColor *)titleColor withImageView:(NSString *)imageName;
@end
