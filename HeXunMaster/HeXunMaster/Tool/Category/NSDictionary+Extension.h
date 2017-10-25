//
//  NSDictionary+Extension.h
//  TrainingClient
//
//  Created by 李帅 on 16/1/25.
//  Copyright © 2016年 HeXun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extension)

/**
 *  JSON字符串转成Dictionary
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
