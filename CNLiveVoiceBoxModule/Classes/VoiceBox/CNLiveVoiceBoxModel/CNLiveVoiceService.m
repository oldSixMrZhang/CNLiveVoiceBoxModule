//
//  CNLiveVoiceService.m
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/11/19.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import "CNLiveVoiceService.h"

@interface CNLiveVoiceService ()<CNLiveVoiceServiceProtocol>

/** MineVC */
@property (nonatomic ,strong) CNLiveAddDeviceController *addDeviceVC;

@end

@BeeHiveService(CNLiveVoiceServiceProtocol, CNLiveVoiceService)
@implementation CNLiveVoiceService

- (UIViewController *)getVoiceViewController
{
    if (!_addDeviceVC) {
        _addDeviceVC = [[CNLiveAddDeviceController alloc] init];
    }
    return _addDeviceVC;
}


@end
