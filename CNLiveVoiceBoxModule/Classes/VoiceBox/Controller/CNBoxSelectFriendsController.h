//
//  CNBoxSelectFriendsController.h
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/10/9.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNBoxDeviceModel.h"
#import "CNLiveAllVoiceBoxModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNBoxSelectFriendsController : CNCommonViewController

/*** 已选择好友 ***/
@property (nonatomic, strong) NSMutableArray *selectedFriends;
/*** 已邀请过 ***/
@property (nonatomic, strong) NSMutableArray *existedFriends;

@property (copy, nonatomic) NSString *familyID;

/*** 进入邀请好友界面 ***/
- (void)getSelectedFriends;


@end

NS_ASSUME_NONNULL_END
