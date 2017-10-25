//
//  UIEngine.m
//  Train
//
//  Created by 蔡建海 on 15/11/30.
//  Copyright © 2015年 HeXun. All rights reserved.
//

#import "UIEngine.h"
//#import "CoreEngine.h"
#import "HXTabBar.h"
#import "AccountTool.h"
//#import "MomentsViewController.h"
//#import "CommendViewController.h"
//#import "TeacherViewController.h"
//#import "HXLiveSegmentedController.h"
//#import "MineVC.h"

//#import "ASharesRadarDetailsVC.h"
//#import "LiveRoomViewController.h"
//#import "TeacherDetailViewController.h"
//#import "OpinionDetailController.h"
//#import "MessageCenterNewVC.h"
//#import "OpinionDetailViewController.h"
//#import <HXDataAnalytics/HXDataAnalytics.h>
//#import "CourseDetailViewController.h"
//#import "PushNotificationManager.h"
//#import "WDDetailController.h"
//#import "VHallApi.h"
//#import "HXCommissionedWebViewController.h"
#import "HXNavigationViewController.h"
#import "HXMHomeViewController.h"
#import "HXMNewsViewController.h"
#import "HXMInformationViewController.h"
#import "HXMProfileViewController.h"

@interface UIEngine() <UITabBarControllerDelegate>
{
        
}

@property (nonatomic, strong) HXTabBar *hxBar;
@property (nonatomic, strong) HXMHomeViewController *homeVC;
@property (nonatomic, strong) HXMNewsViewController *NewsVC;
@property (nonatomic, strong) HXMInformationViewController *informationVC;
//@property (nonatomic, strong) HXLiveSegmentedController *liveVC;
@property (nonatomic, strong) HXMProfileViewController *mineVC;

@property (nonatomic, strong) UITabBarController *tabVC;

@property (nonatomic, strong) NSMutableArray *marrayNavController;
@property (nonatomic, strong) HXNavigationViewController *nav;

@end

@implementation UIEngine
//@synthesize rootVC = _rootVC;

//
- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    //
    self.marrayNavController = [[NSMutableArray alloc]initWithCapacity:5];
    
    [self doMain];
    
    //
    NSNotificationCenter *defaulterCenter = [NSNotificationCenter defaultCenter];
    [defaulterCenter removeObserver:self];
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectSecondVC:) name:@"CommonModuleToPushHomeListNotification" object:nil];
//    [defaulterCenter addObserver:self selector:@selector(loginSuccess:) name:NOTIFICATION_LOGIN_SUCCESS object:nil];
//    [defaulterCenter addObserver:self selector:@selector(logoutSuccess:) name:NOTIFICATION_LOGOUT_SUCCESS object:nil];
    
    return self;
}

- (void)selectSecondVC:(NSNotification *)notification
{
//    NSDictionary *userInfo = notification.userInfo;
//    // NSString *name = userInfo[@"name"];
//    // NSString *modelId = userInfo[@"id"];
//    NSInteger moduleTag = [userInfo[@"moduleTag"] integerValue];
//    
//    if (moduleTag == 1) {
//        self.hxBar.selectIndex = 1;
//        
//    } else if (moduleTag == 2) {
//        self.hxBar.selectIndex = 2;
//    }
    
}
- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//
- (UIViewController *)rootVC
{
    return self.tabVC;
}

- (void)setEngineCore:(CoreEngine *)engineCore
{
    _engineCore = engineCore;
    
    __weak typeof(self) wself = self;
//    [_engineCore setHandlerNotification:^(NSDictionary *userInfo) {
//        __strong typeof(wself)sself = wself;
//        [sself handlerNotification:userInfo];
//    }];
}

