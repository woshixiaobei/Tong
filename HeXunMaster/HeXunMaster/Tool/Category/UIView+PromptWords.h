//
//  UIView+PromptWords.h
//
//  Created by Zl on 2017/3/13.
//  Copyright © 2017年 Zl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PromptWords)


//  提示信息
- (void)showPromptWords:(NSString *) Message;

//  移除
- (void)removePromptWords;

//  文字和显示位置-返回一自定义视图
+ (UIView*)getPromptWordsWithTitle:(NSString*) title Font:(CGFloat) font TextColor:(UIColor*) color Frame:(CGRect) frame;


@end
