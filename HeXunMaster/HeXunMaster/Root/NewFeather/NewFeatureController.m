//
//  NewFeatureController.m
//  TrainingClient
//
//  Created by 李帅 on 15/12/10.
//  Copyright © 2015年 HeXun. All rights reserved.
//

#import "NewFeatureController.h"
#import "HXMLoginViewController.h"
//#import "UIEngine.h"
//#import "CoreEngine.h"
//#import "RegiestViewController.h"

static id _instantce = nil;

const NSTimeInterval kAnimationDuration = 0.25;

@interface NewFeatureController () <UIScrollViewDelegate>
@property (nonatomic, weak) UIPageControl *pageControl; /**< 页码指示器 */

@property (nonatomic, strong) NSArray *textPicArray; /**< 存放顶部文字图片的 */
@property (nonatomic, strong) NSArray *leftPicArray; /**< 存放从左到右的图片 */
@property (nonatomic, strong) NSArray *rightPicArray; /**< 存放从右到左的图片 */
@property (nonatomic, weak) UIButton *regiestButton;

@end

@implementation NewFeatureController

- (NSArray *)textPicArray {
    if (_textPicArray == nil) {
        _textPicArray = @[@"introducePage_1", @"introducePage_2", @"introducePage_3", @"introducePage_4",@"introducePage_5"];
    }
    return _textPicArray;
}

//- (NSArray *)leftPicArray {
//    if (_leftPicArray == nil) {
//        _leftPicArray = @[@"1-1", @"2-1", @"3-1", @"4-1"];
//    }
//    return _leftPicArray;
//}
//- (NSArray *)rightPicArray {
//    if (_rightPicArray == nil) {
//        _rightPicArray = @[@"1-2", @"2-2", @"3-2", @"4-2"];
//    }
//    return _rightPicArray;
//}

+ (instancetype)shareNewFeatherVc {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instantce = [[self alloc] init];
    });
    return _instantce;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建 scroll view
    [self setupScrollView];
    
    // 创建 page control
    [self setupPageControl];
}

- (void)setupScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    // 添加图片
    CGFloat imageW = scrollView.width;
    CGFloat imageH = scrollView.height;
    for (int i = 0; i < self.textPicArray.count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * imageW, 0, imageW, imageH)];
        imageView.image = [UIImage imageNamed:self.textPicArray[i]];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 500 + i;
        [scrollView addSubview:imageView];
        
        
//        if (i == 0) {
//            [self animationView:view withTextPic:self.textPicArray[i] pic1:self.leftPicArray[i] pic2:nil pic3:self.rightPicArray[i] completion:^(BOOL finished) {}];
//        }
    }
    
    // 设置其他属性
    scrollView.contentSize = CGSizeMake(self.textPicArray.count * imageW, 0);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
}

