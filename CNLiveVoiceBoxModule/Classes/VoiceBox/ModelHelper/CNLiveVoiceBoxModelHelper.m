//
//  CNLiveVoiceBoxModelHelper.m
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/9/3.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import "CNLiveVoiceBoxModelHelper.h"

////获取家庭ID
//#define CNBoxGetFamilyIDAndDetailUrl                cn_API_Host(@"/Daren/sound/getFamilyList.action")
//
////获取家庭ID
//#define CNBoxGetNetworkResultUrl                cn_API_Host(@"/Daren/sound/getNetworkResult.action")
//
////获取家庭身份列表
//#define CNBoxGetFamilyRoletUrl                cn_API_Host(@"/Daren/sound/getFamilyRole.action")
//
////设备远程控制开关
//#define CNBoxRemoteControlDeviceUrl cn_API_Host(@"/Daren/sound/remoteControlStatus.action")
////获取设备在线状态
//#define CNBOXGetBackOnlineTypeUrl cn_API_Host(@"/Daren/sound/getRemoteControlStatus.action")
////获取设备详情信息
//#define CNBOXGetDeviceDetailMsgUrl cn_API_Host(@"/Daren/sound/getDeviceDetailMsg.action")
//
////修改设备名称
//#define CNBOXUpdateDeviceNameUrl cn_API_Host(@"/Daren/sound/updateDeviceName.action")
////切换接入WIFI接口
//#define CNBOXChangeWIFIUrl cn_API_Host(@"/Daren/sound/changeWiFi.action")
//
////获取家庭成员列表(用于校验通讯录)
//#define CNBOXGetFamilyMemberUrl cn_API_Host(@"/Daren/sound/getFamilyMember.action")
//
////获取设置角色列表
//#define CNBOXGetSetRoleListUrl cn_API_Host(@"/Daren/sound/getSetRoleList.action")
//
////音箱家庭邀请成员
//#define CNBOXFamilyGroupInviteYDUrl cn_API_Host(@"/Daren/sound/familyGroupInviteYD.action")
//
////修改或移出家庭成员身份(删除)
//#define CNBOXUpdateFamilyMemberRoleUrl cn_API_Host(@"/Daren/sound/updateFamilyMemberRole.action")
//
//
////音箱设备暂停播放
//#define CNBOXStopPlaybackDeviceUrl cn_API_Host(@"/Daren/sound/stopPlaybackDevice.action")
//
////移动播放接口
//#define CNBOXPlaybackDeviceUrl cn_API_Host(@"/Daren/sound/playbackDevice.action")
//
////解绑设备
//#define CNBOXDeleteDeviceUrl cn_API_Host(@"/Daren/sound/deleteDevice.action")

@implementation CNLiveVoiceBoxModelHelper



#pragma mark - 接口


/**
 获取家庭id和对应的设备
 
 */
+ (void)getFamilyIdAndBoxDetailCompleterBlock:(void (^)(id data, NSError *error))completerBlock {
    
    // http://apiwjjtest.cnlive.com/Daren/sound/getFamilyList.action
    //@param sid sid
    //@param phone 手机号
    
    NSString *strUrl = CNBoxGetFamilyIDAndDetailUrl;
    NSDictionary *dict = @{
        @"sid": [NSString stringWithFormat:@"%@",CNUserShareModel.uid],
        @"phone":[NSString stringWithFormat:@"%@",CNUserShareModel.mobile]
    };
    
    [CNLiveNetworking setAllowRequestDefaultArgument:YES];
    [CNLiveNetworking setupShowDataResult:NO];
    [CNLiveNetworking requestNetworkWithMethod:CNLiveRequestMethodGET URLString:strUrl Param:dict CacheType:CNLiveNetworkCacheTypeNetworkOnly CompletionBlock:^(NSURLSessionTask *requestTask, id responseObject, NSError *error) {
        
        NSLog(@"家庭音箱详情数据 = %@",responseObject);
        
        NSString *resultCode = [NSString stringWithFormat:@"%@", responseObject[@"errorCode"]];
        NSError *err = nil;
        id data = nil;
        if([resultCode isEqualToString:@"0"]) {
            data = responseObject[@"data"];
        } else {
            @try {
                err = [[NSError alloc] initWithDomain:responseObject[@"errorMessage"] code:[resultCode integerValue] userInfo:nil];
            } @catch (NSException *exception) {
                err = [[NSError alloc] initWithDomain:@"接口异常" code:500 userInfo:nil];
            }
        }
        
        if (completerBlock) {
            if (error) {
                err = error;
            }
            completerBlock(data,err);
        }
        
    }];
    
}

