//
//  CNBoxMasterManager.m
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/10/16.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import "CNBoxMasterManager.h"

@implementation CNBoxMasterManager

+ (NSUserDefaults *)boxUserDefaultsWithDic:(NSDictionary *)dic {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dic forKey:wjjPersonIsEnterRoomKey];
    [userDefaults synchronize];
    return userDefaults;
}

+ (NSDictionary *)boxMasterMessage{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [userDefaults objectForKey:wjjPersonIsEnterRoomKey];
    return dic;
}



@end
