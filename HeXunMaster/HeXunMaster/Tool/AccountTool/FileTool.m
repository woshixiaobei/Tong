//
//  FileTool.m
//  TrainingClient
//
//  Created by 蔡建海 on 16/5/11.
//  Copyright © 2016年 HeXun. All rights reserved.
//

#import "FileTool.h"

@implementation FileTool


// 删除沙盒里的文件
+(void)deleteFileIfExist:(NSString *)filePath
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    
    BOOL blHave=[fileManager fileExistsAtPath:filePath];
    if (blHave) {
        BOOL blDele= [fileManager removeItemAtPath:filePath error:nil];
        if (blDele) {
            NSLog(@"删除指定路径文件: %@",filePath);
        }
    }
}

// 判断文件是否存在
+(BOOL)isFileExist:(NSString *)filePath
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

// 获取document路径
+ (NSURL *)documentPath
{
    return [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];

}

@end