/*** 获取配网结果 ***/
+ (void)getNetworkResultWithFamilyId:(NSString *)familyId completerBlick:(void (^)(id data, NSError *error))completerBlock {
    //http://apiwjjtest.cnlive.com/Daren/sound/getNetworkResult.action
    //@param sid sid
    //@param phone 手机号
    
    NSString *strUrl = CNBoxGetNetworkResultUrl;
    NSDictionary *dict = @{
        @"familyId": [NSString stringWithFormat:@"%@",familyId]
    };
    
    [CNLiveNetworking setAllowRequestDefaultArgument:YES];
    [CNLiveNetworking setupShowDataResult:NO];
    [CNLiveNetworking requestNetworkWithMethod:CNLiveRequestMethodPOST URLString:strUrl Param:dict CacheType:CNLiveNetworkCacheTypeNetworkOnly CompletionBlock:^(NSURLSessionTask *requestTask, id responseObject, NSError *error) {
        
        NSLog(@"家庭音箱详情数据 = %@",responseObject);
        
        NSString *resultCode = [NSString stringWithFormat:@"%@", responseObject[@"errorCode"]];
        NSError *err = nil;
        id data = nil;
        if([resultCode isEqualToString:@"0"]) {
            data = responseObject[@"data"];
        } else {
            @try {
                err = [[NSError alloc] initWithDomain:responseObject[@"errorMessage"] code:[resultCode integerValue] userInfo:nil];
            } @catch (NSException *exception) {
                err = [[NSError alloc] initWithDomain:@"接口异常" code:500 userInfo:nil];
            }
        }
        
        if (completerBlock) {
            if (error) {
                err = error;
            }
            completerBlock(data,err);
        }
        
    }];
}

/*** 获取家庭身份列表 ***/
+ (void)getFamilyRoleWithFamilyId:(NSString *)familyId completerBlick:(void (^)(id data, NSError *error))completerBlock {
    //http://apiwjjtest.cnlive.com/Daren/sound/getFamilyRole.action
    //@param sid sid
    //@param phone 手机号
    
    NSString *strUrl = CNBoxGetFamilyRoletUrl;
    NSDictionary *dict = @{
        @"familyId": [NSString stringWithFormat:@"%@",familyId],
        @"sid": [NSString stringWithFormat:@"%@",CNUserShareModel.uid],
        @"phone":[NSString stringWithFormat:@"%@",CNUserShareModel.mobile]
    };
    
    [CNLiveNetworking setAllowRequestDefaultArgument:YES];
    [CNLiveNetworking setupShowDataResult:NO];
    [CNLiveNetworking requestNetworkWithMethod:CNLiveRequestMethodPOST URLString:strUrl Param:dict CacheType:CNLiveNetworkCacheTypeNetworkOnly CompletionBlock:^(NSURLSessionTask *requestTask, id responseObject, NSError *error) {
        
        NSLog(@"家庭音箱详情数据 = %@",responseObject);
        
        NSString *resultCode = [NSString stringWithFormat:@"%@", responseObject[@"errorCode"]];
        NSError *err = nil;
        id data = nil;
        if([resultCode isEqualToString:@"0"]) {
            data = responseObject[@"data"];
        } else {
            @try {
                err = [[NSError alloc] initWithDomain:responseObject[@"errorMessage"] code:[resultCode integerValue] userInfo:nil];
            } @catch (NSException *exception) {
                err = [[NSError alloc] initWithDomain:@"接口异常" code:500 userInfo:nil];
            }
        }
        
        if (completerBlock) {
            if (error) {
                err = error;
            }
            completerBlock(data,err);
        }
        
    }];
}

