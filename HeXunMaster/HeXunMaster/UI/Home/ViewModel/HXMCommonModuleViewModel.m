//
//  HXMCommonModuleViewModel.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/27.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMCommonModuleViewModel.h"
#import "HXMAllCommonModel.h"
#import "AccountTool.h"

@interface HXMCommonModuleViewModel()
@property (nonatomic, strong) NSArray *featureDataArray;
@property (nonatomic, strong) NSArray *intelligenceDataArray;
@property (nonatomic, strong) NSArray *newsDataArray;

@end

@implementation HXMCommonModuleViewModel

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
    _requestCommonListCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        NSString *username = [AccountTool userInfo].username;
        @strongify(self)
        return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [HXHttpHelper api_getCommonModuleRequestWithUsername:username success:^(id responseObject) {
               
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
                
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
                [subscriber sendError:error];
            }];
            return [RACDisposable disposableWithBlock:^{
            }];
        }] map:^id(id value) {
            self.dataListArray = [NSMutableArray array];
            @strongify(self)
            if ([value[@"state"] intValue] == 0) {
                
                self.newsDataArray = [HXMCommonModuleModel mj_objectArrayWithKeyValuesArray:value[@"news_module"]];
                self.intelligenceDataArray = [HXMCommonModuleModel mj_objectArrayWithKeyValuesArray:value[@"intelligence_module"]];
                self.featureDataArray = [HXMCommonModuleModel mj_objectArrayWithKeyValuesArray:value[@"features_module"]];
                [self.dataListArray appendObject:self.newsDataArray];
                [self.dataListArray appendObject:self.intelligenceDataArray];
                [self.dataListArray appendObject:self.featureDataArray];
                NSLog(@"%@",value[@"data"]);
            }
            return self.dataListArray;
        }];
        
    }];


}
@end
