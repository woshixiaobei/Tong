//
//  HXMRemoveAliasManage.m
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/7/31.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMRemoveAliasManage.h"
#import "UMessage.h"
#import "AppDelegate.h"

@implementation HXMRemoveAliasManage

+ (instancetype)shareManage {

    static HXMRemoveAliasManage *_instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[HXMRemoveAliasManage alloc]init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerDeviceTokenSuccessThenAddAlias:) name:@"registerDeviceTkenSuccessNotification" object:nil];
    }
    return self;
}
#pragma mark - 移除alias

- (void) removeAliasUntilSuccess:(void (^)(BOOL isSuccess, NSError * error))handle
{
    
    RACSignal *resultSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        RACCompoundDisposable * disposeable = [RACCompoundDisposable  compoundDisposable];
        
       RACDisposable *disposeTimer = [[[RACSignal interval:60*2 onScheduler:[RACScheduler currentScheduler]] startWith:@(1)] subscribeNext:^(id x) {
            
            [self removeAliasTypes:^(BOOL isSuccess, NSError *error) {
                
                if (isSuccess) {
                    [subscriber sendNext:RACTuplePack(@(YES), nil)];
                    [disposeable dispose];
                    [subscriber sendCompleted];
                }
                else{
                    [subscriber sendNext:RACTuplePack(@(NO), error)];
                }
            }];
        }];
        [disposeable addDisposable:disposeTimer];
        return nil;
    }];
    
    [resultSignal subscribeNext:^(RACTuple* x) {
        
        if (handle) {
            handle([x.first boolValue], x.second);
        }
    }];
}

//移除alias
- (void) removeAliasTypes:(void (^)(BOOL isSuccess, NSError * error))handle{

    __block NSError *isError = nil;
    
    NSString *companyCode = [AccountTool userInfo].company_code.isNotBlank?[AccountTool userInfo].company_code:@"";
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *deviceToken = appdelegate.deviceToken;
    if (companyCode && deviceToken.isNotBlank) {
        
        dispatch_group_t group = dispatch_group_create();
//        dispatch_group_enter(group);
//        [UMessage removeAlias:companyCode type:@"alias" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
//            if (error) {
//                isError = error;
//            }
//
//            dispatch_group_leave(group);
//        }];
        dispatch_group_enter(group);
        [UMessage removeAlias:companyCode type:@"1" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
            if (error) {
                isError = error;
            }
            
            dispatch_group_leave(group);
        }];
        
        dispatch_group_enter(group);
        [UMessage removeAlias:companyCode type:@"2" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
            if (error) {
                isError = error;
            }
    
            dispatch_group_leave(group);
        }];
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            
            if(isError == nil)
            {
                if (handle) {
                    handle(YES, nil);
                }
            }else
            {
                if (handle) {
                    handle(NO, isError);
                }
            }
        });
    }
    else{
        if (handle) {
            handle(NO, [NSError errorWithDomain:@"数据返回错误" code:0 userInfo:nil]);
        }
    }
}

//移除alias成功之后，并添加alias成功
- (void)removeAliasThenAddAliasIsSuccess:(void (^)(BOOL isSuccess, NSError * error))handle{

    @weakify(self)
    [self removeAliasUntilSuccess:^(BOOL isSuccess, NSError *error) {
        
        @strongify(self)
        if (isSuccess) {
            [self addAliasUntilSuccess:handle];
        }
        else{
            if (handle) {
                handle(isSuccess, error);
            }
        }
    }];
}


#pragma mark - 添加alias
- (void) addAliasUntilSuccess:(void (^)(BOOL isSuccess, NSError * error))handle
{
    RACSignal *resultSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        RACCompoundDisposable * disposeable = [RACCompoundDisposable  compoundDisposable];
        
        RACDisposable *disposeTimer = [[[RACSignal interval:60*2 onScheduler:[RACScheduler currentScheduler]] startWith:@(1)] subscribeNext:^(id x) {
            
            [self addAlias:^(BOOL isSuccess, NSError *error) {
                
                if (isSuccess) {
                    [subscriber sendNext:RACTuplePack(@(YES), nil)];
                    [disposeable dispose];
                    [subscriber sendCompleted];
                }
                else{
                    [subscriber sendNext:RACTuplePack(@(NO), error)];
                }
            }];
        }];
        [disposeable addDisposable:disposeTimer];
        return nil;
    }];
    
    [resultSignal subscribeNext:^(RACTuple* x) {
        
        if (handle) {
            handle([x.first boolValue], x.second);
        }
    }];
}

//添加alias
- (void)addAlias:(void (^)(BOOL isSuccess, NSError * error))handle{
    NSString *companyCode = [AccountTool userInfo].company_code.isNotBlank?[AccountTool userInfo].company_code:@"";
    NSString *aliasTypeString = [AccountTool userInfo].aliasType.isNotBlank?[AccountTool userInfo].aliasType:@"";

        [UMessage addAlias:companyCode type:aliasTypeString response:^(id responseObject, NSError *error) {
            NSLog(@"----------------------%@",responseObject);
            NSLog(@"----------------------%@",error);
            if (error) {
                
                if (handle) {
                    handle(NO, error);
                }
            }
            else
            {
                handle(YES, nil);
            }
        }];
}

//- (void)registerDeviceTokenSuccessThenAddAlias:(NSNotification *)notification {
//    NSString *deviceToken = notification.userInfo[@"deviceToken"];
//    if (deviceToken.isNotBlank) {
//        NSLog(@"deviceToken ---- addalias");
//        [self addAlias:^(BOOL isSuccess, NSError *error) {
//            
//        }];
//    }
//}

@end
