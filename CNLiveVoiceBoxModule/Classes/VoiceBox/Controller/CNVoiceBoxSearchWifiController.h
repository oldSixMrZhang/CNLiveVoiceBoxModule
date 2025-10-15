//
//  CNVoiceBoxSearchWifiController.h
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/9/17.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNBOXDeviceDetailModel.h"
#import "CNBoxDeviceModel.h"

typedef NS_ENUM(NSUInteger, VoiceBoxSearchWifiStatus) {
    VoiceBoxSearchWifiStatusNormal,
    VoiceBoxSearchWifiStatusChange
    
};

NS_ASSUME_NONNULL_BEGIN

@interface CNVoiceBoxSearchWifiController : CNCommonViewController

@property (nonatomic, assign) VoiceBoxSearchWifiStatus wifiStatus;
/*** 内容 ***/
@property (strong, nonatomic) CNBOXDeviceDetailModel *detailModel;

@property (strong, nonatomic) CNBoxDeviceModel *deviceModel;

@end

NS_ASSUME_NONNULL_END