/*** 设备远程控制开关 0开启  1关闭 ***/
+ (void)remoteControlDeviceWithType:(NSString *)type completerBlick:(void (^)(id data, NSError *error))completerBlock {
    //http://apiwjjtest.cnlive.com/Daren/sound/remoteControlStatus.action
    //@param sid sid
    //@param phone 手机号
    
    NSString *strUrl = CNBoxRemoteControlDeviceUrl;
    NSDictionary *dict = @{
        @"sid": [NSString stringWithFormat:@"%@",CNUserShareModel.uid],
        @"type": [NSString stringWithFormat:@"%@",type]
    };
    
    [CNLiveNetworking setAllowRequestDefaultArgument:YES];
    [CNLiveNetworking setupShowDataResult:NO];
    [CNLiveNetworking requestNetworkWithMethod:CNLiveRequestMethodPOST URLString:strUrl Param:dict CacheType:CNLiveNetworkCacheTypeNetworkOnly CompletionBlock:^(NSURLSessionTask *requestTask, id responseObject, NSError *error) {
        
        NSLog(@"家庭音箱详情数据 = %@",responseObject);
        
        NSString *resultCode = [NSString stringWithFormat:@"%@", responseObject[@"errorCode"]];
        NSError *err = nil;
        id data = nil;
        if([resultCode isEqualToString:@"0"]) {
            data = responseObject[@"data"];
        } else {
            @try {
                err = [[NSError alloc] initWithDomain:responseObject[@"errorMessage"] code:[resultCode integerValue] userInfo:nil];
            } @catch (NSException *exception) {
                err = [[NSError alloc] initWithDomain:@"接口异常" code:500 userInfo:nil];
            }
        }
        
        if (completerBlock) {
            if (error) {
                err = error;
            }
            completerBlock(data,err);
        }
        
    }];
}

/*** 获取设备在线状态 ***/
+ (void)getBackOnlineTypeCompleterBlick:(void (^)(id data, NSError *error))completerBlock {
    //http://apiwjjtest.cnlive.com/Daren/sound/getRemoteControlStatus.action
    //@param sid sid
    //@param phone 手机号
    
    NSString *strUrl = CNBOXGetBackOnlineTypeUrl;
    NSDictionary *dict = @{
        @"sid": [NSString stringWithFormat:@"%@",CNUserShareModel.uid]
    };
    
    [CNLiveNetworking setAllowRequestDefaultArgument:YES];
    [CNLiveNetworking setupShowDataResult:NO];
    [CNLiveNetworking requestNetworkWithMethod:CNLiveRequestMethodPOST URLString:strUrl Param:dict CacheType:CNLiveNetworkCacheTypeNetworkOnly CompletionBlock:^(NSURLSessionTask *requestTask, id responseObject, NSError *error) {
        
        NSLog(@"家庭音箱详情数据 = %@",responseObject);
        
        NSString *resultCode = [NSString stringWithFormat:@"%@", responseObject[@"errorCode"]];
        NSError *err = nil;
        id data = nil;
        if([resultCode isEqualToString:@"0"]) {
            data = responseObject[@"data"];
        } else {
            @try {
                err = [[NSError alloc] initWithDomain:responseObject[@"errorMessage"] code:[resultCode integerValue] userInfo:nil];
            } @catch (NSException *exception) {
                err = [[NSError alloc] initWithDomain:@"接口异常" code:500 userInfo:nil];
            }
        }
        
        if (completerBlock) {
            if (error) {
                err = error;
            }
            completerBlock(data,err);
        }
        
    }];
}

/*** 获取设备详情信息 ***/
+ (void)getDeviceDetailMsgWithDeviceId:(NSString *)deviceId completerBlick:(void (^)(id data, NSError *error))completerBlock {
    //http://apiwjjtest.cnlive.com/Daren/sound/getDeviceDetailMsg.action
    //@param sid sid
    //@param phone 手机号
    
    NSString *strUrl = CNBOXGetDeviceDetailMsgUrl;
    NSDictionary *dict = @{
        @"devId": [NSString stringWithFormat:@"%@",deviceId]
    };
    
    [CNLiveNetworking setAllowRequestDefaultArgument:YES];
    [CNLiveNetworking setupShowDataResult:NO];
    [CNLiveNetworking requestNetworkWithMethod:CNLiveRequestMethodGET URLString:strUrl Param:dict CacheType:CNLiveNetworkCacheTypeNetworkOnly CompletionBlock:^(NSURLSessionTask *requestTask, id responseObject, NSError *error) {
        
        NSLog(@"家庭音箱详情数据 = %@",responseObject);
        
        NSString *resultCode = [NSString stringWithFormat:@"%@", responseObject[@"errorCode"]];
        NSError *err = nil;
        id data = nil;
        if([resultCode isEqualToString:@"0"]) {
            data = responseObject[@"data"];
        } else {
            @try {
                err = [[NSError alloc] initWithDomain:responseObject[@"errorMessage"] code:[resultCode integerValue] userInfo:nil];
            } @catch (NSException *exception) {
                err = [[NSError alloc] initWithDomain:@"接口异常" code:500 userInfo:nil];
            }
        }
        
        if (completerBlock) {
            if (error) {
                err = error;
            }
            completerBlock(data,err);
        }
        
    }];
}


