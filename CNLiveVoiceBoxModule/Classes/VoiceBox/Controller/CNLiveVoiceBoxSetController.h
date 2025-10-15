//
//  CNLiveVoiceBoxSetController.h
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/9/16.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNBoxDeviceModel.h"
#import "CNLiveAllVoiceBoxModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNLiveVoiceBoxSetController : CNCommonViewController

@property (strong, nonatomic) CNBoxDeviceModel *deviceModel;

@property (strong, nonatomic) CNLiveAllVoiceBoxModel *boxModel;

@property (strong, nonatomic) NSString *familyId;

@property (copy, nonatomic) NSString *isMaster;




@end

NS_ASSUME_NONNULL_END
