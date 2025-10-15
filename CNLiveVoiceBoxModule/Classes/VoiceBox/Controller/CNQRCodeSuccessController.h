//
//  CNQRCodeSuccessController.h
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/10/16.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CNQRCodeStatus) {
    CNQRCodeStatusSuccess,
    CNQRCodeStatusFail
    
};

NS_ASSUME_NONNULL_BEGIN

@interface CNQRCodeSuccessController : CNCommonViewController

@property (strong, nonatomic) NSString * familyId;

@property (strong, nonatomic) NSString * roleId;

@property (copy, nonatomic) NSString *uuId;

@end

NS_ASSUME_NONNULL_END
