//
//  ActionSharedView.h
//  shareView
//
//  Created by wangmingzhu on 2017/4/19.
//  Copyright © 2017年 wangmingzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXShareAPI.h"
//#if __has_include("UMSocialConfig.h")
@interface ActionSharedView : UIView

#if __has_include("UMSocialConfig.h")

@property (nonatomic, strong, nonnull) HXShareAPI *shareAPI;
@property (nonatomic, copy) void (^ _Nullable dismissCompletion)();
@property (nonatomic, copy) void (^ _Nullable didClickPlatformButton)(NSInteger buttonTag);
- (instancetype)initWithShareHeadOprationWith:(NSArray *)titleArray andImageArry:(NSArray *)imageArr;

//@property (nonatomic, copy) void(^clickedImageCallback)(NSInteger imageIndex, NSString * title);
- (void)show;
#endif

@end
