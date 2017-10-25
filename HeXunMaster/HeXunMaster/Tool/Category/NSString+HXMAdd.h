//
//  NSString+HXMAdd.h
//
//  Created by wangmingzhu on 2017/3/20.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (HXMAdd)


-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

-(CGFloat)textHeightWithWidth:(CGFloat)width Font:(UIFont *)font;

@end
