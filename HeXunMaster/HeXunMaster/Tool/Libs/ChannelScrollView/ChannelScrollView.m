//
//  ChannelScrollView.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/8.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "ChannelScrollView.h"
#import "HXMChannelsView.h"
#import "HXMChannelCollectionView.h"
#import "HXMChannelCollectionViewCell.h"

@interface ChannelScrollView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger pageCount;
@property (weak, nonatomic) HXMChannelsView *channelScorllView;
@property (weak, nonatomic) HXMChannelCollectionView *collectionView;
@property (nonatomic, strong) NSArray *channels;
@property (nonatomic, strong) NSMutableDictionary *controllerCache;

@end

static NSString *ReuseIdentifier = @"ChannelScrollView";

@implementation ChannelScrollView


+ (instancetype)GetChannelScrollViewContorllerWithChannelDatas:(NSArray*) channels pageChannelCount:(NSInteger) pageCount{
    
    ChannelScrollView *channelVC = [[ChannelScrollView alloc]init];
    channelVC.pageCount = pageCount;
    channelVC.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    channelVC.channels = channels;
    [channelVC setupUI];
    return channelVC;
}


- (void)setupUI{
    
    self.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [self setUpChannelView];
    [self setupContentView];
    [self.collectionView registerClass:[HXMChannelCollectionViewCell class] forCellWithReuseIdentifier:ReuseIdentifier];
}


-(void)setUpChannelView{
  

    HXMChannelsView *channelView = [[HXMChannelsView alloc]initWithChannels:self.channels pageCount:self.pageCount];
    [self addSubview:channelView];
    self.channelScorllView = channelView;
    __weak __typeof__(self) weakSelf = self;
    channelView.clickChannel = ^(NSInteger index){
        [weakSelf.collectionView setContentOffset:CGPointMake(weakSelf.collectionView.bounds.size.width *index, 0) animated:YES];
    };
    UIImageView * iv1 = [[UIImageView alloc] init];
    iv1.frame = CGRectMake(0, 0, 30, 36);
    UIImage * image1 = [UIImage imageNamed:@"headerLeft"];
    iv1.image = image1;
    [self addSubview:iv1];
    UIImageView * iv2 = [[UIImageView alloc] init];
    iv2.frame = CGRectMake(SCREEN_WIDTH - 30, 0, 30, 36);
    UIImage * image2 = [UIImage imageNamed:@"headerRight"];
    iv2.image = image2;
    [self addSubview:iv2];
    
    UILabel *bottomLabel = [[UILabel alloc]init];
    bottomLabel.height = 0.5f;
    bottomLabel.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    bottomLabel.frame = CGRectMake(0, 35.5f, SCREEN_WIDTH, 0.5f);
    [self addSubview:bottomLabel];

}


-(void)setupContentView{
    
    HXMChannelCollectionView *collectionview = [[HXMChannelCollectionView alloc]init];
    self.collectionView = collectionview;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
}


- (UIViewController *)showsVc:(NSString *)titile IndexPath:(NSIndexPath*) indexpath{
    
    UIViewController *showsVc = self.controllerCache[titile];
    if (showsVc == nil) {
        UIViewController *typeVc = [self.delegate ChannelScrollView:self ViewcontrollerForItemAtIndexPath:indexpath];
        if (titile != nil) {
            [self.controllerCache setObject:typeVc forKey:titile];
        }
        return typeVc;
    }
    return showsVc;
}


- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.channels.count;
}


- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HXMChannelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    UIViewController *showsVC = [self showsVc:[self.channels objectOrNilAtIndex:indexPath.item] IndexPath:indexPath];
    cell.showsVc = showsVC;
    return cell;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x /scrollView.bounds.size.width;
    self.channelScorllView.index = index;
    [self.channelScorllView lastScrollCenterMethod];
}


- (NSMutableDictionary *)controllerCache{
    
    if (_controllerCache == nil) {
        _controllerCache = [NSMutableDictionary dictionary];
    }
    return _controllerCache;
}



@end