/*** 修改设备名称 ***/
+ (void)updateDeviceNameWithDeviceId:(NSString *)deviceId newName:(NSString *)newName oldName:(NSString *)oldName completerBlick:(void (^)(id data, NSError *error))completerBlock {
    //http://apiwjjtest.cnlive.com/Daren/sound/updateDeviceName.action
    //@param sid sid
    //@param phone 手机号
    
    NSString *strUrl = CNBOXUpdateDeviceNameUrl;
    NSDictionary *dict = @{
        @"devId": [NSString stringWithFormat:@"%@",deviceId],
        @"newName": [NSString stringWithFormat:@"%@",newName],
        @"oldName": [NSString stringWithFormat:@"%@",oldName]
    };
    
    [CNLiveNetworking setAllowRequestDefaultArgument:YES];
    [CNLiveNetworking setupShowDataResult:NO];
    [CNLiveNetworking requestNetworkWithMethod:CNLiveRequestMethodPOST URLString:strUrl Param:dict CacheType:CNLiveNetworkCacheTypeNetworkOnly CompletionBlock:^(NSURLSessionTask *requestTask, id responseObject, NSError *error) {
        
        NSLog(@"家庭音箱详情数据 = %@",responseObject);
        
        NSString *resultCode = [NSString stringWithFormat:@"%@", responseObject[@"errorCode"]];
        NSError *err = nil;
        id data = nil;
        if([resultCode isEqualToString:@"0"]) {
            data = responseObject[@"data"];
        } else {
            @try {
                err = [[NSError alloc] initWithDomain:responseObject[@"errorMessage"] code:[resultCode integerValue] userInfo:nil];
            } @catch (NSException *exception) {
                err = [[NSError alloc] initWithDomain:@"接口异常" code:500 userInfo:nil];
            }
        }
        
        if (completerBlock) {
            if (error) {
                err = error;
            }
            completerBlock(data,err);
        }
        
    }];
}


/*** 切换接入WiFi接口 ***/
+ (void)changeWiFiWithDeviceId:(NSString *)deviceId name:(NSString *)name passwd:(NSString *)passwd mac:(NSString *)mac completerBlick:(void (^)(id data, NSError *error))completerBlock {
    //http://apiwjjtest.cnlive.com/Daren/sound/changeWiFi.action
    //@param sid sid
    //@param phone 手机号
    
    NSString *strUrl = CNBOXChangeWIFIUrl;
    NSDictionary *dict = @{
        @"devId": [NSString stringWithFormat:@"%@",deviceId],
        @"name": [NSString stringWithFormat:@"%@",name],
        @"passwd": [NSString stringWithFormat:@"%@",passwd],
        @"mac": [NSString stringWithFormat:@"%@",mac]
    };
    
    [CNLiveNetworking setAllowRequestDefaultArgument:YES];
    [CNLiveNetworking setupShowDataResult:NO];
    [CNLiveNetworking requestNetworkWithMethod:CNLiveRequestMethodPOST URLString:strUrl Param:dict CacheType:CNLiveNetworkCacheTypeNetworkOnly CompletionBlock:^(NSURLSessionTask *requestTask, id responseObject, NSError *error) {
        
        NSLog(@"家庭音箱详情数据 = %@",responseObject);
        
        NSString *resultCode = [NSString stringWithFormat:@"%@", responseObject[@"errorCode"]];
        NSError *err = nil;
        id data = nil;
        if([resultCode isEqualToString:@"0"]) {
            data = responseObject[@"data"];
        } else {
            @try {
                err = [[NSError alloc] initWithDomain:responseObject[@"errorMessage"] code:[resultCode integerValue] userInfo:nil];
            } @catch (NSException *exception) {
                err = [[NSError alloc] initWithDomain:@"接口异常" code:500 userInfo:nil];
            }
        }
        
        if (completerBlock) {
            if (error) {
                err = error;
            }
            completerBlock(data,err);
        }
        
    }];
}


