//
//  CNBoxUserManagerController.h
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/10/9.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNBoxDeviceModel.h"
#import "CNLiveAllVoiceBoxModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNBoxUserManagerController : CNCommonViewController

/*** 获取家庭人员列表 ***/
- (void)loadData;

@property (copy, nonatomic) NSString *familyID;


@end

NS_ASSUME_NONNULL_END
