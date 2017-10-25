//
//  HXMNewsListViewModel.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/31.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMNewsListViewModel.h"
#import "AccountTool.h"
#import "HXMCommonModuleModel.h"
#import "HXMnewsTypeModel.h"
#import "HXMDetailNewsCellModel.h"
#import "HXMNewsModuleModel.h"

@interface HXMNewsListViewModel ()

@property (nonatomic, strong) RACSignal *requestNewsListSignal;
@end

@implementation HXMNewsListViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (RACSignal *)requestNewsListSignal {
    @weakify(self)
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        //公司编号
        NSString *companyCode = [AccountTool userInfo].company_code;
        NSString *userMobile = [AccountTool userInfo].username;
        
        NSURLSessionTask *task = [HXHttpHelper api_getNewsListRequestWithCompany_code:companyCode userMobile:userMobile module_id:self.params[@"module_id"] type_id:self.params[@"type_id"] pageId:self.params[@"id"]  numCount:@(10).description success:^(id responseObject) {
            NSLog(@"%@",responseObject);
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
        self.model = [HXMNewsModuleModel mj_objectWithKeyValues:value];
        self.newsListArray = [HXMDetailNewsCellModel mj_objectArrayWithKeyValuesArray:value[@"news"]];
        return self.model;
        
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