/*** 获取家庭成员列表(用于校验通讯录) ***/
+ (void)getFamilyMemberWithFamilyId:(NSString *)familyId completerBlick:(void (^)(id data, NSError *error))completerBlock {
    //http://apiwjjtest.cnlive.com/Daren/sound/getFamilyMember.action
    //@param sid sid
    //@param phone 手机号
    
    NSString *strUrl = CNBOXGetFamilyMemberUrl;
    NSDictionary *dict = @{
        @"familyId": [NSString stringWithFormat:@"%@",familyId]
    };
    
    [CNLiveNetworking setAllowRequestDefaultArgument:YES];
    [CNLiveNetworking setupShowDataResult:NO];
    [CNLiveNetworking requestNetworkWithMethod:CNLiveRequestMethodPOST URLString:strUrl Param:dict CacheType:CNLiveNetworkCacheTypeNetworkOnly CompletionBlock:^(NSURLSessionTask *requestTask, id responseObject, NSError *error) {
        
        NSLog(@"家庭音箱详情数据 = %@",responseObject);
        
        NSString *resultCode = [NSString stringWithFormat:@"%@", responseObject[@"errorCode"]];
        NSError *err = nil;
        id data = nil;
        if([resultCode isEqualToString:@"0"]) {
            data = responseObject[@"data"];
        }else {
            @try {
                err = [[NSError alloc] initWithDomain:responseObject[@"errorMessage"] code:[resultCode integerValue] userInfo:nil];
            } @catch (NSException *exception) {
                err = [[NSError alloc] initWithDomain:@"接口异常" code:500 userInfo:nil];
            }
        }
        
        if (completerBlock) {
            if (error) {
                err = error;
            }
            completerBlock(data,err);
        }
        
    }];
}

/*** 获取设置角色列表 ***/
+ (void)getSetRoleListWithFamilyId:(NSString *)familyId completerBlick:(void (^)(id data, NSError *error))completerBlock {
    //http://apiwjjtest.cnlive.com/Daren/sound/getSetRoleList.action
    //@param sid sid
    //@param phone 手机号
    
    NSString *strUrl = CNBOXGetSetRoleListUrl;
    NSDictionary *dict = @{
        @"familyId": [NSString stringWithFormat:@"%@",familyId]
    };
    
    [CNLiveNetworking setAllowRequestDefaultArgument:YES];
    [CNLiveNetworking setupShowDataResult:NO];
    [CNLiveNetworking requestNetworkWithMethod:CNLiveRequestMethodPOST URLString:strUrl Param:dict CacheType:CNLiveNetworkCacheTypeNetworkOnly CompletionBlock:^(NSURLSessionTask *requestTask, id responseObject, NSError *error) {
        
        NSLog(@"家庭音箱详情数据 = %@",responseObject);
        
        NSString *resultCode = [NSString stringWithFormat:@"%@", responseObject[@"errorCode"]];
        NSError *err = nil;
        id data = nil;
        if([resultCode isEqualToString:@"0"]) {
            data = responseObject[@"data"];
        } else {
            @try {
                err = [[NSError alloc] initWithDomain:responseObject[@"errorMessage"] code:[resultCode integerValue] userInfo:nil];
            } @catch (NSException *exception) {
                err = [[NSError alloc] initWithDomain:@"接口异常" code:500 userInfo:nil];
            }
        }
        
        if (completerBlock) {
            if (error) {
                err = error;
            }
            completerBlock(data,err);
        }
        
    }];
}


