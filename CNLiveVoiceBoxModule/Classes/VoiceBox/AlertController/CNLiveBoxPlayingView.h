//
//  CNLiveBoxPlayingView.h
//  CNLiveNetAdd
//
//  Created by cnliveJunBo on 2019/10/19.
//  Copyright © 2019年 cnlive. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CNLiveBoxPlayingView : UIView

@property (strong, nonatomic) UILabel *contentL;

@property (strong, nonatomic) UIButton *ignoreBtn;

+ (void)showAlertAddedTo:(UIView *)view;

+ (void)hideAlerView;

@end

NS_ASSUME_NONNULL_END
