//
//  CNLiveBoxRoleAlertView.h
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/10/15.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNBoxUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNLiveBoxRoleAlertView : UIView

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) UILabel *tipL;

@property (strong, nonatomic) UIView *lineV;

@property (strong, nonatomic) UIImageView *userImgV;

@property (strong, nonatomic) UILabel *userNameL;

@property (strong, nonatomic) UICollectionView *collectionV;

@property (strong, nonatomic) UIButton *cancleBtn;

@property (strong, nonatomic) UIButton *sureBtn;

@property (strong, nonatomic) UIView *horizontalLine;

@property (strong, nonatomic) UIView *verticalLine;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) CNBoxUserModel *boxUserModel;

@property (strong, nonatomic) NSString *selectRole;
@property (strong, nonatomic) NSString *selectRoleName;


/*** 切换 ***/
@property (nonatomic, copy) void(^clickSureBtnBlock)(CNLiveBoxRoleAlertView *view,UIButton *sureBtn);

+ (CNLiveBoxRoleAlertView *)showAlertAddedTo:(UIView *)view;
- (void)showAlerView;
- (void)hiddenAlerView;


@end

NS_ASSUME_NONNULL_END
