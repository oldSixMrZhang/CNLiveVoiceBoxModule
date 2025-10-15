//
//  CNBOXInviteFriendsController.h
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/10/11.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNBoxDeviceModel.h"
#import "CNLiveAllVoiceBoxModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNBOXInviteFriendsController : CNCommonViewController

@property (strong, nonatomic) NSMutableArray *inviteFriendsArr;

@property (strong, nonatomic) NSMutableArray *familyTypeArr;

@property (copy, nonatomic) NSString *familyID;


@end

NS_ASSUME_NONNULL_END
