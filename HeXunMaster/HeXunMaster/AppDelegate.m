//
//  AppDelegate.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/2/17.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "AppDelegate.h"
#import "NewFeatureController.h"
#import "AccountTool.h"
#import "HXMProgressHUD.h"
//#import "CoreEngine.h"
#import "UIEngine.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#if __has_include(<MobClickInOne/MobClick.h>)&&__has_include(<MobClickInOne/DplusMobClick.h>)//dplus兼容
#import <MobClickInOne/MobClick.h>
#import <MobClickInOne/DplusMobClick.h>
#elif __has_include(<UMMobClick/MobClick.h>)
#import <UMMobClick/MobClick.h>
#else
#import "MobClick.h"
#endif
#import "MobClick+HXDataAnalytics.h"

#import "UMessage.h"
#import "HXMPushToastViewController.h"
#import "HXMPushToastView.h"
#import "HXNavigationViewController.h"
#import "HXMLoginMainView.h"
#import "HXMLoginViewController.h"
#import "HXMNewsDetailVC.h"
#import "HXMRemoveAliasManage.h"

//以下几个库仅作为调试引用引用的
#import <AdSupport/AdSupport.h>
#import <CommonCrypto/CommonDigest.h>

@interface AppDelegate ()<NewFeatureVCDelegate,UNUserNotificationCenterDelegate>
@property (nonatomic, strong) UIEngine *engineUI;
@property (nonatomic, strong) HXMPushToastView *pushToastView;
@property (nonatomic, strong) HXMPushToastViewController *pushToastViewController;
@property (nonatomic, assign) NSInteger PushCount;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [self initRootViewController:launchOptions];
 
    // 配置友盟推送
    [self setupUMNotificationsWithLaunchOptions:launchOptions];
    
    // 配置友盟分享
    [self setupUMConfig];
    
    // 友盟统计分析
    [self setupMobClick];
    
    return YES;
}

- (void)initRootViewController:(NSDictionary *)launchOptions
{

    self.window.backgroundColor = [UIColor whiteColor];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //优先赋值一个空白vc 防止复杂操作 windows rootViewController 为空导致的奔溃
    UIViewController *viewController = [UIViewController new];
    viewController.view.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = viewController;
    /**
     *  判断是否连接网络
     */
    [self checkLink];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults objectForKey:kBundleShortVersionStringKey];
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[kBundleShortVersionStringKey];
    // 判断是否有引导页
    if ([lastVersion isEqualToString:currentVersion]) {
    
        // 未登录时显示登录界面
        if (![AccountTool isLogin]) {
            HXMLoginViewController *vc = [[HXMLoginViewController alloc]init];
            HXNavigationViewController *navi = [[HXNavigationViewController alloc]initWithRootViewController:vc];
            vc.rt_prefersNavigationBarHidden = YES;
            self.window.rootViewController = navi;

        }else {
            Class cls = NSClassFromString(@"HXMMainViewController");
            UIViewController *vc = [cls new];
            self.window.rootViewController = vc;
            [self loginWithToken];
        }
    } else {
        NewFeatureController *NewVC = [NewFeatureController shareNewFeatherVc];
        NewVC.delegate = self;
        self.window.rootViewController = NewVC;
        [defaults setObject:currentVersion forKey:kBundleShortVersionStringKey];
        [defaults synchronize];
    }

    [self clearWindowRoorViewController];
    
    [self.window makeKeyAndVisible];
}

- (void)clearWindowRoorViewController
{
    for (UIWindow *w  in [UIApplication sharedApplication].windows) {
        if (!w.rootViewController) {
           
            w.rootViewController = [UIViewController new];
        }
    }
}

#pragma mark - token登录

