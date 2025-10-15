//
//  CNLiveBoxNoticeTipView.h
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/10/22.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CNLiveBoxNoticeTipView : UIView

@property (strong, nonatomic) UILabel *contentL;

@property (strong, nonatomic) UIButton *cancelBtn;


@property (strong, nonatomic) NSDictionary *dic;


+ (CNLiveBoxNoticeTipView *)showAlertAddedTo:(UIView *)view dic:(NSDictionary *)dic;

- (void)showAlerView;
- (void)hiddenAlerView;

@end

NS_ASSUME_NONNULL_END
