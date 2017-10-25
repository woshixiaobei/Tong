//
//  HXMfooterRefresh.m
//  HeXunMaster
//
//  Created by 小贝 on 17/4/9.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMfooterRefresh.h"

@implementation HXMfooterRefresh

- (void)prepare {
    [super prepare];
    
    self.stateLabel.textColor = [UIColor colorWithHexString:@"#c5c5c5"];
    self.stateLabel.font = [UIFont systemFontOfSize:12];
    [self setTitle: @"正在加载，请稍后...." forState:MJRefreshStateRefreshing];
}

- (void)setTitle:(NSString *)title forState:(MJRefreshState)state
{
    [super setTitle:title forState:state];
    
//    if (title == nil) return;
//    self.stateTitles[@(state)] = title;
//    self.stateLabel.text = self.stateTitles[@(self.state)];
}

@end
