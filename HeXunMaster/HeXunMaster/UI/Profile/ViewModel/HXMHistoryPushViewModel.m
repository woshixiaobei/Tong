//
//  HXMHistoryPushViewModel.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/5/9.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMHistoryPushViewModel.h"
#import "HXHttpHelper.h"
#import "AccountTool.h"
#import "HXMHomeListModel.h"
@interface HXMHistoryPushViewModel()
@property (nonatomic, strong)RACSignal *requestHistoryPushSignal;

@end
@implementation HXMHistoryPushViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (RACSignal *)requestHistoryPushSignal {
    
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSString *userName = [AccountTool userInfo].username;
        NSURLSessionTask *task = [HXHttpHelper api_getHistroyPushNewsListRequestWithUserMobile:userName last:self.params[@"last"] success:^(id responseObject) {
            
            if ([responseObject[@"state"]integerValue] == 0) {
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
    }]map:^id(id value) {
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