//
- (HXTabBar *)fsBar
{
    if (!_hxBar) {
        
        CGFloat height = self.tabVC.tabBar.size.height;
        CGFloat width = self.tabVC.tabBar.size.width;
        
        _hxBar = [[HXTabBar alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _hxBar.userInteractionEnabled = NO;
        _hxBar.backgroundColor = [UIColor clearColor];
    }
    return _hxBar;
}

//
- (void)doMain
{
    // 首页
    HXMHomeViewController *homeVC = [[HXMHomeViewController alloc]init];
    HXNavigationViewController *navMain = [[HXNavigationViewController alloc]initWithRootViewController:homeVC];
    homeVC.title = @"首页";
//    self.NewsVC = homeVC;
    
    // 新闻
    HXMNewsViewController *newsVC = [[HXMNewsViewController alloc]init];
    HXNavigationViewController *navNews = [[HXNavigationViewController alloc]initWithRootViewController:newsVC];
//    tVC.title = @"新闻";
//    self.teacherVC = newsVC;
    
    // 情报
    HXMInformationViewController *informationVC = [[HXMInformationViewController alloc] init];
    HXNavigationViewController *navInformation = [[HXNavigationViewController alloc]initWithRootViewController:informationVC];
//    liveTableVC.title = @"情报";
//    self.liveVC = liveTableVC;
    
    // 我的
    HXMProfileViewController *mineVC = [[HXMProfileViewController alloc]init];
    HXNavigationViewController *navMine = [[HXNavigationViewController alloc]initWithRootViewController:mineVC];
    mineVC.title = @"个人中心";
    self.mineVC = mineVC;
    
    [self.marrayNavController addObject:navMain];
    [self.marrayNavController addObject:navNews];
    [self.marrayNavController addObject:navInformation];
    [self.marrayNavController addObject:navMine];
//    [self.marrayNavController addObject:navMine];
    
//
    UITabBarController *tabVC= [[UITabBarController alloc] init];
    tabVC.selectedIndex = 1;
    tabVC.viewControllers = self.marrayNavController;
    tabVC.delegate = self;
//    tabVC.tabBar.translucent = NO;
    //清除系统线条
//    [tabVC.tabBar setBackgroundImage:[UIImage new]];
//    [tabVC.tabBar setShadowImage:[UIImage new]];
    self.tabVC = tabVC;
    
    [self.tabVC.tabBar addSubview:self.fsBar];
    
//     默认选中首页
    [self tabBarSelectIndex:0];
}

#pragma mark - 远程通知处理
//
// 远程通知处理
- (void)engineUIApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // 程序正处在前台运行，直接返回
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if (application.applicationState == UIApplicationStateActive) return;
    [self handlerNotification:userInfo];
    // IOS 7 Support Required
//    [self.engineCore engineCoreHandleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}


- (void)handlerNotification:(NSDictionary *)userInfo
{
    
//    NSDictionary *notificationInfo = [PushNotificationManager parseRemoteNotificationInfo:userInfo];
//    NSString *type = notificationInfo[kRemotePushNotificationTypeKey];
//    NSString *url = notificationInfo[kRemotePushNotificationURLKey];
    
//    if (![type isEqualToString:kUserMomentType]) {
//        if (![AccountTool userInfo].islogin) {
//            return;
//        }
//    }
    
    [UIApplication sharedApplication].delegate.window.rootViewController = self.rootVC;
    
    UITabBarController *tabbar = (UITabBarController *)self.rootVC;
    
    self.nav = tabbar.selectedViewController;
    
//    if ([type isEqualToString:kUserARadarType]) { // A股雷达
//        
//        [self toASharesRadarDetailsViewControllerByRadarId:notificationInfo[@"param2"] teacherId:notificationInfo[@"param1"] isRadar:YES];
//        
//    }
//    else if ([type isEqualToString:kActivity_msgType]) { // 王者活动
//        
//        BaseWebViewController *h5 = [[BaseWebViewController alloc]init];
//        h5.url = url;
//        [self.nav pushViewController:h5 animated:YES];
//    }
//    else if ([type isEqualToString:kEntrust_msgType]){ //委托
//        HXCommissionedWebViewController *h5 = [[HXCommissionedWebViewController alloc]init];
//        h5.url = url;
//        [self.nav pushViewController:h5 animated:YES];
//    }
//    else if ([type isEqualToString:kAPlanType]) { // 投顾A计划
//        
//        [self toASharesRadarDetailsViewControllerByRadarId:notificationInfo[@"param2"] teacherId:notificationInfo[@"param1"] isRadar:NO];
//        
//    } else if ([type isEqualToString:kUserMomentType]) { // 老师观点详情
//        
//        
//        [self toOpinionDetailViewControllerByOpinionId:notificationInfo[@"param1"]];
//        
//    } else if ([type isEqualToString:kPrivacyOpinionMsgType] || [type isEqualToString:kPublicOpinionMsgType]) { // 投顾私密观点/公开观点
//        
//        [self toAdviserOpinionDetailByURL:url];
//        
//    } else if ([type isEqualToString:kQuestionRepliedType]) { // 投顾回复问题
//        
//        [self toQuestionAndAnswerDetailViewControllerByQuestionId:notificationInfo[@"param1"]];
//        
//    } else if ([type isEqualToString:kUserSystemMsgType]) { // 系统消息
//        
//        if ([url containsString:@"http://"] || [url containsString:@"https://"]) {
//            
//            [self toWebViewControllerByURL:url];
//            
//        } else if ([url containsString:kARadarDetailUrl]) { // A股雷达详情
//            
//            [self toASharesRadarDetailsViewControllerByRadarId:notificationInfo[@"param2"] teacherId:notificationInfo[@"param1"] isRadar:YES];
//            
//        } else if ([url containsString:kLiveRoomUrl]) { // 直播室
//            
//            [self toLiveRoomViewControllerByRoomId:notificationInfo[@"param1"]];
//            
//        } else if ([url containsString:kTeacherMomentsUrl]) { // 老师个人财圈
//            
//            [self toTeacherMomentViewControllerByTeacerId:notificationInfo[@"param1"]];
//            
//        } else if ([url containsString:kMomentsDetailsUrl]) { // 财圈详情
//            
//            [self toOpinionDetailViewControllerByOpinionId:notificationInfo[@"param1"]];
//            
//        } else if ([url containsString:kLessonDetailsUrl]) { // 课程详情
//            
//            [self toCourseDetailViewControllerByClassId:notificationInfo[@"param1"]];
//            
//        } else {
//            
//            [self toMessageViewController];
//        }
//    }
    
}


// 跳到A股雷达/A计划详情
//- (void)toASharesRadarDetailsViewControllerByRadarId:(NSString *)radarId teacherId:(NSString *)teacherId isRadar:(BOOL)isRadar{
//    ASharesRadarDetailsVC *aSharesRadarDetailsVC = [[ASharesRadarDetailsVC alloc] init];
//    aSharesRadarDetailsVC.aplanid = radarId;
//    aSharesRadarDetailsVC.consultant_id = teacherId;
//    aSharesRadarDetailsVC.status = @"1";  // 1 新的A股雷达 2 已运行 3 成功 4 失败
//    aSharesRadarDetailsVC.platfrom = isRadar ? @"1" : @"2";
//    [self.nav pushViewController:aSharesRadarDetailsVC animated:YES];
//    
//}
//
//// 跳到老师观点详情页
//- (void)toOpinionDetailViewControllerByOpinionId:(NSString *)opinionId {
//    
//    OpinionDetailController *opinonDetailVc = [[OpinionDetailController alloc] init];
//    opinonDetailVc.opinionId = opinionId;
//    [self.nav pushViewController:opinonDetailVc animated:YES];
//}
//
//// 跳到投顾观点详情
//- (void)toAdviserOpinionDetailByURL:(NSString *)url {
//    
//    OpinionDetailViewController *opinonDetailVc = [[OpinionDetailViewController alloc] init];
//    opinonDetailVc.webUrl = url;
//    [self.nav pushViewController:opinonDetailVc animated:YES];
//
//}
//
//// 跳到直播室详情
//- (void)toLiveRoomViewControllerByRoomId:(NSString *)roomId {
//    LiveRoomViewController *liveRoomVC = [[LiveRoomViewController alloc] initIsTeacher:NO];
//    liveRoomVC.roomID = roomId;
//    [self.nav pushViewController:liveRoomVC animated:YES];
//
//}
//
//// 跳到webview
//- (void)toWebViewControllerByURL:(NSString *)url {
//    BaseWebViewController *h5Vc = [[BaseWebViewController alloc] init];
//    h5Vc.webUrl = url;
//    [self.nav pushViewController:h5Vc animated:YES];
//}
//
//// 跳到老师个人财圈列表
//- (void)toTeacherMomentViewControllerByTeacerId:(NSString *)teacherId {
//    
//    TeacherDetailViewController *vcDetail = [[TeacherDetailViewController alloc] init];
//    vcDetail.teacherID = teacherId;
//    [self.nav pushViewController:vcDetail animated:YES];
//}
//
//// 跳到课程详情
//- (void)toCourseDetailViewControllerByClassId:(NSString *)classId {
//    
//    CourseDetailViewController *vc = [[CourseDetailViewController alloc]init];
//    vc.classId = classId.integerValue;
//    [self.nav pushViewController:vc animated:YES];
//}
//
//// 跳到消息中心的消息标签
//- (void)toMessageViewController {
//    
//    MessageCenterNewVC *msgVc = [[MessageCenterNewVC alloc] init];
//    msgVc.index = 2;
//    [self.nav pushViewController:msgVc animated:YES];
//    
//}
//
//// 跳到问答详情
//- (void)toQuestionAndAnswerDetailViewControllerByQuestionId:(NSString *)questionId {
//    
//    WDDetailController *vc = [[WDDetailController alloc]init];
//    vc.qid = [NSNumber numberWithString:questionId];
//    [self.nav pushViewController:vc animated:YES];
//}

#pragma mark - notification
//
- (void)loginSuccess:(NSNotification *)noti
{
    // 检查是否有特色指标
//    [[GlobalAPI shareGlobalAPI] getIsHasIndex];
//    // 更新微吼用户名信息
//    [[GlobalAPI shareGlobalAPI] updateUserName];
    
    //[[CoreSingleTon shareCoreSingleTon] loginSucess];
    
    for (UINavigationController *nav in self.marrayNavController) {
        
        RTContainerController *vc = [nav.viewControllers firstObject];
        
        if ([vc.contentViewController respondsToSelector:@selector(loginSuccessEvent)]) {
            [vc.contentViewController performSelector:@selector(loginSuccessEvent) withObject:nil];
        }
    }
}

//
- (void)logoutSuccess:(NSNotification *)noti
{
    // 检查是否有特色指标
//    [[GlobalAPI shareGlobalAPI] getIsHasIndex];
    
    //[[CoreSingleTon shareCoreSingleTon] logOutSucess];

    // 退出登录
    [AccountTool deleteUserInfo];
    [AccountTool deleteCookies];
//    [[GlobalNotification_Mgr shareGlobalNotification_Mgr] setLogout];
//    [HXDataAnalytics logoutComplete];
    //退出微吼
//    [VHallApi logout:nil failure:nil];
    
    for (UINavigationController *nav in self.marrayNavController) {
        RTContainerController *vc = [nav.viewControllers firstObject];
        if ([vc.contentViewController respondsToSelector:@selector(logoutSuccessEvent)]) {
            [vc.contentViewController performSelector:@selector(logoutSuccessEvent) withObject:nil];
        }
    }
}

#pragma mark - private
//选中index
- (void)tabBarSelectIndex:(NSInteger)index
{
    self.tabVC.selectedViewController = [self.marrayNavController objectOrNilAtIndex:index];
    _hxBar.selectIndex = index;
}

#pragma mark - UITabBarControllerDelegate
//
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    UIViewController *lastVC = tabBarController.selectedViewController;
    // 选中状态下 再次选择没反应
    if (lastVC == viewController) {
        if ([lastVC isKindOfClass:UINavigationController.class]) {
            UINavigationController *nav = (UINavigationController *)lastVC;
            RTContainerController *vc = [[nav viewControllers] objectOrNilAtIndex:0];
            if ([vc.contentViewController respondsToSelector:@selector(tabBarSelectEventAgain)]) {
                [vc.contentViewController performSelector:@selector(tabBarSelectEventAgain) withObject:nil];
            }
        }
        return NO;
    }
    
    return YES;
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UINavigationController *)viewController {
    
    self.fsBar.selectIndex = tabBarController.selectedIndex;
    [self.fsBar setNeedsDisplay];
    
    RTContainerController *vc = [[viewController viewControllers] objectOrNilAtIndex:0];
    if ([vc.contentViewController respondsToSelector:@selector(tabBarSelectEvent)]) {
        [vc.contentViewController performSelector:@selector(tabBarSelectEvent) withObject:nil];
    }
}

@end
