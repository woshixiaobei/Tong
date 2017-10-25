//
//  HXMNavCustomButton.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/17.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMNavCustomButton.h"

@implementation HXMNavCustomButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initCustomButton];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setLeftTitle:(NSString *)leftTitle {
    _leftTitle = leftTitle;
}
- (void)initCustomButton {
    
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    navButton.titleLabel.text = self.leftTitle;

    [navButton setImage:[UIImage imageNamed:@"login_clearContent_icon"] forState:UIControlStateNormal];
    [navButton setImage:[UIImage imageNamed:@"login_phoneNum_icon"] forState:UIControlStateSelected];
    
    navButton.titleLabel.font = [UIFont systemFontOfSize:17];
    navButton.titleLabel.textColor = [UIColor lightGrayColor];
    
    [navButton sizeToFit];
    
}

-(void)layoutSubviews {

    [super layoutSubviews];
    if (self.titleLabel.text && self.imageView) {
        UIImage *image = self.imageView.image;
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width, 0, -self.titleLabel.bounds.size.width)];
        
    } else {
        return;
    }  

}
@end
