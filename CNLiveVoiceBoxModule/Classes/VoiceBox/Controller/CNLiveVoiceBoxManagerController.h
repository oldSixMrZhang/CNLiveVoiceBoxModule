//
//  CNLiveVoiceBoxManagerController.h
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/9/18.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNBoxDeviceModel.h"
#import "CNLiveAllVoiceBoxModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNLiveVoiceBoxManagerController : CNCommonViewController

@property (strong, nonatomic) CNBoxDeviceModel *deviceModel;

@property (strong, nonatomic) CNLiveAllVoiceBoxModel *boxModel;


@property (copy, nonatomic) NSString *isMaster;

@end

NS_ASSUME_NONNULL_END
