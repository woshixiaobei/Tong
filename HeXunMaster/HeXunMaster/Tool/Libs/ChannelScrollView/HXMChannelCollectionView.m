//
//  HXMChannelCollectionVC.m
//  HeXunMaster
//
//  Created by wangmingzhu on 17/3/8.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "HXMChannelCollectionView.h"

@interface HXMChannelCollectionView()

@property (weak, nonatomic) UICollectionViewFlowLayout *flowLayout;

@end

@implementation HXMChannelCollectionView

static NSString *const reuseIdentifier = @"Cell_channel_id";

-(instancetype)init{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.flowLayout = flowLayout;
    if (self = [super initWithFrame:CGRectMake(0, 36, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64- 36) collectionViewLayout:flowLayout]) {
        self.flowLayout.itemSize = CGSizeMake( [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64- 36);
        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.flowLayout.minimumLineSpacing = 0;
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator =NO;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0f) {
            self.prefetchingEnabled = NO;
        }
        self.bounces=NO;
    }
    return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{

    CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (beginningLocation.x > 100) {
        return YES;
    }
    return NO;
}

@end
