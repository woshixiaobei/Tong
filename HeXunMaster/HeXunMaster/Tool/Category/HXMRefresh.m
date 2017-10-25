//
//  HXMRefresh.m
//  HeXunMaster
//
//  Created by Clark on 2017/4/5.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMRefresh.h"
#import "UIView+Extension.h"
#import "NSDate+HXMdate.h"

@interface HXMRefresh()
//@property (nonatomic,weak) UIImageView *topImageView;
//@property (nonatomic,weak) UIImageView *secondImageView;

@end

@implementation HXMRefresh

-(void)prepare
{
    [super prepare];
    
    self.height = 58;
    self.stateLabel.font = [UIFont systemFontOfSize:12];
    self.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    
    self.stateLabel.textColor = [UIColor colorWithHexString:@"#c5c5c5"];
    self.lastUpdatedTimeLabel.textColor = [UIColor colorWithHexString:@"#c5c5c5"];
    self.stateLabel.textAlignment = NSTextAlignmentCenter;
    self.stateLabel.bottom = self.lastUpdatedTimeLabel.top+5;
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 1; i<4; i++) {
        [arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"earth_icon_%d",i]]];
    }
    [self setImages:@[arr[0]] forState:MJRefreshStateIdle];
    [self setImages:arr forState:MJRefreshStateRefreshing];
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    
    [super placeSubviews];
    self.backgroundColor = [UIColor colorWithHexString:@"#f4f5f6"];
    self.stateLabel.frame = CGRectMake(Screen_width/2 - 15, 0, 80, 24.5);
    self.lastUpdatedTimeLabel.frame = CGRectMake(Screen_width/2 - 15, 24.5, 200, 28.5);
    self.stateLabel.textAlignment = NSTextAlignmentLeft;
    self.lastUpdatedTimeLabel.textAlignment = NSTextAlignmentLeft;
    self.labelLeftInset = -10;
}
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state {
    [super setImages:images duration:duration forState:state];
    
    
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
    
}

- (NSString *)timeProcessingWithTime:(NSString *)time{
    
    NSDate *last = [[NSUserDefaults standardUserDefaults] objectForKey:@"refreshDate"];
    //本地缓存下拉刷新时间
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"refreshDate"];
    if (!last) {
        last = [NSDate date];
    }
    return  [last difference:[NSDate date]];
    
}
-(void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    NSTimeInterval nowtime = [[NSDate date] timeIntervalSince1970];
    long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
    NSString *curTime = [NSString stringWithFormat:@"%llu",theTime];
    NSString * str = [self timeProcessingWithTime:curTime];
    
    switch (state) {
        case MJRefreshStateIdle:
        {
            self.lastUpdatedTimeLabel.text = [NSString stringWithFormat:@"最后更新:%@",str];
            [self setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
        }
            break;
        case MJRefreshStatePulling:
        {
            self.lastUpdatedTimeLabel.text = [NSString stringWithFormat:@"最后更新:%@",str];;
            [self setTitle:@"释放刷新" forState:MJRefreshStatePulling];
        }
            break;
        case MJRefreshStateRefreshing:
        {
            self.lastUpdatedTimeLabel.text = [NSString stringWithFormat:@"最后更新:%@",str];
            [self setTitle:@"正在加载" forState:MJRefreshStateRefreshing];
        }
            break;
            
        default:
            break;
    }
}

@end
