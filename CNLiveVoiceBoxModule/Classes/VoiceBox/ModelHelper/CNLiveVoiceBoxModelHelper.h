//
//  CNLiveVoiceBoxModelHelper.h
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/9/3.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface CNLiveVoiceBoxModelHelper : NSObject

/**
获取家庭id和对应的设备

*/
+ (void)getFamilyIdAndBoxDetailCompleterBlock:(void (^)(id data, NSError *error))completerBlock;

/*** 获取配网结果 ***/
+ (void)getNetworkResultWithFamilyId:(NSString *)familyId completerBlick:(void (^)(id data, NSError *error))completerBlock;

/*** 使用管理界面 - 获取家庭身份列表 ***/
+ (void)getFamilyRoleWithFamilyId:(NSString *)familyId completerBlick:(void (^)(id data, NSError *error))completerBlock;

/*** 设备远程控制开关 ***/
+ (void)remoteControlDeviceWithType:(NSString *)type completerBlick:(void (^)(id data, NSError *error))completerBlock;

/*** 获取设备在线状态 ***/
+ (void)getBackOnlineTypeCompleterBlick:(void (^)(id data, NSError *error))completerBlock;

/*** 获取设备详情信息 ***/
+ (void)getDeviceDetailMsgWithDeviceId:(NSString *)deviceId completerBlick:(void (^)(id data, NSError *error))completerBlock;

/*** 修改设备名称 ***/
+ (void)updateDeviceNameWithDeviceId:(NSString *)deviceId newName:(NSString *)newName oldName:(NSString *)oldName completerBlick:(void (^)(id data, NSError *error))completerBlock;

/*** 切换接入WiFi接口 ***/
+ (void)changeWiFiWithDeviceId:(NSString *)deviceId name:(NSString *)name passwd:(NSString *)passwd mac:(NSString *)mac completerBlick:(void (^)(id data, NSError *error))completerBlock;

/*** 获取家庭成员列表(用于校验通讯录) ***/
+ (void)getFamilyMemberWithFamilyId:(NSString *)familyId completerBlick:(void (^)(id data, NSError *error))completerBlock;


/*** 获取设置角色列表 ***/
+ (void)getSetRoleListWithFamilyId:(NSString *)familyId completerBlick:(void (^)(id data, NSError *error))completerBlock;

/*** 音箱家庭邀请成员 ***/
+ (void)familyGroupInviteWithMembers:(NSMutableArray *)members completerBlick:(void (^)(id data, NSError *error))completerBlock;

/*** 二维码音箱家庭邀请成员 ***/
+ (void)QRCodeFamilyGroupInviteWithFamilyId:(NSString *)familyId roleId:(NSString *)roleId uuid:(NSString *)uuid completerBlick:(void (^)(id data, NSError *error))completerBlock;

/*** 修改或移出家庭成员身份(删除) ***/
+ (void)updateFamilyMemberRoleWithFamilyId:(NSString *)familyId sid:(NSString *)sid  completerBlick:(void (^)(id data, NSError *error))completerBlock;

/*** 修改或移出家庭成员身份(编辑) ***/
+ (void)editFamilyMemberRoleWithFamilyId:(NSString *)familyId sid:(NSString *)sid role:(NSString *)role  completerBlick:(void (^)(id data, NSError *error))completerBlock;


/*** 音箱设备暂停播放 ***/
+ (void)stopPlaybackDeviceWithSid:(NSString *)sid completerBlick:(void (^)(id data, NSError *error))completerBlock;

/*** 移动播放接口 ***/
+ (void)playbackDeviceWithSid:(NSString *)sid resourceId:(NSString *)resourceId completerBlick:(void (^)(id data, NSError *error))completerBlock ;

/*** 删除设备(解绑) ***/
+ (void)deleteDeviceWithDevId:(NSString *)devid oldName:(NSString *)oldName completerBlick:(void (^)(id data, NSError *error))completerBlock;





@end

NS_ASSUME_NONNULL_END
