//
//  NSString+Extend.m
//  重写QQ聊天2
//
//  Created by Dong on 14-6-8.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "NSString+Extend.h"
@implementation NSString (Extend)


/**
 *  计算文字尺寸
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithfont:(UIFont *)font maxSize:(CGSize)maxSize
{
    // 接受文字字体转化为字典类型
    NSDictionary *attrs = @{NSFontAttributeName : font};
    // 利用IOS7之后提供的最新方法计算字符串所占Size 并返回
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
-(CGSize)sizeWithfont:(UIFont *)font{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self sizeWithAttributes:attrs];
}

// 将多个空格合并为一个
- (NSString *)combineMoreSpaceForOnce
{
    //正则表达式替换两个以上的空格为一个空格
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\s{2,}" options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray *arr = [regex matchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, [self length])];
    
    arr = [[arr reverseObjectEnumerator] allObjects];
    
    NSString *strResult = self;
    
    for (NSTextCheckingResult *str in arr) {
        strResult = [strResult stringByReplacingCharactersInRange:[str range] withString:@" "]; }
    
    return strResult;
}

- (NSString *)charLengthRestriction:(NSUInteger)charLength
{
    if ([self computeCharLength] <= charLength) {
        return self;
    }
    return [[self charLengthRestrictionWithOutDots:charLength] stringByAppendingString:@"..."];
}

- (NSString *)charLengthRestrictionWithOutDots:(NSUInteger)charLength
{
    if ([self computeCharLength] <= charLength) {
        return self;
    }
    NSInteger clength = charLength;
    NSUInteger rangeLength = 0;
    for (NSUInteger i = 0; i < self.length; i++) {
        
        clength -= [[self substringWithRange:NSMakeRange(i, 1)] computeCharLength];
        if (clength>=0) {
            rangeLength = i + 1;
        }else{
            break;
        }
    }
    return [self substringWithRange:NSMakeRange(0, rangeLength)];
}





- (NSUInteger)computeCharLength
{
    if (!self.length)return 0;
    NSUInteger strLength = 0;
    NSString *tmp = @"";
    for (NSUInteger i = 0 ; i < self.length; i++) {
        NSString *a = [self substringWithRange:NSMakeRange(i, 1)];
        if ([a _isChinese]) {
            strLength += 2;
        }else{
            tmp = [tmp stringByAppendingString:a];
        }
    }
    if (tmp.length) {
        strLength += [tmp _lengthWithOutChinese];
    }
    return strLength;
}

- (BOOL)_isDoubleByte
{
    return [self matchesRegex:@"[^x00-xff]" options:NSRegularExpressionDotMatchesLineSeparators];//双字节字符
}

- (BOOL)_isChinese
{
    return [self matchesRegex:@"[\u4E00-\u9FA5]+" options:NSRegularExpressionDotMatchesLineSeparators];// 汉字
}

- (NSUInteger)_lengthWithOutChinese
{
    if (!self.length) return 0;
    NSUInteger strLength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    NSUInteger len = [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding];
    for (NSUInteger i = 0; i < len; i++) {
        @try {
            if (*p) {
                strLength += sizeof(*p);
            }
        } @catch (NSException *exception) {
            if (*p) {
                strLength += 1;
            }
        }
        p++;
    }
    return strLength;
}
/**
- (NSUInteger)computeCharLength
{
    if (!self.length) return 0;
    
    int strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    NSUInteger len = [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding];
    
//    HXLog(@" oc length... ... ...%i", self.length);
//    HXLog(@" c length. ... ...%i", ( long)len);
    
    for (NSUInteger i=0 ; i<len ;i++) {
        @try {
            
            // *p = 0  p++
            if (*p) {
                
                strlength++;
            }
            // 汉字"一" 单独排除  正常汉字编码为 0xXX 0xXX
            // 一 的编码 \0 0x4e
            else if (*p == 0 && (*(p+1)) == 78 && i%2 == 0 ){
                
                strlength++;
            }
            else if (*p == 0  && i%2 == 0 ){
                
#if DEBUG || ADHOC
                NSString *str = [NSString stringWithFormat:@"计算长度 奇数位为0 catch ascii %li ", (long)*p];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:str message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [alert show];
#endif
            }

        } @catch (NSException *exception) {
            
#if DEBUG || ADHOC
            NSString *str = [NSString stringWithFormat:@"计算长度 catch ascii %li ", (long)*p];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:str message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
#endif

            strlength++;
        }
        
        p++;
    }
    return strlength;
}
*/



