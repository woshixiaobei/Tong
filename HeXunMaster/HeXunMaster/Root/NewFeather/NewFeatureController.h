//
//  NewFeatureController.h
//  TrainingClient
//
//  Created by 李帅 on 15/12/10.
//  Copyright © 2015年 HeXun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewFeatureVCDelegate;

@interface NewFeatureController : UIViewController

@property (nonatomic, weak) id<NewFeatureVCDelegate> delegate;

+ (instancetype)shareNewFeatherVc;

@end


@protocol NewFeatureVCDelegate <NSObject>
//
- (void)NewFeatureToRootVC;

@end
