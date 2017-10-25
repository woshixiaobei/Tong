//
//  NSString+NormalTool.h
//  HeXun-zixuan
//
//  Created by 范名扬 on 16/9/2.
//  Copyright © 2016年 com.hztc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (NormalTool)

/**剪切区间字符串
 * 去掉form到to之间的字符串
 */
- (NSString *)deleteShortStringFrom:(NSString *)from
                                 to:(NSString *)to;
/**删除某一字符串
 *
 */
- (NSString *)deleteSomeString:(NSString *)deletedString;
/**是否存在区间字符串
 * 是否存在form到to之间的区间字符串
 */
- (BOOL)isExistStringFrom:(NSString *)from
                       to:(NSString *)to;
/**截取某字符串的前后部分
 * 根据 relatedString 分段
 */
- (NSArray *)partStringWithRelatedString:(NSString *)relatedString;

/**获取某字符串之前部分
 * 根据 relatedString 分段
 */
- (NSString *)substringToRelatedString:(NSString *)relatedSting;

/**绘制区间文本(利用drawRect方法中的自动换行)
 * 在区间绘制文本
 */
- (void)drawTextWithRect:(CGRect)rect
               textColor:(int)textColor
               alignment:(NSTextAlignment )alignment
                textFont:(CGFloat)textFont;
/**绘制区间文本(可以水平居中又可以垂直居中,但是不能自动换行)
 * 在区间绘制文本
 */
- (void)drawNewTextWithRect:(CGRect)rect
                  textColor:(int)textColor
                  alignment:(NSTextAlignment )alignment
                   textFont:(CGFloat)textFont;
/**绘制区间背景
 *
 */
- (void)drawTextWithRect:(CGRect)rect
               bgColor:(int)bgColor;

/**返回文本尺寸
 * 
 */
- (CGSize)sizeWithLimitedWidth:(CGFloat)limitedWidth
                      withFont:(UIFont *)font;
/**返回文本尺寸(根据行间距)
 *
 */
- (CGSize)sizeLineSpacingWithLimitedWidth:(CGFloat)limitedWidth
                                 withFont:(UIFont *)font
                            withLineSpace:(CGFloat)lineSpace;
/**动态返回文本所占高度
 *
 */
- (CGFloat)heightWithLimitedWidth:(CGFloat)limitedWidth
                         withFont:(UIFont *)font;
/**动态返回文本所占高度(根据行间距)
 *
 */
- (CGFloat)heightLineSpacingWithLimitedWidth:(CGFloat)limitedWidth
                                    withFont:(UIFont *)font
                               withLineSpace:(CGFloat)lineSpace;

/**返回设定行间距后字符串
 *
 */
- (NSAttributedString *)attributedStringLimitedWidth:(CGFloat)limitedWidth
                                            withFont:(UIFont *)font
                                       withLineSpace:(CGFloat)lineSpace;


/**十六进制字符转十进制数
 * 字符串为1、2、3、4、5、6、7、8、9、a、b、c、d、e、f
 */
- (int)getTenDecimalNum;


/**
 * 根据宽度自适应字体
 */
- (CGFloat)getFontSizeWithLimitedWidth:(CGFloat)limitedWidth;
/**
 * 根据宽度自适应字体,且有最大字体限制
 * limitedFontSize: 最大限制字体大小
 * 此处计算字体要考虑draw和控件使用的区别。drawRect中是先计算大小然后在根据ppi去渲染；而控件中是渲染后的所以如果控件调用此方法必须传入的宽度为像素宽度(即pt分辨率乘上缩放系数)。
 */
- (CGFloat)getFontSizeWithLimitedWidth:(CGFloat)limitedWidth
                       limitedFontSize:(CGFloat)limitedFontSize;

@end
