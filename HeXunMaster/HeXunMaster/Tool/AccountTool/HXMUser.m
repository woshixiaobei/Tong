//
//  HXMUser.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/15.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMUser.h"

@implementation HXMUser

MJExtensionCodingImplementation

- (NSString *)photoPathWithSize:(NSInteger)width {
    if (width < 40) {
        width = 40;
    }
    
    NSString *photoUrl = self.photo;
    if ([photoUrl rangeOfString:@"-40"].length > 0) {
        NSRange range = [photoUrl rangeOfString:@"-40.jpg"];
        NSString *newPhotoSize = [NSString stringWithFormat:@"-%ld.jpg", width];
        photoUrl = [photoUrl stringByReplacingCharactersInRange:range withString:newPhotoSize];
        return photoUrl;
    }
    return nil;
}
@end
