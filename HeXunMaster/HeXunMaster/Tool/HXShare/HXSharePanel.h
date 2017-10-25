//
//  SharePanelView.h
//  TrainingClient
//
//  Created by 李帅 on 15/12/23.
//  Copyright © 2015年 HeXun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXShareAPI.h"

@interface HXSharePanel : UIView

#if __has_include("UMSocialConfig.h")

@property (nonatomic, strong, nonnull) HXShareAPI *shareAPI;

@property (nonatomic, copy) void (^ _Nullable dismissCompletion)();
@property (nonatomic, copy) void (^ _Nullable didClickPlatformButton)(NSInteger buttonTag);

- (void)show;

#endif
@end
