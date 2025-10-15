//
//  CNLiveBoxNoticeView.h
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/10/18.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CNLiveBoxNoticeView : UIView


@property (strong, nonatomic) UILabel *contentL;

@property (strong, nonatomic) UIButton *ignoreBtn;

@property (strong, nonatomic) UIButton *checkBtn;

@property (strong, nonatomic) UIView *lineV;

@property (strong, nonatomic) NSDictionary *dic;


+ (CNLiveBoxNoticeView *)showAlertAddedTo:(UIView *)view dic:(NSDictionary *)dic;

- (void)showAlerView;
- (void)hiddenAlerView;

/*** 切换 ***/
@property (nonatomic, copy) void(^clickCheckBtnBlock)(CNLiveBoxNoticeView *view,UIButton *checkBtn);

@end

NS_ASSUME_NONNULL_END
