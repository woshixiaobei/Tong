//
//  HXNavigationViewController.m
//  TrainingClient
//
//  Created by wangmingzhu on 17/3/8.
//  Copyright © 2015年 HeXun. All rights reserved.
//

#import "HXNavigationViewController.h"
#import <YYCategories/YYCategories.h>
//#import "MacroConst.h"



@interface HXNavigationViewController () <UIGestureRecognizerDelegate>

@end

@implementation HXNavigationViewController

#if __has_include("RTRootNavigationController.h")
- (void)_commonInit {
    [super _commonInit];
    
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:19.0], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationBar setTranslucent:NO];
    [self.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:([UIColor colorWithHexString:@"#3c5c8e"]) size:CGSizeMake(Screen_width, Screen_height)] forBarMetrics:UIBarMetricsDefault];
}
#endif

+ (void)initialize {
    // 通过appearance对象能修改整个项目中所有UIBarButtonItem的样式
    UINavigationBar *appearance = [UINavigationBar appearance];
    [appearance setTintColor:[UIColor blackColor]];
    
    if  (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) && [UINavigationBar conformsToProtocol:@protocol(UIAppearanceContainer)]) {
        [[UINavigationBar appearance] setTranslucent:NO];
    }
    
    
    //    [appearance setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [appearance setBackgroundImage:[UIImage imageWithColor:([UIColor colorWithHexString:@"#3c5c8e"]) size:CGSizeMake(kScreenWidth, kScreenHeight)] forBarMetrics:UIBarMetricsDefault];
    
    [appearance setShadowImage:[[UIImage alloc] init]];
    
    [self setupBarButtonItemTheme];
}

+ (void)setupBarButtonItemTheme {
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    // 设置正常字体颜色
    NSMutableDictionary *textAttrs = [[NSMutableDictionary alloc] init];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    // 设置选中字体颜色
    NSMutableDictionary *disableTextAttrs = [[NSMutableDictionary alloc] init];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [appearance setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
}

// 能拦截所有push进来的控制器
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 如果push的不是栈底控制器(最先push进来的那个控制器)
    if (self.viewControllers.count > 0) {
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClicked)];
        [self.navigationBar setBackgroundImage:[UIImage imageWithColor:([UIColor whiteColor]) size:CGSizeMake(Screen_width, Screen_height)] forBarMetrics:UIBarMetricsDefault];
        leftItem.imageInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        viewController.navigationItem.leftBarButtonItem = leftItem;
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)leftItemClicked {
    [self popViewControllerAnimated:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)prefersStatusBarHidden
{
    UIViewController *last = self.childViewControllers.lastObject;
    if (last) {
        return NO;
    }
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    UIViewController *last = self.childViewControllers.lastObject;
    if (last) {
        return [last preferredStatusBarStyle];
        return UIStatusBarStyleDefault;
    }
    return UIStatusBarStyleLightContent;
}

@end
