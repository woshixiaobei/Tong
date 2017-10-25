//
//  HXMHomeListViewModel.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/23.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMHomeListViewModel.h"
#import "HXHttpHelper.h"
#import "HXMHomeListModel.h"
#import "AccountTool.h"

@interface HXMHomeListViewModel()
@property (nonatomic, strong)RACSignal *homeListSignal;
@property (nonatomic, strong) NSArray *homeListDataArray;
@property (nonatomic, strong) HXMHomeListModel *homeListDataModel;
@end

@implementation HXMHomeListViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initBind];
    }
    return self;
}


- (NSArray *)homeListDataArray {
    
    if (_homeListDataArray == nil) {
        _homeListDataArray = [NSArray array];
    }
    return _homeListDataArray;
    
}
#pragma mark -
- (void)initBind {
    
    @weakify(self)
    _requestHomeListCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            NSString *username = [AccountTool userInfo].username;
            [HXHttpHelper api_getHomeRequestWithUsername:username success:^(id responseObject) {
                
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
                
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
                [subscriber sendError:error];
            }];
            return [RACDisposable disposableWithBlock:^{
            }];
        }] map:^id(id value) {
            
            @strongify(self)
            if ([value[@"state"] intValue] == 0) {
                self.homeListDataModel = [HXMHomeListModel mj_objectWithKeyValues:value[@"data"]];
            }
            return self.homeListDataModel;
        }];
        
    }];
}

- (CGFloat)calculateCellHeightByModel:(HXMDetailNewsCellModel *)model {
    if (model == nil) {
        return 0.0;
    }
    CGSize titleSize = [model.newsTitle boundingRectWithSize:CGSizeMake(kScreenWidth - 2 * 24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:19.0]} context:nil].size;
    CGSize contentSize = [model.newsResume boundingRectWithSize:CGSizeMake(kScreenWidth - 2 * 24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0]} context:nil].size;
    return titleSize.height + contentSize.height + 78.5;
}
@end
