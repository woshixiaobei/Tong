//
//  UIView+PromptWords.m
//
//  Created by Zl on 2017/3/13.
//  Copyright © 2017年 Zl. All rights reserved.
//

#import "UIView+PromptWords.h"
#import "UIView+Extension.h"

@implementation UIView (PromptWords)\


//  提示信息
- (void)showPromptWords:(NSString *) Message{
    
    UILabel *textLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 50)];
    textLable.tag = 99901;
    textLable.text = Message;
    textLable.numberOfLines = 0;
    textLable.font = [UIFont systemFontOfSize:17.f];
    textLable.textAlignment = NSTextAlignmentCenter;
    textLable.textColor = [UIColor colorWithHexString:@"3c5c8e"];
    textLable.center = self.center;
    textLable.y = self.bounds.size.height/2 - 49 - 64;
    [self addSubview:textLable];
}

//  移除
- (void)removePromptWords{
    for (UIView *subView in self.subviews) {
        if (subView.tag == 99901) {
            [subView removeFromSuperview];
        }
    }
}

//  自定义
+ (UIView*)getPromptWordsWithTitle:(NSString*) title Font:(CGFloat) font TextColor:(UIColor*) color Frame:(CGRect) frame{
    UILabel *textLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 300)];
    textLable.text = title;
    textLable.numberOfLines = 0;
    textLable.font = [UIFont systemFontOfSize:font];
    textLable.textAlignment = NSTextAlignmentCenter;
    textLable.textColor = color;
    UIView *PromptView = [[UIView alloc]initWithFrame:frame];
    textLable.center = PromptView.center;
    [PromptView addSubview:textLable];
    return PromptView;
}



@end
