//
//  HXMChannelLable.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/8.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMChannelLable.h"


/**尺寸以及手机类型判断 */
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_IPHONE_5_OR_LESS (SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_6_OR_MORE (SCREEN_MAX_LENGTH >= 667.0)
#define IS_IPHONE_5 (SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6_OR_7   (SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P_OR_7R (SCREEN_MAX_LENGTH == 736.0)

@implementation HXMChannelLable



- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.font = [UIFont systemFontOfSize:(IS_IPHONE_6_OR_MORE?17.f:16.f)];
        self.textAlignment = NSTextAlignmentCenter;
        self.isSelect = NO;
        self.backgroundColor = [UIColor colorWithHexString:@"f6f5f4"];
    }
    return self;
}

-(void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    if (isSelect) {
        self.textColor = [UIColor colorWithHexString:@"#3c5c8e"];
    }else{
        self.textColor = [UIColor colorWithHexString:@"#000000"];
    }
}

@end
