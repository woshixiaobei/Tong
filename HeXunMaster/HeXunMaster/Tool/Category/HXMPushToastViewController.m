//
//  HXMPushToastViewController.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/5/3.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMPushToastViewController.h"

@interface HXMPushToastViewController ()

@end

@implementation HXMPushToastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupUI {

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"!!!!!" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"111" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"222" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    view.frame = CGRectMake(0, 0, 20, 20);
    [alertVC.view addSubview:view];
    
    [self presentViewController:alertVC animated:YES completion:nil];

    

}
@end
