//
//  HXMTotalVolumeNewsViewModel.m
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/7/24.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMTotalVolumeNewsViewModel.h"
#import "HXHttpHelper.h"
#import "HXMDetailNewsCellModel.h"

@implementation HXMTotalVolumeNewsViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initBind];
    }
    return self;
}

- (void)initBind {
     NSString *companyCode = [AccountTool userInfo].company_code;
     self.requestTotalVolumeNewsCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
       
        return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSURLSessionTask *task = [HXHttpHelper api_getPositiveAndNegativeNewsModuleRequestWithCompanyCode:companyCode module_id:self.params[@"module_id"] positive:self.params[@"positive"] next_id:self.params[@"id"] success:^(id responseObject) {
             
                if ([responseObject[@"state"] integerValue] == 0) {
                    [subscriber sendNext:responseObject];
                    [subscriber sendCompleted];
                } else {
                    [subscriber sendError:[NSError errorWithDomain:@"" code:0 userInfo:@{@"userinfo": [NSString stringWithFormat:@"state: %@ error: %@", responseObject[@"state"], responseObject[@"message"]]}]];
                }
            } failure:^(NSError *error) {
                
            }];
            return [RACDisposable disposableWithBlock:^{
                if (task.state != NSURLSessionTaskStateCompleted) {
                    [task cancel];
                }
            }];
        }]map:^id(id value) {
            self.model = [HXMNewsModuleModel mj_objectWithKeyValues:value];
            self.newsListArray = [HXMDetailNewsCellModel mj_objectArrayWithKeyValuesArray:value[@"news"]];
            return self.model;
        }];
    }];
}
@end