- (NSAttributedString *)attributedString
{
//    YYAssertMainThread();
    __block id att = nil;
    NSString *replaceStock = [self replaceStock];
    if (self.isNotBlank) {
        NSData *data = [replaceStock dataUsingEncoding:NSUTF16StringEncoding];
        if (data) {
            @try {
                dispatch_sync_on_main_queue(^{
                    att = [[NSAttributedString alloc] initWithData:data options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType}  documentAttributes:NULL error:NULL];
                });
#if __has_include(<tingyunApp/NBSAppAgent.h>)
                if ([NSThread isMainThread]) {
                    [NBSAppAgent setCustomerData:self forKey:@"attOnMainThread"];
                }else{
                    [NBSAppAgent setCustomerData:self forKey:@"attNoOnMainThread"];
                }
#endif
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
            }
        }
    }
    return att;
}

- (NSString *)replaceStock
{
    if (!self.isNotBlank)return nil;
    NSArray<NSTextCheckingResult *> *replaceInfos = [[NSString _regexStockInfo] matchesInString:self options:kNilOptions range:self.rangeOfAll];
    if (replaceInfos.count) {
        NSTextCheckingResult *result = replaceInfos.firstObject;
        NSString *replaceInfo = [self substringWithRange:result.range];
        if (result.range.length) {
            NSArray<NSTextCheckingResult *> *replaceNames = [[NSString _regexStockName] matchesInString:replaceInfo options:kNilOptions range:replaceInfo.rangeOfAll];
            if (replaceNames.count) {
                NSTextCheckingResult *resultN = replaceNames.firstObject;
                if (resultN.range.length) {
                     NSString *stockName = [replaceInfo substringWithRange:NSMakeRange(resultN.range.location + 1, resultN.range.length - 2)];
                    return [self stringByReplacingRegex:@"\\[stock\\s*code\\=[0-9]\\d*+\\][\\**-_a-zA-Z0-9\u4E00-\u9FA5]+\\[\\/stock\\]" options:NSRegularExpressionCaseInsensitive withString:stockName];
                }
            }
        }
    }
    return self;
}


+ (NSRegularExpression *)_regexStockInfo{
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\[stock\\s*code\\=[0-9]\\d*+\\][\\**-_a-zA-Z0-9\u4E00-\u9FA5]+\\[\\/stock\\]" options:kNilOptions error:NULL];
    });
    return regex;
}
+ (NSRegularExpression *)_regexStockName{
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\][\\**-_a-zA-Z0-9\u4E00-\u9FA5]+\\[" options:kNilOptions error:NULL];
    });
    return regex;
}



- (NSString *)ReplacingNewLineAndWhitespaceCharactersFromJson{
    NSScanner *scanner = [[NSScanner alloc] initWithString:self];
    [scanner setCharactersToBeSkipped:nil];
    NSMutableString *result = [[NSMutableString alloc] init];
    
    NSString *temp;
    NSCharacterSet*newLineAndWhitespaceCharacters = [NSCharacterSet newlineCharacterSet];
    // 扫描
    while (![scanner isAtEnd])
    {
        temp = nil;
        [scanner scanUpToCharactersFromSet:newLineAndWhitespaceCharacters intoString:&temp];
        if (temp) [result appendString:temp];
        
        // 替换换行符
        if ([scanner scanCharactersFromSet:newLineAndWhitespaceCharacters intoString:NULL]) {
            if (result.length > 0 && ![scanner isAtEnd]){} // Dont append space to beginning or end of result
            //          {}      [result appendString:@"\n"];
        }
    }
    return result;
}

- (NSArray *)separateWithChar
{
    NSMutableArray *result = [[NSMutableArray alloc]initWithCapacity:9];
    for (NSUInteger i = 0; i < self.length; i++) {
        unichar c = [self characterAtIndex:i];
        NSString *cString = [NSString stringWithFormat:@"%c", c];
        [result addObject:cString];
    }
    return [NSArray arrayWithArray:result];
}
@end
