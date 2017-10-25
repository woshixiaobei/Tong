//
//  HXMCancleCollectionNewsDetailViewModel.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/6/1.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMCancleCollectionNewsDetailViewModel.h"
#import "HXHttpHelper.h"

@interface HXMCancleCollectionNewsDetailViewModel()
@property (nonatomic, strong)RACSignal *cancleCollectionNewsSignal;


@end

@implementation HXMCancleCollectionNewsDetailViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        //      self.params = [NSMutableDictionary dictionary];
    }
    return self;
}
- (RACSignal *)cancleCollectionNewsSignal {
    
    NSString *userName = [AccountTool userInfo].username;
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSURLSessionTask *task = [HXHttpHelper api_getCancleCollectionNewsDetailRequestWithUserMobile:userName newsId:self.params[@"newsId"] moduleId:self.params[@"moduleId"] success:^(id responseObject) {
            
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

- (NSMutableDictionary *)params {
    if (_params == nil) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}
@end
