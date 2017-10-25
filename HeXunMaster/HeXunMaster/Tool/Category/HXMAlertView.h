//
//  HXMAlertView.h
//  
//
//  Created by wangmingzhu on 2017/5/3.
//  Copyright © 2017年 wangmingzhu. All rights reserved.

#import <UIKit/UIKit.h>

@protocol HXMAlertViewDelegate;

@interface HXMAlertView : UIView

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImage *icon;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *message;
@property (weak, nonatomic) id<HXMAlertViewDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title icon:(UIImage *)icon message:(NSString *)message delegate:(id<HXMAlertViewDelegate>)delegate buttonTitles:(NSString *)buttonTitles, ... NS_REQUIRES_NIL_TERMINATION;

// Show the alert view in current window
- (void)show;

// Hide the alert view
- (void)hide;

// Set the color and font size of title, if color is nil, default is black. if fontsize is 0, default is 14
- (void)setTitleColor:(UIColor *)color fontSize:(CGFloat)size;

// Set the color and font size of message, if color is nil, default is black. if fontsize is 0, default is 12
- (void)setMessageColor:(UIColor *)color fontSize:(CGFloat)size;

// Set the color and font size of button at the index, if color is nil, default is black. if fontsize is 0, default is 16
- (void)setButtonTitleColor:(UIColor *)color fontSize:(CGFloat)size atIndex:(NSInteger)index;

@end

@protocol HXMAlertViewDelegate <NSObject>

- (void)alertView:(HXMAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
