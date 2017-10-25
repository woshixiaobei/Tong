//
//  HXMProfileViewController.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/8.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMProfileViewController.h"
#import <Masonry.h>
#import "UIAlertController+HXAlertViewController.h"
#import "HXMLoginViewController.h"
#import "HXMMycollectionController.h"
#import "HXMProblemFeedbackViewController.h"
#import "HXMHistoryPushViewController.h"
#import "HXMAboutMeViewController.h"
#import "HXMPushToastViewController.h"
#import "HXMHistoryPushViewController.h"

static NSString *profileCell = @"profileCell";

@interface HXMProfileViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *listArray;
@end

@implementation HXMProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self setupUI];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - UITableViewDelegate&&UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section != 2) {
        return 2;
    }else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:profileCell forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:profileCell];
    }
    cell.textLabel.text = self.listArray[indexPath.section][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#000000"];
    if (indexPath.section != 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return cell;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return 0.1f;
    } else if (section == 1) {
        return 10.0f;
    } else {
        return 47.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSLog(@"收藏");
        HXMMycollectionController * vc = [[HXMMycollectionController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 0 && indexPath.row == 1) {
    
        HXMHistoryPushViewController *vc = [[HXMHistoryPushViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        
        HXMProblemFeedbackViewController *vc = [[HXMProblemFeedbackViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 1) {
        
        HXMAboutMeViewController *vc = [[HXMAboutMeViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == 2) {
           [self logout];
        
    }
}

// 退出登录
- (void)logout {
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"你确定退出登录吗?" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {//取消
        return;
    } else if(buttonIndex == 1){//确定
        //退出的时候让下次无论谁进来都是 推送开的
//        [self pushsetONwithoutMBP];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGOUT_SUCCESS object:nil];
        
        [HXMProgressHUD showSuccess:@"注销成功" inview:self.view];
        [self performSelector:@selector(popViewBack) withObject:nil afterDelay:2.0f];
        HXMLoginViewController *vc = [[HXMLoginViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)popViewBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 搭建界面
- (void)setupUI {
    
    UITableView *tv = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tv.rowHeight = 44.f;
    tv.backgroundView.backgroundColor = [UIColor colorWithHexString:@"f4f5f6"];
    [tv registerClass:[UITableViewCell class] forCellReuseIdentifier:profileCell];
    tv.delegate = self;
    tv.dataSource = self;
    tv.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    if (is_Pad) {
        tv.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    [self.view addSubview:tv];
    [tv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

}

#pragma mark - 
- (NSArray *)listArray {

    if (_listArray == nil) {
        _listArray = @[@[@"我的收藏",@"历史推送"],@[@"问题反馈",@"关于我们"],@[@"退出登录"]];
    }
    return _listArray;
}

@end
