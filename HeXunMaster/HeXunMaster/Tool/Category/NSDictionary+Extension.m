//
//  NSDictionary+Extension.m
//  TrainingClient
//
//  Created by 李帅 on 16/1/25.
//  Copyright © 2016年 HeXun. All rights reserved.
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)

// JSON字符串转成Dictionary
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&err];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
