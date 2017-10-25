//
//  HXMCollectionViewModel.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/5/2.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMCollectionViewModel.h"
#import "HXHttpHelper.h"
#import "AccountTool.h"
#import "HXMDetailNewsCellModel.h"

@interface HXMCollectionViewModel()
@property (nonatomic, strong)RACSignal *requestCollectionNewsListSignal;
@end
@implementation HXMCollectionViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
       // [self initBind];
    }
    return self;
}
- (RACSignal *)requestCollectionNewsListSignal {
    
    @weakify(self)
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        @strongify(self)
        //电话号码
        NSString *userMobile = [AccountTool userInfo].username;
        NSURLSessionTask *task = [HXHttpHelper api_getCollectionNewsListRequestWithUserMobile:userMobile pageNum:self.params[@"pageNum"] pageSize:10 success:^(id responseObject) {
            
            if ([responseObject[@"state"] integerValue] == 0) {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
                
            }else {
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
        @strongify(self)
        return [HXMDetailNewsCellModel mj_objectArrayWithKeyValuesArray:value[@"data"]];
    }];
    
}
#pragma -mark 频道
-(NSMutableDictionary *)params {
    if (_params == nil) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}


@end
