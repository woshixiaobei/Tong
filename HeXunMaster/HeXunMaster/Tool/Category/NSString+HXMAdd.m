//
//  NSString+HXMAdd.m
//
//  Created by wangmingzhu on 2017/3/20.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "NSString+HXMAdd.h"

@implementation NSString (HXMAdd)

-(CGFloat)textHeightWithWidth:(CGFloat)width Font:(UIFont *)font{
    
    if ([self isEqualToString:@""] || self == nil) return 0;
    CGSize stringSize = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName:font}
                                           context:nil].size;
    return stringSize.height;
}

-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize{
    if ([self isEqualToString:@""] || self == nil) return CGSizeZero;
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
