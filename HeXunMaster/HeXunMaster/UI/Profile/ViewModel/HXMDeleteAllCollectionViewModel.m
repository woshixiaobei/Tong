//
//  HXMDeleteAllCollectionViewModel.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/5/10.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMDeleteAllCollectionViewModel.h"
#import "HXHttpHelper.h"
#import "HXHttpHelper+HXMaster.h"
#import "AccountTool.h"

@interface HXMDeleteAllCollectionViewModel()
@property (nonatomic, strong)RACSignal *requestDeleAllSignal;
@end
@implementation HXMDeleteAllCollectionViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (RACSignal *)requestDeleAllSignal {
    
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSString *userName = [AccountTool userInfo].username;
        NSURLSessionTask *task = [HXHttpHelper api_getDeleteAllCollectionNewsListRequestWithUserMobile:userName success:^(id responseObject) {
            
            if ([responseObject[@"state"]integerValue]== 0) {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            } else {
                
                [subscriber sendError:[NSError errorWithDomain:@"" code:0 userInfo:@{@"userinfo": [NSString stringWithFormat:@"state: %@ error: %@", responseObject[@"state"], responseObject[@"message"]]}]];
            }
            
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            if (task.state != NSURLSessionTaskStateCompleted) {
                [task cancel];
            }
        }];
    }] map:^id(id value) {
        return value;
    }];
    
}

@end