- (void)loginWithToken {
    
    @weakify(self)
    HXMUser *user = [AccountTool userInfo];
    NSString *token = user.token;
    
    if (token.isNotBlank) {
        
        [HXMProgressHUD showInView:[UIApplication sharedApplication].delegate.window];
        [HXHttpHelper api_postSendVerficationCodeToGetTokenWithUsername:user.username withAccessToken:token success:^(id responseObject) {
            @strongify(self)
            
            [HXMProgressHUD hide];
            if ([responseObject[@"state"] integerValue] == 0) {
                if ([responseObject[@"data"][@"result"] integerValue] == 0) { // 获取token成功且有效
                    // 跳转首页
                    NSLog(@"%@",user.token);
                    HXMUser *user = [HXMUser mj_objectWithKeyValues:responseObject[@"data"]];
                    user.token = token;
                    [AccountTool save:user];

                    //移除之前的alias并添加alias
                    [[HXMRemoveAliasManage shareManage] removeAliasThenAddAliasIsSuccess:^(BOOL isSuccess, NSError *error) {
//                        if (isSuccess) {
//                            
//                            NSLog(@"removeAliasTypes 移除成功 ");
//                        }
//                        else{
//                            NSLog(@"removeAliasTypes 移除失败 ");
//                        }
                    }];
                   
                } else if ([responseObject[@"data"][@"result"] integerValue] == 1) { // 获取token错误
                    [self resetUserInfoThenToLoginWithMessage:@"账号已登录其它设备，请重新登录" showingToast:YES];

                } else if ([responseObject[@"data"][@"result"] integerValue] == 2) { // 获取token无效
                    [self resetUserInfoThenToLoginWithMessage:@"获取token无效..." showingToast:YES];
                    
                }
            } else {

                // 其他state情况
                HXMLoginViewController *vc = [[HXMLoginViewController alloc]init];
                [UIApplication sharedApplication].keyWindow.rootViewController = vc;
                
                [HXMProgressHUD showError:@"网络出错，请重新加载..." inview: [UIApplication sharedApplication].keyWindow];
            }
        } failure:^(NSError *error) {
            
            [HXMProgressHUD showError:@"网络出错，请重新加载..." inview:[UIApplication sharedApplication].keyWindow];
            NSLog(@"获取token %@", error);
        }];
    }
    
}

// 重置用户信息并去登录
- (void)resetUserInfoThenToLoginWithMessage:(NSString *)message showingToast:(BOOL)isShow {

    //移除alias成功
    [[HXMRemoveAliasManage shareManage] removeAliasUntilSuccess:^(BOOL isSuccess, NSError *error) {
        
        if (isSuccess) {
            // 清除用户信息
            [AccountTool deleteUserInfo];
            // 清除cookie
            [AccountTool deleteCookies];
        }
    }];
    
    

    if (isShow) {
        [HXMProgressHUD showError:message inview: [UIApplication sharedApplication].keyWindow];
        
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        HXMLoginViewController *vc = [[HXMLoginViewController alloc]init];
        [vc.loginMainView resetLogin];
        self.window.rootViewController = vc;
    });
}

- (void)NewFeatureToRootVC {
    // 切换控制器
    UIViewController *old = self.window.rootViewController;
    
    if (![AccountTool isLogin]) {
        Class cls = NSClassFromString(@"HXMLoginViewController");
        UIViewController *vc = [cls new];
        HXNavigationViewController *navi = [[HXNavigationViewController alloc]initWithRootViewController:vc];
        vc.rt_prefersNavigationBarHidden = YES;
        self.window.rootViewController = navi;
       
    }else {
        Class cls = NSClassFromString(@"HXMMainViewController");
        UIViewController *vc = [cls new];
        self.window.rootViewController = vc;
    }
    old = nil;
}

