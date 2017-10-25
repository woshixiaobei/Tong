//
//  HXMSimilarNewsViewModel.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/4/24.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMSimilarNewsViewModel.h"
#import "AccountTool.h"
#import "HXMDetailNewsCellModel.h"

@interface HXMSimilarNewsViewModel()
@property (nonatomic, strong)RACSignal *requestSimilarNewsListSignal;

@end
@implementation HXMSimilarNewsViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (RACSignal *)requestSimilarNewsListSignal {

    @weakify(self)
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //公司编号
        @strongify(self)
        NSString *companyCode = [AccountTool userInfo].company_code;
        NSURLSessionTask *task = [HXHttpHelper api_getSimilarNewsListRequestWithCompany_code:companyCode module_id:self.params[@"module_id"] news_id:self.params[@"news_id"] pageId:self.params[@"id"] numCount:@(10).description success:^(id responseObject) {
            
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
//        self.newsListArray = [HXMDetailNewsCellModel mj_objectArrayWithKeyValuesArray:value[@"news"]];
        return value;
        
    }];

}
#pragma -mark 频道

- (NSArray *)newsListArray {
    
    if (_newsListArray == nil) {
        _newsListArray = [NSArray new];
    }
    return _newsListArray;
}


@end
