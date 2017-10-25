//
//  NSString+NormalTool.m
//  HeXun-zixuan
//
//  Created by 范名扬 on 16/9/2.
//  Copyright © 2016年 com.hztc. All rights reserved.
//

#import "NSString+NormalTool.h"

@implementation NSString (NormalTool)

- (NSString *)deleteShortStringFrom:(NSString *)from to:(NSString *)to
{
    NSString *tempString = [self copy];
    
    while ([tempString isExistStringFrom:from to:to]) {
        NSRange fromRange = [tempString rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:from]];
        NSRange toRange = [tempString rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:to]];
        
        NSString *preStr = [tempString substringToIndex:fromRange.location];
        NSString *sufStr = [tempString substringFromIndex:toRange.location + 1];
        tempString = [preStr stringByAppendingString:sufStr];
    }
    
    return tempString;
}

- (NSString *)deleteSomeString:(NSString *)deletedString
{
    NSString *tempString = [self copy];
    
    while ([tempString containsString:deletedString]) {
        NSRange fromRange = [tempString rangeOfString:deletedString];
        
        NSString *preStr = [tempString substringToIndex:fromRange.location];
        NSString *sufStr = [tempString substringFromIndex:fromRange.location + fromRange.length];
        tempString = [preStr stringByAppendingString:sufStr];
    }
    
    return tempString;
}

//是否存在区间字符串
- (BOOL)isExistStringFrom:(NSString *)from to:(NSString *)to
{
    BOOL isExist = NO;
    
    NSRange fromRange = [self rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:from]];
    NSRange toRange = [self rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:to]];
    
    if (fromRange.length > 0 && toRange.length > 0 && fromRange.location < toRange.location) {
        isExist = YES;
    }
    
    return isExist;
}

//截取某字符串的前后部分
- (NSArray *)partStringWithRelatedString:(NSString *)relatedString
{
    NSMutableArray *pPartArray = [NSMutableArray array];
    NSString *pTempString = [self copy];
    
    while ([pTempString containsString:relatedString]) {
        NSRange strRange = [pTempString rangeOfString:relatedString];
        [pPartArray addObject:[pTempString substringToIndex:strRange.location]];
        pTempString = [pTempString substringFromIndex:strRange.location + 1];
    }
    [pPartArray addObject:pTempString];
    
    return pPartArray;
}

- (NSString *)substringToRelatedString:(NSString *)relatedSting
{
    NSString *temp = nil;
    NSInteger nIndex = [self rangeOfString:relatedSting].location;
    temp = [self substringToIndex:nIndex];
    
    return temp;
}

//在区间内绘制文本
- (void)drawTextWithRect:(CGRect)rect
               textColor:(int)textColor
               alignment:(NSTextAlignment )alignment
                textFont:(CGFloat)textFont
{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = alignment;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:textFont], NSFontAttributeName,paragraphStyle, NSParagraphStyleAttributeName, [UIColor redColor].CGColor, NSForegroundColorAttributeName, nil];
    //此方法绘制的文本可以自动换行，但是只可水平居中，不能竖直居中。
    [self drawInRect:rect withAttributes:dict];
}

- (void)drawNewTextWithRect:(CGRect)rect
                  textColor:(int)textColor
                  alignment:(NSTextAlignment )alignment
                   textFont:(CGFloat)textFont
{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = alignment;
    UIFont *newFont = [UIFont systemFontOfSize:textFont];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:newFont, NSFontAttributeName,paragraphStyle, NSParagraphStyleAttributeName, [UIColor redColor].CGColor, NSForegroundColorAttributeName, nil];
    //添加垂直居中 //只能绘制1行
    rect.origin.y += (rect.size.height - newFont.pointSize + newFont.descender)/2;
    rect.size.height = newFont.pointSize;
    //以为文本区间不够自动换行
    [self drawInRect:rect withAttributes:dict];
}

- (void)drawTextWithRect:(CGRect)rect
                 bgColor:(int)bgColor
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor], NSBackgroundColorAttributeName, nil];
    //此方法绘制的文本可以自动换行，但是只可水平居中，不能竖直居中。
    [self drawInRect:rect withAttributes:dict];
}