/*** 音箱家庭邀请成员 ***/
+ (void)familyGroupInviteWithMembers:(NSMutableArray *)members completerBlick:(void (^)(id data, NSError *error))completerBlock {
    //http://apiwjjtest.cnlive.com/Daren/sound/familyGroupInviteYD.action
    //@param sid sid
    //@param phone 手机号
    
    NSString *jsonStr = [members mj_JSONString];
    NSString *strUrl = CNBOXFamilyGroupInviteYDUrl;
    NSDictionary *dict = @{
        @"type":@"2",
        @"contactsInvite": jsonStr
    };
    
    [CNLiveNetworking setAllowRequestDefaultArgument:YES];
    [CNLiveNetworking setupShowDataResult:NO];
    [CNLiveNetworking requestNetworkWithMethod:CNLiveRequestMethodPOST URLString:strUrl Param:dict CacheType:CNLiveNetworkCacheTypeNetworkOnly CompletionBlock:^(NSURLSessionTask *requestTask, id responseObject, NSError *error) {
        
        NSLog(@"家庭音箱详情数据 = %@",responseObject);
        
        NSString *resultCode = [NSString stringWithFormat:@"%@", responseObject[@"errorCode"]];
        NSError *err = nil;
        id data = nil;
        if([resultCode isEqualToString:@"0"]) {
            data = responseObject[@"data"];
        } else {
            @try {
                err = [[NSError alloc] initWithDomain:responseObject[@"errorMessage"] code:[resultCode integerValue] userInfo:nil];
            } @catch (NSException *exception) {
                err = [[NSError alloc] initWithDomain:@"接口异常" code:500 userInfo:nil];
            }
        }
        
        if (completerBlock) {
            if (error) {
                err = error;
            }
            completerBlock(data,err);
        }
        
    }];
}

/*** 二维码音箱家庭邀请成员 ***/
+ (void)QRCodeFamilyGroupInviteWithFamilyId:(NSString *)familyId roleId:(NSString *)roleId uuid:(NSString *)uuid completerBlick:(void (^)(id data, NSError *error))completerBlock {
    //http://apiwjjtest.cnlive.com/Daren/sound/familyGroupInviteYD.action
    //@param sid sid
    //@param phone 手机号
    
    NSString *familyIdStr = [NSString stringWithFormat:@"%@",familyId];
    NSString *roleIdStr = [NSString stringWithFormat:@"%@",roleId];
    NSString *uuidStr = [NSString stringWithFormat:@"%@",uuid];
    
    NSDictionary *dic =  @{
        
        @"familyId":familyIdStr,
        @"roleId":roleIdStr,
        @"uuid":uuidStr
    };
    
    NSString *jsonStr =  [EncryptAndDecrypt base64StringFromText:[dic mj_JSONString] encryptKey:@"homeAudio"];
    NSString *strUrl = CNBOXFamilyGroupInviteYDUrl;
    NSDictionary *dict = @{
        @"contactsInvite" : jsonStr,
        @"type" : @"1"
    };
    
    [CNLiveNetworking setAllowRequestDefaultArgument:YES];
    [CNLiveNetworking setupShowDataResult:NO];
    [CNLiveNetworking requestNetworkWithMethod:CNLiveRequestMethodPOST URLString:strUrl Param:dict CacheType:CNLiveNetworkCacheTypeNetworkOnly CompletionBlock:^(NSURLSessionTask *requestTask, id responseObject, NSError *error) {
        
        NSLog(@"家庭音箱详情数据 = %@",responseObject);
        
        NSString *resultCode = [NSString stringWithFormat:@"%@", responseObject[@"errorCode"]];
        NSError *err = nil;
        id data = nil;
        if([resultCode isEqualToString:@"0"]) {
            data = responseObject;
        } else {
            @try {
                err = [[NSError alloc] initWithDomain:responseObject[@"errorMessage"] code:[resultCode integerValue] userInfo:nil];
            } @catch (NSException *exception) {
                err = [[NSError alloc] initWithDomain:@"接口异常" code:500 userInfo:nil];
            }
        }
        
        if (completerBlock) {
            if (error) {
                err = error;
            }
            completerBlock(data,err);
        }
        
    }];
}


