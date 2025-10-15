//
//  CNBoxMasterManager.h
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/10/16.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CNBoxMasterManager : NSObject

+ (NSUserDefaults *)boxUserDefaultsWithDic:(NSDictionary *)dic;

+ (NSDictionary *)boxMasterMessage;

@end

NS_ASSUME_NONNULL_END
