//
//  RTBluetoothManager.h
//  StoryToy
//
//  Created by baxiang on 2017/10/31.
//  Copyright © 2017年 roobo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CNLiveBoxDevice.h"
#import "CNOpmodeObject.h"
typedef NS_ENUM(NSInteger,CNBleState) {
    CNBleStateUnknown = 0,
    CNBleStatePowerOn,
    CNBleStatePoweroff,
    CNBleStateUnauthorized,//为授权
    CNBleStateIdle,
    CNBleStateScan,
    CNBleStateCancelConnect,
    CNBleStateNoDevice,// 没有发现设备
    CNBleStateWaitToConnect,
    CNBleStateConnecting,
    CNBleStateConnected,
    CNBleStateWritable,
    CNBleStateDisconnect,
    CNBleStateReConnect,
    CNBleStateConnecttimeout,
    CNBleStateReconnecttimeout,
};

typedef NS_ENUM(NSInteger,CNBleNetResultState) {
    CNBleNetResultStateReceived = 0,
    CNBleNetResultStateLinking,
    CNBleNetResultStateLinkOK,
    CNBleNetResultStateLinkFail,
    CNBleNetResultStateBindSuccess,
    CNBleNetResultStateBindFail,
    
};


typedef void(^CNBLEStateChangeBlock)(CNBleState bleState);
typedef void(^CNBLEDidSearchBluetoothDeviceBlock) (NSMutableArray *deviceArray);
typedef void(^CNBLEConnectStatusBlock) (CBCentralManager *central, CBPeripheral *peripheral,NSError *error);
typedef void(^CNBLENetResultStatusBlock) (CNBleNetResultState resultState);


@interface CNBluetoothManager : NSObject
/*** 设备状态 ***/
@property(nonatomic,copy) CNBLEStateChangeBlock bleStateBlock;
/*** 搜索设备回调 ***/
@property(nonatomic,copy) CNBLEDidSearchBluetoothDeviceBlock searchResultBlock;
/*** 连接设备回调 ***/
@property(nonatomic,copy) CNBLEConnectStatusBlock connectResultBlock;
/*** 配网结果回调 ***/
@property(nonatomic,copy) CNBLENetResultStatusBlock netResultBlock;


@property(nonatomic,assign) CNBleState blestate;
@property(nonatomic,strong) CNLiveBoxDevice *currentdevice;
@property(nonatomic,strong) NSMutableArray *deviceArray;//扫描周围蓝牙设备集合
@property(nonatomic,assign) BOOL powerOn;

+ (CNBluetoothManager *)sharedInstance;
/// 释放
+ (void)attempDealloc;
/*** 扫描设备 ***/
-(void)scanPeripherals;
/*** 停止扫描设备 ***/
-(void)stopScanPeripherals;
/*** 取消所有连接 ***/
-(void)cancelAllConnect;
/*** 连接设备 ***/
-(void)connectDevice;
/*** 配网命令 ***/
-(void)setOpmodeObject:(CNOpmodeObject *)object devicceID:(NSString *)deviceID;
/*** 删除自动重连 ***/
-(void)AutoReconnectCancel:(CBPeripheral *)peripheral;

@end
