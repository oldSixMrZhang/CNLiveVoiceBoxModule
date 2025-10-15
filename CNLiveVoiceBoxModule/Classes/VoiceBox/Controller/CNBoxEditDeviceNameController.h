//
//  CNBoxEditDeviceController.h
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/10/9.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNBoxDeviceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNBoxEditDeviceNameController : CNCommonViewController

@property (strong, nonatomic) NSString *boxNameStr;

@property (copy, nonatomic) NSString *deviceID;

@property (copy, nonatomic) NSString *isMaster;

@end

NS_ASSUME_NONNULL_END