- (void)initializeLastViewButton:(UIView *)view {
    
    @weakify(self)

//    UIView *buttonUnderLine = [[UIView alloc] init];
//    buttonUnderLine.backgroundColor = [UIColor colorWithHexString:@"#6e6e6e"];
//    [view addSubview:buttonUnderLine];
//    
//    // 随便看看
//    UIButton *goToRootVcButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    if ([AccountTool isLogin]) {
//        [goToRootVcButton setTitle:@"立即进入" forState:UIControlStateNormal];
//    } else {
//        [goToRootVcButton setTitle:@"随便看看" forState:UIControlStateNormal];
//    }
//    goToRootVcButton.titleLabel.font = [UIFont systemFontOfSize:16];
//    [goToRootVcButton setTitleColor:[UIColor colorWithHexString:@"#6e6e6e"] forState:UIControlStateNormal];
//    goToRootVcButton.frame = CGRectMake(0, Screen_height - 20 - 44 - 40 - 20, 200, 25);
//    goToRootVcButton.centerX = self.view.centerX;
//    [view addSubview:goToRootVcButton];
//    
////    buttonUnderLine.frame = CGRectMake(goToRootVcButton.x, CGRectGetMaxY(goToRootVcButton.frame), 70, 1);
//    buttonUnderLine.centerX = goToRootVcButton.centerX;
//    
//    [[goToRootVcButton rac_signalForControlEvents:UIControlEventTouchUpInside]
//     subscribeNext:^(id x){
//         
//         @strongify(self)
//         
//         [self toRootVc];
//         
//     }];
    

    CGFloat buttonWidth = Screen_width - 60*2;
    // 立即体验按钮
    UIButton *regiestButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [regiestButton setTitle:@"立即体验" forState:UIControlStateNormal];
    regiestButton.titleLabel.font = [UIFont systemFontOfSize:24];
    [regiestButton setTitle:@"立即体验" forState:UIControlStateHighlighted];
//    regiestButton.titleLabel.textColor = [UIColor colorWithHexString:@"#3c5c8e"];
    [regiestButton setTitleColor:[UIColor colorWithHexString:@"#3c5c8e"] forState:UIControlStateNormal];
    regiestButton.layer.cornerRadius = 25;
    regiestButton.clipsToBounds = YES;
    regiestButton.backgroundColor = [UIColor colorWithHexString:@"#ebf3fc"];
    
    regiestButton.frame = CGRectMake(SCREEN_WIDTH/2, Screen_height*0.83, buttonWidth, 50);
    regiestButton.centerX = self.view.centerX;
    self.regiestButton = regiestButton;

    [[regiestButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x){
         
         @strongify(self)
          [self toRootVc];

     }];
    [view addSubview:regiestButton];
    
    // 登录
//    UIButton *signInButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [signInButton setTitle:@"登录" forState:UIControlStateNormal];
//    signInButton.titleLabel.font = SYSFONT(18.f);
//    signInButton.layer.cornerRadius = 5.0f;
//    signInButton.clipsToBounds = YES;
//    signInButton.backgroundColor = [UIColor colorWithHexString:@"#40adff"];
//    signInButton.frame = CGRectMake(CGRectGetMaxX(regiestButton.frame) + 20, regiestButton.y, regiestButton.width, regiestButton.height);
//    signInButton.hidden = regiestButton.hidden;
//    
//    [[signInButton rac_signalForControlEvents:UIControlEventTouchUpInside]
//     subscribeNext:^(id x){
//         
//         @strongify(self)
//         
//         LoginViewController *loginVc = [[LoginViewController alloc]  initWithAppId:APPID hasThird:YES];
//         HXNavigationViewController *nav = [[HXNavigationViewController alloc] initWithRootViewController:loginVc];
//         loginVc.racDelegate = [RACSubject subject];
//         [loginVc.racDelegate subscribeNext:^(id x){
//             if( [x boolValue] ){
//                 [self toRootVc];
//             }
//         }];
//         
//         [self presentViewController:nav animated:YES completion:nil];
//     }];
//    [view addSubview:signInButton];
    
    
    
}

// 添加pageControl(取决于图片是否有 page indicator)
- (void)setupPageControl {
    // 添加
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = self.textPicArray.count;
    pageControl.centerX = self.view.width * 0.5;
    pageControl.top = self.view.height * 0.93;
    [self.view addSubview:pageControl];
    
    // 设置圆点的颜色
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#5c8fde"];
    pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#d1e0f8"];
    self.pageControl = pageControl;
//    
//    [self.regiestButton mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.pageControl);
//        make.width.mas_equalTo(Screen_width - 60*2);
//    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 获得页码
    CGFloat doublePage = scrollView.contentOffset.x / scrollView.width;
    int intPage = (int)(doublePage + 0.5);

    // 设置页码
    self.pageControl.currentPage = intPage;
    
    CGPoint offset = scrollView.contentOffset;
    
//    if (offset.x > (self.textPicArray.count - 1) * Screen_width + 50) {
//        [self toRootVc];
//    }
    
    int relOffset_x = (int)offset.x;
    int relScreen_width = (int)self.view.bounds.size.width;
    
    // 最后一页隐藏pageControl
//    self.pageControl.hidden = (intPage == self.textPicArray.count - 1);
    
    // 判断什么时候开始动画
    if (relOffset_x % relScreen_width == 0) {
       
        UIView *view = scrollView.subviews[intPage];

//        NSString *pic2 = nil;
//        if (intPage == 3) {
//            pic2 = @"4-1";
//        }
        
        // 如果当前view已经加载过动画，并且有子控件的话就return
        if (view.subviews.count > 0) return;
        
//        [self animationView:view withTextPic:self.textPicArray[intPage] pic1:self.leftPicArray[intPage] pic2:nil pic3:self.rightPicArray[intPage] completion:^(BOOL finished) {
//            for (UIView *subView in scrollView.subviews) {
//                if (subView == view) {
//                    continue;
//                }
//                [subView removeAllSubviews];
//            }
            if (intPage == self.textPicArray.count - 1) {
                [self initializeLastViewButton:view];
            }
//        }];
    }
}

