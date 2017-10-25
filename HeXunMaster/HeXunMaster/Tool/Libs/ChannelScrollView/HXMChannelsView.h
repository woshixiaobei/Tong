//
//  HXMChannelsView.h
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/8.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXMChannelsView : UIScrollView

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, copy) void(^clickChannel)(NSInteger index);

- (instancetype)initWithChannels:(NSArray *) channels pageCount:(NSInteger) pageCount;

- (void)lastScrollCenterMethod;


@end
