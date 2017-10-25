//
//  UIBarButtonItem+Extension.m
//  renrentong
//
//  Created by wangmingzhu on 17/3/15.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

//@property (nonatomic,strong) UIButton *customButton;
/**
 * 通过一张图片返回一个UIBarButtonItem
 *
 * @param imageName 图片名字
 *
 * @return UIBarButtonItem
 */
+ (instancetype)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action;


/**
 * 通过一张图片与文字返回一个UIBarButtonItem
 *
 * @param imageName 图片名字
 * @param title     标题
 * @param target    目标
 * @param action    事件
 *
 * @return <#return value description#>
 */
+ (instancetype)itemWithImageName:(NSString *)imageName title:(NSString *)title target:(id)target action:(SEL)action;

/**
 通过一张图片与文字返回一个UIBarButtonItem

 @param imageName 图片名字
 @param title 标题
 @param color 标题颜色
 @param target 目标
 @param action 事件
 @return <#return value description#>
 */
+ (instancetype)itemWithImageName:(NSString *)imageName title:(NSString *)title titleColor:(UIColor *) color  target:(id)target action:(SEL)action;

@end
