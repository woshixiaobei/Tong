//
//  HXMFeedBackView.h
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/4/28.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXMFeedBackView : UIView<UITextViewDelegate>

@property (nonatomic ,strong) UITextView *contentTextView;

@property (nonatomic, copy) void (^buttonClicked)(NSString * content);
//  文本数组计算
@property (nonatomic, strong) UILabel *textCountlabel;

@end
