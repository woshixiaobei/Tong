//
//  HXMAnalysisChartViewModel.m
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/7/20.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMAnalysisChartViewModel.h"
#import "HXHttpHelper.h"

@interface HXMAnalysisChartViewModel()
@property (nonatomic, strong) NSDictionary *responseData;//返回数据

@end
@implementation HXMAnalysisChartViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initBind];
    }
    return self;
}

- (void)initBind {
    @weakify(self)
    self.requestAnalysisChartNewsCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        @strongify(self)
        //公司编号
        NSString *companyCode = [AccountTool userInfo].company_code;
        return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [HXHttpHelper api_getOpinonAnalysisChartModuleRequestWithCompanyCode:companyCode module_id:@"58" success:^(id responseObject) {

                if ([responseObject[@"state"]integerValue] == 0) {
                    self.responseData = responseObject[@"statData"];
                    [subscriber sendNext:self.responseData];
                    [subscriber sendCompleted];
                }
                
            } failure:^(NSError *error) {
                [subscriber sendError:error];
            }];
            return [RACDisposable disposableWithBlock:^{
                //NSLog(@"%s disposable",__func__);
            }];
        }]map:^id(id value) {
            @strongify(self)
            return self.responseData;
        }];
        
    }];
}

@end
