//
//  HXMAllModuleViewController.m
//  HeXunMaster
//
//  Created by wangmingzhu on 2017/3/20.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMAllModuleViewController.h"
#import "HXMStatisticsLevelCollectionCell.h"
#import "UIBarButtonItem+Extension.h"
#import "HXMCommonModuleModel.h"
#import "HXMCommonModuleViewModel.h"
#import "HXMMycollectionController.h"
#import "HXMHistoryPushViewController.h"
#import "HXMProblemFeedbackViewController.h"

#if __has_include(<MobClickInOne/MobClick.h>)&&__has_include(<MobClickInOne/DplusMobClick.h>)//dplus兼容
#import <MobClickInOne/MobClick.h>
#import <MobClickInOne/DplusMobClick.h>
#elif __has_include(<UMMobClick/MobClick.h>)
#import <UMMobClick/MobClick.h>
#else
#import "MobClick.h"
#endif
#import "MobClick+HXDataAnalytics.h"

static NSString *headerId = @"headerId";

@interface HXMAllModuleViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionReusableView *headerView;
//组头
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) HXMCommonModuleModel *itemModel;
@property (nonatomic, strong) HXMCommonModuleViewModel *commonModuleViewModel;
@end

@implementation HXMAllModuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self initCommonModule];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)initCommonModule {
    
    NSFileManager* fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:kAllModuleFile]) {
        self.allModuleListArrayM = [NSKeyedUnarchiver unarchiveObjectWithFile:kAllModuleFile];
        [self.collectionView reloadData];
    } else {
        
        @weakify(self)
        [HXMProgressHUD showInView:self.view];
        [[self.commonModuleViewModel.requestCommonListCommand execute:nil] subscribeNext:^(id x) {
            
            [HXMProgressHUD hide];
            @strongify(self)
            [NSKeyedArchiver archiveRootObject:x toFile:kAllModuleFile];
            self.allModuleListArrayM = x;
            [self.collectionView reloadData];
            
        } error:^(NSError *error) {
            [HXMProgressHUD hide];
            [HXMProgressHUD showError:@"请求失败，请重新加载..." inview:self.view];
            NSLog(@"%@",error);
        } completed:^{
            NSLog(@"completed");
        }];
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
   
    self.itemModel = [[self.allModuleListArrayM objectOrNilAtIndex:indexPath.section] objectOrNilAtIndex:indexPath.item];
    NSString * name = self.itemModel.module_name;
    NSString * model_id = self.itemModel.module_id;
    NSInteger moduleTag = self.itemModel.module_tag;
   
    if (moduleTag == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CommonModuleToPushNewsNotification" object:nil userInfo:@{@"name":name,@"id":model_id,@"moduleTag":@(moduleTag)}];
        
    } else if(moduleTag == 2) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CommonModuleToPushInformationNotification" object:nil userInfo:@{@"name":name,@"id":model_id,@"moduleTag":@(moduleTag)}];
        
    } else if (moduleTag == 3){
        if (indexPath.row == 0) {
            HXMMycollectionController *vc = [[HXMMycollectionController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        } else if (indexPath.row == 1) {
            HXMHistoryPushViewController *vc = [[HXMHistoryPushViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (indexPath.row == 2) {
            HXMProblemFeedbackViewController *vc = [[HXMProblemFeedbackViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.allModuleListArrayM.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.allModuleListArrayM[section].count;
}

- (HXMStatisticsLevelCollectionCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseIdentifier=[NSString stringWithFormat:@"%ld%ldCollectionCell",(long)indexPath.section,(long)indexPath.row];
    [self.collectionView registerClass:[HXMStatisticsLevelCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
    HXMStatisticsLevelCollectionCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.model = [[self.allModuleListArrayM objectOrNilAtIndex:indexPath.section] objectOrNilAtIndex: indexPath.row];
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(SCREEN_WIDTH, 60);
}

//组头
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
        for (UIView * view in headerView.subviews) {
            [view removeFromSuperview];
        }
        headerView.backgroundColor = [UIColor whiteColor];
        UIView *grayLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        grayLineView.backgroundColor = [UIColor colorWithHexString:@"#f4f5f6"];
        [headerView addSubview:grayLineView];
        [grayLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(headerView);
            make.height.equalTo(@10);
        }];
        
        UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        [headerView addSubview: contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(grayLineView.mas_bottom);
            make.left.right.bottom.equalTo(headerView);
        }];
        
        UILabel * headerLabel = [[UILabel alloc] init];
        headerLabel.text = @"新闻类";
        headerLabel.textColor = [UIColor colorWithHexString:@"#3c5c8e"];
        headerLabel.font = [UIFont systemFontOfSize:15];
        [contentView addSubview:headerLabel];
        [headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).offset(24);
            make.centerY.equalTo(contentView);
        }];
        
        UIView * lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
        [contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerLabel);
            make.right.equalTo(contentView).offset(-24);
            make.bottom.equalTo(contentView);
            make.height.mas_equalTo(0.5);
        }];
        if (indexPath.section == 0) {
            [grayLineView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
            headerLabel.text = @"新闻类";
        } else if (indexPath.section == 1) {
            headerLabel.text = @"情报类";
        } else if (indexPath.section == 2) {
            headerLabel.text = @"功能类";
        }
        return headerView;
    }
    
    return nil;
}


#pragma mark - 设置界面
- (void)setupUI {
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"全部模块";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"back_icon" target:self action:@selector(back)];
    
    
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (UICollectionView *)collectionView {
    
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(Screen_width / 4, 100);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.headerReferenceSize = CGSizeMake(50, 50);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height -64) collectionViewLayout:flowLayout];

        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    }
    
    return _collectionView;
    
}

- (NSArray<NSArray *> *)allModuleListArrayM {
    
    if (_allModuleListArrayM == nil) {
        _allModuleListArrayM = [NSArray array];
    }
    return _allModuleListArrayM;
    
}
- (HXMCommonModuleViewModel *)commonModuleViewModel {
    
    if (_commonModuleViewModel == nil) {
        _commonModuleViewModel = [[HXMCommonModuleViewModel alloc]init];
    }
    return _commonModuleViewModel;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
