//
//  ChannelScrollView.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/8.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChannelScrollViewDelegate;

@interface ChannelScrollView : UIView

/**代理 */
@property(nonatomic, weak) id<ChannelScrollViewDelegate> delegate;

/**
 初始化控制器

 @param channels 频道标签集合
 @param pageCount 当前页显示几个 标签
 @return 控制器
 */
+ (instancetype)GetChannelScrollViewContorllerWithChannelDatas:(NSArray*) channels pageChannelCount:(NSInteger) pageCount;

@end


@protocol ChannelScrollViewDelegate <NSObject>

@optional
/**
 返回每页需要显示控制器,控制器内容的显示方式自定义,需要自己实现,根据indexpath返回每页对应控制器
 */
- (UIViewController *)ChannelScrollView:(ChannelScrollView *) channelVc ViewcontrollerForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
