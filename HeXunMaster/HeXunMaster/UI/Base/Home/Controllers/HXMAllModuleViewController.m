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


static NSString *headerId = @"headerId";

@interface HXMAllModuleViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;



@end

@implementation HXMAllModuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    

    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSInteger items = 0;
    switch (section) {
        case 0:
            items = 6;
            break;
        case 1:
            items = 5;
            break;
        case 2:
            items = 3;
            break;
            
        default:
            break;
    }

    return items;
    
}

- (HXMStatisticsLevelCollectionCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseIdentifier=[NSString stringWithFormat:@"%ld%ldCollectionCell",(long)indexPath.section,(long)indexPath.row];
    [self.collectionView registerClass:[HXMStatisticsLevelCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
    HXMStatisticsLevelCollectionCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
    
}
//组头
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    if (kind == UICollectionElementKindSectionHeader) {

        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel * headerLabel = [[UILabel alloc] init];
        headerLabel.text = @"新闻类";
        headerLabel.textColor = [UIColor colorWithHexString:@"#3c5c8e"];
        headerLabel.font = [UIFont systemFontOfSize:15];
        [headerView addSubview:headerLabel];
        [headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView).offset(24);
            make.centerY.equalTo(headerView);
        }];
        
        UIView * lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
        [headerView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerLabel);
            make.right.equalTo(headerView).offset(-24);
            make.bottom.equalTo(headerView);
            make.height.mas_equalTo(1);
        }];
        
        return headerView;
    }
    
    return nil;
}

#pragma mark - 设置界面
- (void)setupUI {
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"back_icon" title:@"" target:self action:@selector(back)];
    
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
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height -115) collectionViewLayout:flowLayout];
        _collectionView.scrollsToTop = YES;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    }
    
    return _collectionView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