/*** 修改或移出家庭成员身份(删除) ***/
+ (void)updateFamilyMemberRoleWithFamilyId:(NSString *)familyId sid:(NSString *)sid  completerBlick:(void (^)(id data, NSError *error))completerBlock {
    //http://apiwjjtest.cnlive.com/Daren/sound/updateFamilyMemberRole.action
    //@param sid sid
    //@param phone 手机号
    
    NSString *strUrl = CNBOXUpdateFamilyMemberRoleUrl;
    NSDictionary *dict = @{
        @"sid": [NSString stringWithFormat:@"%@",sid],
        @"familyId": [NSString stringWithFormat:@"%@",familyId]
    };
    
    [CNLiveNetworking setAllowRequestDefaultArgument:YES];
    [CNLiveNetworking setupShowDataResult:NO];
    [CNLiveNetworking requestNetworkWithMethod:CNLiveRequestMethodPOST URLString:strUrl Param:dict CacheType:CNLiveNetworkCacheTypeNetworkOnly CompletionBlock:^(NSURLSessionTask *requestTask, id responseObject, NSError *error) {
        
        NSLog(@"家庭音箱详情数据 = %@",responseObject);
        
        NSString *resultCode = [NSString stringWithFormat:@"%@", responseObject[@"errorCode"]];
        NSError *err = nil;
        id data = nil;
        if([resultCode isEqualToString:@"0"]) {
            data = responseObject[@"data"];
        } else {
            @try {
                err = [[NSError alloc] initWithDomain:responseObject[@"errorMessage"] code:[resultCode integerValue] userInfo:nil];
            } @catch (NSException *exception) {
                err = [[NSError alloc] initWithDomain:@"接口异常" code:500 userInfo:nil];
            }
        }
        
        if (completerBlock) {
            if (error) {
                err = error;
            }
            completerBlock(data,err);
        }
        
    }];
}

/*** 修改或移出家庭成员身份(编辑) ***/
+ (void)editFamilyMemberRoleWithFamilyId:(NSString *)familyId sid:(NSString *)sid role:(NSString *)role  completerBlick:(void (^)(id data, NSError *error))completerBlock {
    //http://apiwjjtest.cnlive.com/Daren/sound/updateFamilyMemberRole.action
    //@param sid sid
    //@param phone 手机号
    
    NSString *strUrl = CNBOXUpdateFamilyMemberRoleUrl;
    NSDictionary *dict = @{
        @"sid": [NSString stringWithFormat:@"%@",sid],
        @"familyId": [NSString stringWithFormat:@"%@",familyId],
        @"role": [NSString stringWithFormat:@"%@",role]
    };
    
    [CNLiveNetworking setAllowRequestDefaultArgument:YES];
    [CNLiveNetworking setupShowDataResult:NO];
    [CNLiveNetworking requestNetworkWithMethod:CNLiveRequestMethodPOST URLString:strUrl Param:dict CacheType:CNLiveNetworkCacheTypeNetworkOnly CompletionBlock:^(NSURLSessionTask *requestTask, id responseObject, NSError *error) {
        
        NSLog(@"家庭音箱详情数据 = %@",responseObject);
        
        NSString *resultCode = [NSString stringWithFormat:@"%@", responseObject[@"errorCode"]];
        NSError *err = nil;
        id data = nil;
        if([resultCode isEqualToString:@"0"]) {
            data = responseObject[@"data"];
        } else {
            @try {
                err = [[NSError alloc] initWithDomain:responseObject[@"errorMessage"] code:[resultCode integerValue] userInfo:nil];
            } @catch (NSException *exception) {
                err = [[NSError alloc] initWithDomain:@"接口异常" code:500 userInfo:nil];
            }
        }
        
        if (completerBlock) {
            if (error) {
                err = error;
            }
            completerBlock(data,err);
        }
        
    }];
}




/*** 音箱设备暂停播放 ***/
+ (void)stopPlaybackDeviceWithSid:(NSString *)sid completerBlick:(void (^)(id data, NSError *error))completerBlock {
    
    NSString *strUrl = CNBOXStopPlaybackDeviceUrl;
    NSDictionary *dict = @{
        @"sid": [NSString stringWithFormat:@"%@",sid]
    };
    
    [CNLiveNetworking setAllowRequestDefaultArgument:YES];
    [CNLiveNetworking setupShowDataResult:NO];
    [CNLiveNetworking requestNetworkWithMethod:CNLiveRequestMethodPOST URLString:strUrl Param:dict CacheType:CNLiveNetworkCacheTypeNetworkOnly CompletionBlock:^(NSURLSessionTask *requestTask, id responseObject, NSError *error) {
        
        NSLog(@"家庭音箱详情数据 = %@",responseObject);
        
        NSString *resultCode = [NSString stringWithFormat:@"%@", responseObject[@"errorCode"]];
        NSError *err = nil;
        id data = nil;
        if([resultCode isEqualToString:@"0"]) {
            data = responseObject[@"data"];
        } else {
            @try {
                err = [[NSError alloc] initWithDomain:responseObject[@"errorMessage"] code:[resultCode integerValue] userInfo:nil];
            } @catch (NSException *exception) {
                err = [[NSError alloc] initWithDomain:@"接口异常" code:500 userInfo:nil];
            }
        }
        
        if (completerBlock) {
            if (error) {
                err = error;
            }
            completerBlock(data,err);
        }
        
    }];
    
}

