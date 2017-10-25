//
//  HXMPushToastView.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/5/18.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXMPushToastView : UIView

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, strong) NSDictionary *userInfo;
- (void)show;
- (void)hide;
@end
