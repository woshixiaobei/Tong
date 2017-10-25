//
//  ZLSegmentView.h
//  ZLSegmentView
//
//  Created by Zl on 2017/3/13.
//  Copyright © 2017年 Zl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZLSegmentView;

@protocol ZLSegmentViewDelegate <NSObject>

// 选中index后执行的代理方法
- (void)ZLSegmentView:(ZLSegmentView*)segment didSelectIndex:(NSInteger)index;

@end

@interface ZLSegmentView : UIControl

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIFont *textFont;
@property (nonatomic,assign) NSInteger selectedIndex;
@property(nonatomic, strong) id<ZLSegmentViewDelegate> delegate;

// 标题名称字符串数组
- (void)updateChannels:(NSArray*)array;

// 改变选中的index方法
- (void)didChangeToIndex:(NSInteger)index;

@end