/**
 *  给view增加动画
 *
 *  @param view       view
 *  @param textPic    顶部文字图片
 *  @param pic1       左边1
 *  @param pic2       左边2
 *  @param pic3       右边1
 *  @param completion
 */
//- (void)animationView:(UIView *)view withTextPic:(NSString *)textPic pic1:(NSString *)pic1 pic2:(NSString *)pic2 pic3:(NSString *)pic3 completion:(void (^)(BOOL finished))completion {
//
//    UIImageView *textImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:textPic]];
//    CGSize textImageSize = textImageView.image.size;
//    textImageView.frame = CGRectMake(200, 0, textImageSize.width, textImageSize.height);
//    textImageView.center = CGPointMake(Screen_width / 2, Screen_height / 2 - 105 - 50 -30);
//    textImageView.alpha = 0.3f;
//    
//    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:pic1]];
//    CGSize imageSize = leftImageView.image.size;
//    leftImageView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
//    leftImageView.center = CGPointMake(Screen_width / 2, Screen_height / 2);
//    
//    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:pic3]];
//    rightImageView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
//    rightImageView.center = CGPointMake(Screen_width / 2, Screen_height / 2);
//
//    UIImageView *imageView2 = nil;
//    
//    if ([pic2 isValidString] && view.tag == 503) {
//        imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:pic2]];
//        imageView2.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
//    }
//    
//    imageView2.center = CGPointMake(Screen_width / 2, Screen_height / 2);
//    
//    [UIView animateWithDuration:kAnimationDuration animations:^{
//        textImageView.alpha = 1.0;
//    }];
//    
//    CABasicAnimation *leftImageViewTranslation = [CABasicAnimation animationWithKeyPath:@"position"];
//    leftImageViewTranslation.duration = kAnimationDuration;
//    leftImageViewTranslation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
//    leftImageViewTranslation.removedOnCompletion = NO;
//    leftImageViewTranslation.fillMode = kCAFillModeForwards;
//    leftImageViewTranslation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, Screen_height / 2 )];
//    leftImageViewTranslation.toValue = [NSValue valueWithCGPoint:CGPointMake(Screen_width / 2, Screen_height / 2 )];
//    leftImageViewTranslation.repeatCount = 1;
//    [leftImageView.layer addAnimation:leftImageViewTranslation forKey:@"translation"];
//    
//    CABasicAnimation *rightImageViewTranslation = [CABasicAnimation animationWithKeyPath:@"position"];
//    rightImageViewTranslation.duration = kAnimationDuration;
//    rightImageViewTranslation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
//    rightImageViewTranslation.removedOnCompletion = NO;
//    rightImageViewTranslation.fillMode = kCAFillModeForwards;
//    rightImageViewTranslation.fromValue = [NSValue valueWithCGPoint:CGPointMake(Screen_width, Screen_height / 2 )];
//    rightImageViewTranslation.toValue = [NSValue valueWithCGPoint:CGPointMake(Screen_width / 2, Screen_height / 2)];
//    rightImageViewTranslation.repeatCount = 1;
//    [rightImageView.layer addAnimation:rightImageViewTranslation forKey:@"translation"];
//    
//    if (imageView2 && view.tag == 503) {
//        
//        CABasicAnimation *imageView2Translation = [CABasicAnimation animationWithKeyPath:@"position"];
//        imageView2Translation.duration = kAnimationDuration;
//        imageView2Translation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
//        imageView2Translation.removedOnCompletion = NO;
//        imageView2Translation.fillMode = kCAFillModeForwards;
//        imageView2Translation.fromValue = [NSValue valueWithCGPoint:CGPointMake(Screen_width / 2, Screen_height)];
//        imageView2Translation.toValue = [NSValue valueWithCGPoint:CGPointMake(Screen_width / 2, Screen_height / 2)];
//        imageView2Translation.repeatCount = 1;
//        [imageView2.layer addAnimation:imageView2Translation forKey:@"translation"];
//        
//    }
//
//    [view addSubview:textImageView];
//    [view addSubview:leftImageView];
//    [view addSubview:rightImageView];
//    if (imageView2) {
//        
//        [view addSubview:imageView2];
//    }
//    
//    completion(YES);
//}

- (void)toRootVc {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(NewFeatureToRootVC)]) {
        [self.delegate NewFeatureToRootVC];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
