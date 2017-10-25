//
//  NSString+Extend.h
//  重写QQ聊天2
//
//  Created by Dong on 14-6-8.
//  Copyright (c) 2014年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extend)


/**
 *  计算文字尺寸
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithfont:(UIFont *)font maxSize:(CGSize)maxSize;
/** 计算文字尺寸 */
- (CGSize)sizeWithfont:(UIFont *)font;

// 将多个空格合并为一个
- (NSString *)combineMoreSpaceForOnce;


/**
 *  @brief 字符长度限制
 *
 *  @param charLength 字符
 *
 *  @return 返回xxxx...
 */
- (NSString *)charLengthRestriction:(NSUInteger)charLength;
/**
 *  @brief 字符长度限制
 *
 *  @param charLength 字符
 *
 *  @return 返回xxxx
 */
- (NSString *)charLengthRestrictionWithOutDots:(NSUInteger)charLength;

/**
 *  @brief 计算字符长度
 *
 */
- (NSUInteger)computeCharLength;

/**
 *  @brief string(包括 HTML) 转富文本 
 */
- (NSAttributedString *)attributedString;

/*
 去掉换行和空白符
 */
- (NSString *)ReplacingNewLineAndWhitespaceCharactersFromJson;

/**
 *  @author wu.zhe, 2017-05-23
 *
 *  @brief 替换显示股票名称 隐藏代码
 *
 *  @return
 */
- (NSString *)replaceStock;

/*
 * 字符串转换为单个字符的字符串数组。
 *   @"test"   输出为  [@"t", @"e", @"s", @"t"]
 */
- (NSArray *)separateWithChar;


@end
