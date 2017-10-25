//
//  HXMCompanyResearchReportViewModel.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/5/22.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMCompanyResearchReportViewModel.h"
#import "HXHttpHelper.h"
#import "HXMCompanyResearchModel.h"

@interface HXMCompanyResearchReportViewModel()

@property (nonatomic, strong) RACSignal *requestCompanyResearchSignal;
@property (nonatomic, strong) HXMCompanyResearchModel *model;
@end
@implementation HXMCompanyResearchReportViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (RACSignal *)requestCompanyResearchSignal {
    @weakify(self)
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        //公司编号
        NSString *companyCode = [AccountTool userInfo].company_code;
       NSURLSessionTask *task = [HXHttpHelper api_getCompanyResearchReportRequestWithWithCompany_code:companyCode module_id:self.params[@"module_id"] type_id:self.params[@"type_id"] reportType:self.params[@"reportType"] pageNum:self.params[@"pageNum"] pageSize:@(10).description success:^(id responseObject) {
           
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
        self.model = [HXMCompanyResearchModel mj_objectWithKeyValues:value];
        return self.model;
    }];
}

- (NSMutableDictionary *)params {

    if (_params == nil) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}
- (HXMCompanyResearchModel *)model {

    if (_model == nil) {
        _model = [[HXMCompanyResearchModel alloc]init];
    }
    return _model;
}
@end