//动态返回文本所占尺寸
- (CGSize)sizeWithLimitedWidth:(CGFloat)limitedWidth withFont:(UIFont *)font
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGSize constraintedSize = CGSizeMake(limitedWidth, MAXFLOAT);
    CGRect newRect = [self boundingRectWithSize:constraintedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    return newRect.size;
}
//由行间距动态返回文本所占尺寸
- (CGSize)sizeLineSpacingWithLimitedWidth:(CGFloat)limitedWidth
                                 withFont:(UIFont *)font
                            withLineSpace:(CGFloat)lineSpace
{
    NSParagraphStyle *paragraphStyle = [self paragraphStyleWithWidth:limitedWidth withFont:font withLineSpace:lineSpace];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
    CGSize constraintedSize = CGSizeMake(limitedWidth, MAXFLOAT);
    CGRect newRect = [self boundingRectWithSize:constraintedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    
    return newRect.size;
}
- (CGFloat)heightLineSpacingWithLimitedWidth:(CGFloat)limitedWidth
                                    withFont:(UIFont *)font
                               withLineSpace:(CGFloat)lineSpace
{
    CGSize size = [self sizeLineSpacingWithLimitedWidth:limitedWidth withFont:font withLineSpace:lineSpace];
    
    return size.height;
}
//返回指定行间距后的NSAttributedString
- (NSAttributedString *)attributedStringLimitedWidth:(CGFloat)limitedWidth
                                            withFont:(UIFont *)font
                                       withLineSpace:(CGFloat)lineSpace
{
    NSParagraphStyle *paragraphStyle = [self paragraphStyleWithWidth:limitedWidth withFont:font withLineSpace:lineSpace];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, paragraphStyle, NSParagraphStyleAttributeName, nil];
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:self attributes:dict];
    
    return attributeStr;
}
//返回一个指定的NSParagraphStyle
- (NSParagraphStyle *)paragraphStyleWithWidth:(CGFloat)limitedWidth
                                     withFont:(UIFont *)font
                                withLineSpace:(CGFloat)lineSpace
{
    NSString *temp = [self copy];
    NSMutableParagraphStyle *pParaStyle = [[NSMutableParagraphStyle alloc] init];

    //一行的高
    CGSize standsize = [@"" sizeWithAttributes:@{NSFontAttributeName:font}];
    CGSize size = [temp boundingRectWithSize:CGSizeMake(limitedWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    //只有一行不设置行高
    if (size.height > standsize.height) {//多行设置行高
        pParaStyle.lineSpacing = lineSpace;
        pParaStyle.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    return pParaStyle;
}

//动态返回文本所占高度
- (CGFloat)heightWithLimitedWidth:(CGFloat)limitedWidth withFont:(UIFont *)font
{
    CGSize size = [self sizeWithLimitedWidth:limitedWidth withFont:font];
    
    return size.height;
}


- (int)getTenDecimalNum
{
    int nNum = -1;
    if ([self isEqual:@"0"]) {
        nNum = 0;
    }else if ([self isEqual:@"1"]) {
        nNum = 1;
    }else if ([self isEqual:@"2"]) {
        nNum = 2;
    }else if ([self isEqual:@"3"]) {
        nNum = 3;
    }else if ([self isEqual:@"4"]) {
        nNum = 4;
    }else if ([self isEqual:@"5"]) {
        nNum = 5;
    }else if ([self isEqual:@"6"]) {
        nNum = 6;
    }else if ([self isEqual:@"7"]) {
        nNum = 7;
    }else if ([self isEqual:@"8"]) {
        nNum = 8;
    }else if ([self isEqual:@"9"]) {
        nNum = 9;
    }else if ([self isEqual:@"a"] || [self isEqual:@"A"]) {
        nNum = 10;
    }else if ([self isEqual:@"b"] || [self isEqual:@"B"]) {
        nNum = 11;
    }else if ([self isEqual:@"c"] || [self isEqual:@"C"]) {
        nNum = 12;
    }else if ([self isEqual:@"d"] || [self isEqual:@"D"]) {
        nNum = 13;
    }else if ([self isEqual:@"e"] || [self isEqual:@"E"]) {
        nNum = 14;
    }else if ([self isEqual:@"f"] || [self isEqual:@"F"]) {
        nNum = 15;
    }
    
    return nNum;
}


- (CGFloat)getFontSizeWithLimitedWidth:(CGFloat)limitedWidth
{
    int nLength = (int)self.length;
    CGFloat nFontSize = limitedWidth/nLength;
    return nFontSize;
}
- (CGFloat)getFontSizeWithLimitedWidth:(CGFloat)limitedWidth
                       limitedFontSize:(CGFloat)limitedFontSize
{
    CGFloat fontSize = [self getFontSizeWithLimitedWidth:limitedWidth];
    if (fontSize > limitedFontSize) {
        return limitedFontSize;
    }
    return fontSize;
}


@end