#pragma mark - 检查网络
-(void)checkLink
{
    // 检测网络连接状态
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // 连接状态回调处理
    /* AFNetworking的Block内使用self须改为weakSelf, 避免循环强引用, 无法释放 */
    //    __weak typeof(self) weakSelf = self;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         switch (status) {
             case AFNetworkReachabilityStatusUnknown:
                 
                 [HXMProgressHUD showError:@"网络未识别" inview:[UIApplication sharedApplication].keyWindow];
                 break;
                 
             case AFNetworkReachabilityStatusNotReachable:
                 
                 [HXMProgressHUD showError:kNotNetworkError inview:[UIApplication sharedApplication].keyWindow];
                 break;
                 
             case AFNetworkReachabilityStatusReachableViaWWAN:
//                  [MBProgressHUD showSuccess:@"2G,3G,4G...的网络"];
                 break;
                 
             case AFNetworkReachabilityStatusReachableViaWiFi:
                 //                 [MBProgressHUD showSuccess:@"wifi的网络"];
                 break;
             default:
                 break;
         }
     }];
};

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    if (userInfo) {
//        NSLog(@"\n>>>[Launching RemoteNotification]:%@", userInfo);
//    }

    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^(){
        //程序在10分钟内未被系统关闭或者强制关闭，则程序会调用此代码块，可以在这里做一些保存或者清理工作
//        [AccountTool deleteUserInfo];
//        [AccountTool deleteCookies];
            }];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];   //清除角标
    [application cancelAllLocalNotifications];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     [UMSocialSnsService  applicationDidBecomeActive];

}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

/**
 *  UIWebView 内存优惠 内存警告时删掉内存
 */
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

#pragma mark - 注册远程通知
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *deviceToken1 = [deviceToken description].isNotBlank ? [[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] : @"";
    NSString *deviceToken2 = [deviceToken1 description].isNotBlank ? [[deviceToken1 description] stringByReplacingOccurrencesOfString:@">" withString:@""] : @"";
    NSString *deviceToken3 = [deviceToken2 description].isNotBlank ? [[deviceToken2 description] stringByReplacingOccurrencesOfString:@" " withString:@""] : @"";
    
    self.deviceToken = deviceToken3;
    [UMessage registerDeviceToken:deviceToken];
    [HXMRemoveAliasManage shareManage];
    //发送通知监听
//    if (self.deviceToken.isNotBlank) {
//          [[NSNotificationCenter defaultCenter] postNotificationName:@"registerDeviceTkenSuccessNotification" object:nil userInfo:[NSDictionary dictionaryWithObject:self.deviceToken forKey:@"deviceToken"]];
//    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"RemoteNotificationsError = %@", error);
}

//iOS10之前用，处理接受到通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {

    //关闭友盟自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    
    NSString *messageType = [userInfo objectForKey:@"message_type"];
    NSString *newsTitle = [userInfo objectForKey:@"news_title"];
    if ( application.applicationState == UIApplicationStateActive) {
        // 程序在运行过程中受到推送通知
        self.userInfo = userInfo;
        //定制自定的的弹出框
        if ([messageType isEqualToString:@"1"]) {
            if (!self.pushToastView.superview&&[AccountTool isLogin]) {
                self.pushToastView.titleLabel.text = newsTitle;
                self.pushToastView.userInfo = userInfo;
                
                [self.pushToastView show];
            }else {
                return;
            }
        }
    } else {
        //在background状态受到推送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoNotification" object:self userInfo:userInfo];
    }

    completionHandler(UIBackgroundFetchResultNewData);
}


//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;

    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];
        //应用处于前台时的远程推送接受
        [UMessage didReceiveRemoteNotification:userInfo];
        
        NSString *messageType = [userInfo objectForKey:@"message_type"];
        NSString *newsId = [userInfo objectForKey:@"news_id"];
        NSString *newsTitle = [userInfo objectForKey:@"news_title"];
        //定制自定的的弹出框
        if([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            if ([messageType isEqualToString:@"1"]) {
                
                if (!self.pushToastView.superview&&[AccountTool isLogin]) {
                    self.pushToastView.titleLabel.text = [userInfo objectForKey:@"news_title"];
                    self.pushToastView.userInfo = userInfo;
                    
                    [self.pushToastView show];
                } else {
                    return;
                }
            }
        }
    }else{
        //应用处于前台时的本地推送接受
    }
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        if ([AccountTool isLogin]) {
            //应用处于后台时的远程推送接受
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userInfoNotification" object:self userInfo:userInfo];
            //必须加这句代码
            [UMessage didReceiveRemoteNotification:userInfo];
            
        }
    }else{
        //应用处于后台时的本地推送接受
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}


- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
{
    if ([UIDevice currentDevice].isPad) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - 友盟推送
//友盟推送
- (void)setupUMNotificationsWithLaunchOptions:(NSDictionary *)launchOptions {

     [UMessage startWithAppkey:kUMAppKey launchOptions:launchOptions httpsEnable:YES];
#if DEUBG
     [UMessage openDebugMode:YES];
#endif
     [UMessage registerForRemoteNotifications];
    
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
//    if ([UNUserNotificationCenter class]) {
        //iOS10必须加下面这段代码。
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate=self;
        UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
        [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //点击允许
                
            } else {
                //点击不允许
                
            }
        }];
//    }else{
//        [UMessage registerForRemoteNotifications];
//
//    }
//    

    
#if DEBUG
    [UMessage setLogEnabled:YES];
#endif
}

#pragma mark -友盟分享
//友盟分享
- (void)setupUMConfig {
    // 友盟分享
    // 设置友盟社会化组件appkey
    [UMSocialData setAppKey:kUMAppKey];
    
    // 设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:kWechatAppId appSecret:kWechatAppKey url:@"http://yuqing.hexun.com/upload/hexuntong/hexuntong/index.html"];
    
    // 设置qq分享
    [UMSocialQQHandler setQQWithAppId:kQQAppId appKey:kQQAppKey url:@"http://yuqing.hexun.com/upload/hexuntong/hexuntong/index.html"];
    [UMSocialQQHandler setSupportWebView:YES];
    // 微博分享
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:kSinaAppKey secret:kSinaAppSecret RedirectURL:@"http://yuqing.hexun.com/upload/hexuntong/hexuntong/index.html"];
    
}

//友盟统计
- (void)setupMobClick {
    /**
     友盟统计分析
     [MobClick startWithAppkey:@"xxxxxxxxxxxxxxx" reportPolicy:BATCH   channelId:@"Web"];
     */
    
    // version标识 Build号
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSArray *arrayChar = [version separateWithChar];
    NSString *version_dot = [arrayChar componentsJoinedByString:@"."];
    
    [MobClick setAppVersion:version_dot];

    [MobClick hook];
    
    
    //兼容 统计新老版本
#if __has_include(<MobClickInOne/MobClick.h>) || __has_include(<UMMobClick/MobClick.h>)
    UMAnalyticsConfig *config = [UMAnalyticsConfig sharedInstance];
    config.appKey = kUMAppKey;
    config.ePolicy = BATCH;
    [MobClick startWithConfigure:config];
#else
    [MobClick startWithAppkey:kUMAppKey reportPolicy:BATCH   channelId:nil];
#endif
#ifdef DEBUG
    [MobClick setLogEnabled:YES];
#endif
    /** 设置是否对日志信息进行加密, 默认NO(不加密). */
    [MobClick setEncryptEnabled:YES];//加密友盟统计分析日志，数据传输是加密的
    
    //#if __has_include(<MobClickInOne/DplusMobClick.h>)
    //    if ([AccountTool isLogin]) {
    //#warning TODO
    //        [DplusMobClick registerSuperProperty:@{}];
    //
    //    }else{
    //        [DplusMobClick clearSuperProperties];
    //    }
    //#endif

}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
#pragma mark 以下的
-(NSString *)stringDevicetoken:(NSData *)deviceToken
{
    NSString *token = [deviceToken description];
    NSString *pushToken = [[[token stringByReplacingOccurrencesOfString:@"<"withString:@""]                   stringByReplacingOccurrencesOfString:@">"withString:@""] stringByReplacingOccurrencesOfString:@" "withString:@""];
    return pushToken;
}

- (HXMPushToastViewController *)pushToastViewController {

    if (_pushToastViewController == nil) {
        _pushToastViewController = [[HXMPushToastViewController alloc]init];
    }
    return _pushToastViewController;
}
- (HXMPushToastView *)pushToastView {

    if (_pushToastView == nil) {
        _pushToastView =  [[HXMPushToastView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _pushToastView;
}

@end
