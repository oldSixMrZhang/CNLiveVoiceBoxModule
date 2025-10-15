//
//  CNLiveBoxSuccessView.h
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/10/18.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CNLiveBoxSuccessView : UIView

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) UIImageView *successImgV;

@property (strong, nonatomic) UIButton *cancleBtn;


+ (CNLiveBoxSuccessView *)showAlertAddedTo:(UIView *)view;
- (void)showAlerView;
- (void)hiddenAlerView;

@end

NS_ASSUME_NONNULL_END