/*** 移动播放接口 ***/
+ (void)playbackDeviceWithSid:(NSString *)sid resourceId:(NSString *)resourceId completerBlick:(void (^)(id data, NSError *error))completerBlock {
    
    [QMUITips showLoadingInView:AppKeyWindow];
    if (CNLiveStringIsEmpty(resourceId)) {
        [QMUITips hideAllTipsInView:AppKeyWindow];
        NSError *err = [[NSError alloc] initWithDomain:@"节目未同步至内容库" code:10086 userInfo:nil];
        if (completerBlock) {
            completerBlock(nil,err);
        }
        return;
    }
    
    //URL: http://apiwjjtest.cnlive.com/Daren/sound/playbackDevice.action
    NSString *strUrl = CNBOXPlaybackDeviceUrl;
    
    NSDictionary *dict = @{
        @"sid": [NSString stringWithFormat:@"%@",sid],
        @"resourceId": [NSString stringWithFormat:@"%@",resourceId]
    };
    
    [CNLiveNetworking setAllowRequestDefaultArgument:YES];
    [CNLiveNetworking setupShowDataResult:NO];
    [CNLiveNetworking requestNetworkWithMethod:CNLiveRequestMethodPOST URLString:strUrl Param:dict CacheType:CNLiveNetworkCacheTypeNetworkOnly CompletionBlock:^(NSURLSessionTask *requestTask, id responseObject, NSError *error) {
        
        NSLog(@"家庭音箱详情数据 = %@",responseObject);
        [QMUITips hideAllTipsInView:AppKeyWindow];
        NSString *resultCode = [NSString stringWithFormat:@"%@", responseObject[@"errorCode"]];
        NSError *err = nil;
        id data = nil;
        if([resultCode isEqualToString:@"0"]) {
            data = responseObject[@"data"];
        } else {
            @try {
                err = [[NSError alloc] initWithDomain:responseObject[@"errorMessage"] code:[resultCode integerValue] userInfo:nil];
            } @catch (NSException *exception) {
                err = [[NSError alloc] initWithDomain:@"接口异常" code:500 userInfo:nil];
            }
        }
        
        if (completerBlock) {
            if (error) {
                err = error;
            }
            completerBlock(data,err);
        }
        
        
    }];
    
}

/*** 删除设备(解绑) ***/
+ (void)deleteDeviceWithDevId:(NSString *)devid oldName:(NSString *)oldName completerBlick:(void (^)(id data, NSError *error))completerBlock {
    
    //URL: http://apiwjjtest.cnlive.com/Daren/sound/deleteDevice.action
    NSString *strUrl = CNBOXDeleteDeviceUrl;
    
       NSDictionary *dict = @{
           @"devId": [NSString stringWithFormat:@"%@",devid],
           @"oldName": [NSString stringWithFormat:@"%@",oldName]
          
       };
       
       [CNLiveNetworking setAllowRequestDefaultArgument:YES];
       [CNLiveNetworking setupShowDataResult:NO];
       [CNLiveNetworking requestNetworkWithMethod:CNLiveRequestMethodPOST URLString:strUrl Param:dict CacheType:CNLiveNetworkCacheTypeNetworkOnly CompletionBlock:^(NSURLSessionTask *requestTask, id responseObject, NSError *error) {
           
           NSLog(@"家庭音箱详情数据 = %@",responseObject);
           
           NSString *resultCode = [NSString stringWithFormat:@"%@", responseObject[@"errorCode"]];
           NSError *err = nil;
           id data = nil;
           if([resultCode isEqualToString:@"0"]) {
               data = responseObject[@"data"];
           } else {
               @try {
                   err = [[NSError alloc] initWithDomain:responseObject[@"errorMessage"] code:[resultCode integerValue] userInfo:nil];
               } @catch (NSException *exception) {
                   err = [[NSError alloc] initWithDomain:@"接口异常" code:500 userInfo:nil];
               }
           }
           
           if (completerBlock) {
               if (error) {
                   err = error;
               }
               completerBlock(data,err);
           }
           
       }];
    
}







@end
