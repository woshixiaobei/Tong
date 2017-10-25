//
//  ActionSharedView.m
//  shareView
//
//  Created by wangmingzhu on 2017/4/19.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import "ActionSharedView.h"
#import "Masonry.h"

@interface ShareItemModle : NSObject

@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *titleName;

@end


@implementation ShareItemModle

- (instancetype)initWithIconName:(NSString *)iconName titleName:(NSString *)titleName {
    self = [super init];
    if (self) {
        self.iconName = iconName;
        self.titleName = titleName;
    }
    return self;
}

@end

@interface ShareCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) ShareItemModle *model;
@property (nonatomic, strong) UIImageView *sharePlatfomIcon;
@property (nonatomic, strong) UILabel *sharePlatfomTitle;

@end

@implementation ShareCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        self.sharePlatfomIcon = [UIImageView new];
        
        
        [self.contentView addSubview:self.sharePlatfomIcon];
        [self.sharePlatfomIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
            make.width.height.mas_equalTo(60);
        }];
        
        self.sharePlatfomTitle = [[UILabel alloc] init];
        
        self.sharePlatfomTitle.textColor = [UIColor colorWithHexString:@"#000000"];
        self.sharePlatfomTitle.font = [UIFont systemFontOfSize:10.0];
        [self.contentView addSubview:self.sharePlatfomTitle];
        [self.sharePlatfomTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sharePlatfomIcon.mas_bottom).offset(7);
            make.centerX.equalTo(self.sharePlatfomIcon);
        }];

    }
    return self;
}

- (void)setModel:(ShareItemModle *)model {
    _model = model;
    self.sharePlatfomIcon.image = [UIImage imageNamed:model.iconName];
    self.sharePlatfomTitle.text = model.titleName;
}

@end

CGFloat SharePanelHeight = 261.0;
@interface ActionSharedView() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UIButton *cancleButton;
@property (nonatomic, weak) UIView *topLine;
@property (nonatomic, weak) UIView *bottomLine;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ActionSharedView{
    NSArray *_titleArray; // 分享面板平台 title 数组
    NSArray *_imageArray; // 分享面板平台 icon 数组
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _imageArray = @[@"share_sina",@"share_wechat",@"share_wechat_time_line",@"share_qq",@"share_qqzone",@"share_copylink"];
        _titleArray = @[@"新浪微博",@"微信",@"朋友圈",@"QQ",@"QQ空间",@"复制链接"];
        
        self.dataSource = [NSMutableArray new];
        
        for (NSInteger i = 0; i < _imageArray.count; i++) {
            ShareItemModle *model = [[ShareItemModle alloc] initWithIconName:[_imageArray objectOrNilAtIndex:i] titleName:[_titleArray objectOrNilAtIndex:i]];
            [self.dataSource addObject:model];
        }
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = [UIColor clearColor];
        
        [self setupUI];
        
        @weakify(self)
        [self setDismissCompletion:^{
            
            [UIView animateWithDuration:kAnimationDurationTime delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
                @strongify(self)
                self.alpha = 0.0;
                
            } completion:^(BOOL finished) {
                @strongify(self)
                [self removeFromSuperview];
            }];
          }];
    }
    return self;
}
- (instancetype)initWithShareHeadOprationWith:(NSArray *)titleArray andImageArry:(NSArray *)imageArr
{
    self = [super init];
    if (self) {
        
//        self.shareBtnImgArray = imageArr;
//        self.shareBtnTitleArray = titleArray;
        _imageArray = @[@"share_sina",@"share_wechat",@"share_wechat_time_line",@"share_qq",@"share_qqzone",@"share_copylink"];
        _titleArray = @[@"新浪微博",@"微信",@"朋友圈",@"QQ",@"QQ空间",@"复制链接"];

        self.dataSource = [NSMutableArray new];
        
        for (NSInteger i = 0; i < _imageArray.count; i++) {
            ShareItemModle *model = [[ShareItemModle alloc] initWithIconName:[_imageArray objectOrNilAtIndex:i] titleName:[_titleArray objectOrNilAtIndex:i]];
            [self.dataSource addObject:model];
        }
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = [UIColor clearColor];
        
        [self setupUI];

        @weakify(self)
        [self setDismissCompletion:^{

                @strongify(self)
                    [UIView animateWithDuration:kAnimationDurationTime delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
                        @strongify(self)
                        self.alpha = 0.0;
                    } completion:^(BOOL finished) {
                        @strongify(self)
                        [self removeFromSuperview];
                    }];
        }];

    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.dismissCompletion) {
        self.dismissCompletion();
    }

}
#pragma mark - 设置界面
- (void)setupUI {

    UIView *topLine = [UIView new];
    topLine.backgroundColor = UIColorHex(#dddcdd);
    self.topLine = topLine;
    [self addSubview:topLine];

    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = (kScreenWidth - 84 - 180)/2.0;
    layout.itemSize = CGSizeMake(60, 80);
    layout.sectionInset = UIEdgeInsetsMake(20, 42, 0, 42);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = UIColorHex(0xf8f8f8);
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:ShareCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(ShareCollectionViewCell.class)];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.backgroundColor = UIColorHex(#ffffff);
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    cancleButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancleButton setTitleColor:UIColorHex(#000000) forState:UIControlStateNormal];
    self.cancleButton = cancleButton;
    [self addSubview:cancleButton];
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.width.equalTo(self);
        make.height.mas_equalTo(48);
    }];
    
    [[cancleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        @strongify(self)
        if (self.dismissCompletion) {
            self.dismissCompletion();
        }
    }];

    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = UIColorHex(#dddcdd);
    self.bottomLine = bottomLine;
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(cancleButton.mas_top);
        make.height.mas_equalTo(0.5);
    }];
    
    [collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(cancleButton.mas_top);
        make.height.equalTo(@212);
    }];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(collectionView.mas_top);
        make.height.mas_equalTo(0.5);
    }];

}

- (void)hideView:(UIButton *)button {
    if (self.dismissCompletion) {
        self.dismissCompletion();
    }
}
- (void)show {
    
    @weakify(self)
    [UIView animateWithDuration:kAnimationDurationTime animations:^{
        @strongify(self)
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(ShareCollectionViewCell.class) forIndexPath:indexPath];
    cell.model = [self.dataSource objectOrNilAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dismissCompletion) {
        self.dismissCompletion();
    }
    
    
    if (self.shareAPI) {
        self.shareAPI.shareType = indexPath.row + 20;
        [self.shareAPI shareResult:^(UMSResponseCode code){
            
        }];
    }
    if (self.didClickPlatformButton) {
        self.didClickPlatformButton(indexPath.row + 20);

    }
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

@end
