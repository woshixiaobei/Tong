//
//  FileTool.h
//  TrainingClient
//
//  Created by 蔡建海 on 16/5/11.
//  Copyright © 2016年 HeXun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileTool : NSObject

// 删除沙盒里的文件
+(void)deleteFileIfExist:(NSString *)filePath;

// 判断文件是否存在
+(BOOL)isFileExist:(NSString *)filePath;

// 获取document路径
+ (NSURL *)documentPath;
@end
