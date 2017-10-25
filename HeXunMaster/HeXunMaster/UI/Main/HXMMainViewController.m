//
//  HXMMainViewController.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/8.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMMainViewController.h"
#import "HXNavigationViewController.h"
#import "HXMNewsViewController.h"
#import "HXMInformationViewController.h"
#import "HXMLoginViewController.h"
#import "HXMNewsDetailVC.h"
#import "UMessage.h"
#import "AppDelegate.h"
#import "HXMRemoveAliasManage.h"
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

@interface HXMMainViewController ()<UITabBarControllerDelegate>

@end

@implementation HXMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self addChildViewControllers];
    [self applicationWithEngine];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoNotification:) name:@"userInfoNotification" object:nil];
    }
    return self;
}

- (void)selectPushToNewsVC:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSInteger moduleTag = [userInfo[@"moduleTag"] integerValue];
    
    if (moduleTag == 1) {
        self.selectedIndex = 1;
    } else if (moduleTag == 2) {
        self.selectedIndex = 2;
    }
}
- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)applicationWithEngine {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSuccess) name:NOTIFICATION_LOGOUT_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectPushToNewsVC:) name:@"CommonModuleToPushNewsNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectPushToNewsVC:) name:@"CommonModuleToPushInformationNotification" object:nil];
  
}

#pragma mark - 接受通知跳转到详情页
-(void)userInfoNotification:(NSNotification*)notification{
    
    NSDictionary *dict = [notification userInfo];
    [self notificationWithPushMessage:dict];

}

- (void)notificationWithPushMessage:(NSDictionary*)dict {
    
    if ([[dict objectForKey:@"message_type"] isEqualToString:@"1"]) {
        HXMNewsDetailVC *secondvc=[[HXMNewsDetailVC alloc]init];
        secondvc.module_id = dict[@"module_id"];
        secondvc.newsId = dict[@"news_id"];
        UITabBarController *tabBar = (UITabBarController*)[UIApplication sharedApplication].delegate.window.rootViewController;
        HXNavigationViewController *navi = tabBar.selectedViewController;
        [navi.rt_topViewController.navigationController pushViewController:secondvc animated:YES];
    }
}

//退出登录
- (void)logoutSuccess {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"userInfoNotification" object:nil];
    
    [[HXMRemoveAliasManage shareManage] removeAliasUntilSuccess:^(BOOL isSuccess, NSError *error) {
        
        if (isSuccess) {
            // 退出登录
            [AccountTool deleteUserInfo];
            [AccountTool deleteCookies];
            
            //删除缓存
            NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
            NSString *filePath = [path stringByAppendingPathComponent:@"allModule.plist"];
            [self cleanCaches:filePath];
            
            NSLog(@"removeAliasTypes 移除成功 ");
        }
        else{
            NSLog(@"removeAliasTypes 移除失败 ");
        }
           }];
}

// 根据路径删除文件
- (void)cleanCaches:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        // 将文件删除
        [fileManager removeItemAtPath:path error:nil];
    }
}

#pragma mark - 添加子控制器
- (void)addChildViewControllers {
    
    NSArray *array = @[
                       @{@"clsname":@"HXMHomeViewController",@"title":@"首页",@"imageName":@"home"},
                       @{@"clsname":@"HXMNewsViewController",@"title":@"新闻",@"imageName":@"news"},
                       @{@"clsname":@"HXMInformationViewController",@"title":@"情报",@"imageName":@"information"},
                       @{@"clsname":@"HXMProfileViewController",@"title":@"个人中心",@"imageName":@"profile"}
                       ];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [arrayM addObject:[self childViewControllerWithDict:dict]];
    }
    self.viewControllers = arrayM.copy;
}

//创建子控制器
- (UIViewController *)childViewControllerWithDict:(NSDictionary *)dict {
    
    Class cls = NSClassFromString(dict[@"clsname"]);
    NSAssert(cls != nil, @"传入类型错误");
    UIViewController *vc = [cls new];
    vc.title = dict[@"title"];
    NSString *imageName = [NSString stringWithFormat:@"tabbar_icon_%@_normal",dict[@"imageName"]];
    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    NSString *imageNameHL = [NSString stringWithFormat:@"tabbar_icon_%@_highlight",dict[@"imageName"]];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:imageNameHL] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
   
    HXNavigationViewController *nav = [[HXNavigationViewController alloc]initWithRootViewController:vc];
    
    return nav;
    
}
@end
