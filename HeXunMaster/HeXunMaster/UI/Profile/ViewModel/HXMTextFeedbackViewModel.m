//
//  HXMTextFeedbackViewModel.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/5/9.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMTextFeedbackViewModel.h"
#import "HXHttpHelper.h"
#import "AccountTool.h"

@interface HXMTextFeedbackViewModel()
@property (nonatomic, strong)RACSignal *requestTextFeedbackSignal;
@end

@implementation HXMTextFeedbackViewModel

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
        
        @strongify(self)
        //电话号码
        NSString *userMobile = [AccountTool userInfo].username;
       NSURLSessionTask *task = [HXHttpHelper api_getTextFeedbackActionRequestWithUserMobile:userMobile content:self.params[@"content"] success:^(id responseObject) {
           
           if ([responseObject[@"state"] integerValue]== 0) {
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
