//
//  CNLiveBoxTipAlertView.h
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/9/19.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CNLiveBoxWIFITipAlertView : UIView

@property (strong, nonatomic) UIView *bgView;

@property (strong, nonatomic) UILabel *contenL;

@property (strong, nonatomic) UITextField *enterTF;

@property (strong, nonatomic) UIButton *showPWBtn;

@property (strong, nonatomic) UIView *bottomLineV;


@property (strong, nonatomic) UIButton *cancleBtn;

@property (strong, nonatomic) UIButton *sureBtn;

@property (strong, nonatomic) UIView *horizontalLine;

@property (strong, nonatomic) UIView *verticalLine;

+ (CNLiveBoxWIFITipAlertView *)showAlertAddedTo:(UIView *)view;
- (void)showAlerView;
- (void)hiddenAlerView;



@end

NS_ASSUME_NONNULL_END
