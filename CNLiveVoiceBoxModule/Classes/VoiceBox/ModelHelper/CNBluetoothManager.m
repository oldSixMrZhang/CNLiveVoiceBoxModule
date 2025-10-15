//
//  RTBluetoothManager.m
//  StoryToy
//
//  Created by baxiang on 2017/10/31.
//  Copyright © 2017年 roobo. All rights reserved.
//

#import "CNBluetoothManager.h"
#import "CNLiveBoxDevice.h"
//#import "RTBLEdataFunc.h"
//#import "RTOpmodeObject.h"
#import "BabyBluetooth.h"
//#import "PacketCommand.h"
//#import "DH_AES.h"
#import "CNBoxMasterManager.h"



#define filterBLEname @"XIAOJIA-"

#define UUIDSTR_ESPRESSIF_SERVICE @"FFFF"
#define UUIDSTR_ESPRESSIF_Write @"2222"
#define UUIDSTR_ESPRESSIF_Notify @"A007"
#define UUIDSTR_ESPRESSIF_Command @"CDD2"

//#define UUIDSTR_ESPRESSIF_Write                @"FF01"
//#define UUIDSTR_ESPRESSIF_Notify               @"FF02"
//#define UUIDSTR_ESPRESSIF_Command              @"CDD2"

@interface CNBluetoothManager ()
@property (nonatomic, strong) BabyBluetooth *bluetooth;
@property (nonatomic, assign) uint8_t sequence;
@property (nonatomic, strong) CBCharacteristic *WriteCharacteristic;
//断开连接标志,判断是自动断开还是意外断开
@property (nonatomic, assign) BOOL APPCancelConnect;

////当前连接设备信息
//@property (nonatomic, strong) RSAObject *rsaobject;

@property (nonatomic, strong) NSData *senddata;

@property (nonatomic, copy) NSString *wifiInfoStr;

@property (nonatomic, copy) NSData *Securtkey;

@end
@implementation CNBluetoothManager

+ (CNBluetoothManager *)sharedInstance {
    static CNBluetoothManager *bluetoothManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^() {
        bluetoothManager = [[CNBluetoothManager alloc] init];
    });
    return bluetoothManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _bluetooth = [BabyBluetooth shareBabyBluetooth];
        self.blestate = CNBleStateIdle;
        [self setupBluetoothDelegate];
        _deviceArray = [NSMutableArray new];
        self.sequence = 0;
//        self.rsaobject = [DH_AES DHGenerateKey];
    }
    return self;
}


- (BOOL)powerOn {
    if (_bluetooth.centralManager.state == CBCentralManagerStatePoweredOn) {
        return YES;
    }
    return NO;
}

- (void)judgeBluetoothState:(void (^)(CNBleState))stateBlock {
    @weakify(self);
    //判断手机蓝牙状态
    [_bluetooth setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        //检测蓝牙状态
        @strongify(self);
        if (central.state == CBCentralManagerStatePoweredOn) {
            NSLog(@"蓝牙已打开");
            stateBlock(CNBleStatePowerOn);
        }
        if (central.state == CBCentralManagerStateUnsupported) {
            NSLog(@"该设备不支持蓝牙BLE");
            stateBlock(CNBleStateUnknown);
        }
        if (central.state == CBCentralManagerStatePoweredOff) {
            NSLog(@"蓝牙已关闭");
            stateBlock(CNBleStatePoweroff);
        }
        
        if (@available(iOS 10.0, *)) {
            if (central.state == CBManagerStateUnauthorized) {
                stateBlock(CNBleStatePoweroff);
            }
        } else {
           
        }
        
    }];
}

- (void)setupBluetoothDelegate {
    @weakify(self);
    //判断手机蓝牙状态
    [self judgeBluetoothState:^(CNBleState state) {
        self.blestate = state;
    }];

    //搜索蓝牙设备
    [_bluetooth setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        @strongify(self);
        
        NSLog(@"搜索到了设备:%@,%@", peripheral.name, advertisementData);
        NSString *blueName = nil;
        if ([advertisementData.allKeys containsObject:@"kCBAdvDataLocalName"]) {
            blueName = [advertisementData objectForKey:@"kCBAdvDataLocalName"];
        }
        if (![blueName isNotBlank]) {
            blueName = [NSString stringWithFormat:@"%@", peripheral.name];
        }
        
        if (self.deviceArray.count == 0) {
            CNLiveBoxDevice *device = [[CNLiveBoxDevice alloc] init];
            device.name = blueName;
            device.Peripheral = peripheral;
            [self.deviceArray addObject:device];
            if (self.searchResultBlock) {
                self.searchResultBlock(self.deviceArray);
            }
            
        }else {
            __block BOOL isHave = NO;
            [self.deviceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj) {
                    CNLiveBoxDevice *device = obj;
                    if (device && peripheral) {
                        
                        if ([device.Peripheral.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
                            isHave = YES;
                            
                        }
                        
                    }
                    
                }
                
            }];
            
            if (!isHave) {
                CNLiveBoxDevice *device = [[CNLiveBoxDevice alloc] init];
                device.name = blueName;
                device.Peripheral = peripheral;
                [self.deviceArray addObject:device];
                if (self.searchResultBlock) {
                    self.searchResultBlock(self.deviceArray);
                }
            }
            
        }
        
        
    }];

    //设置扫描过滤器
    [_bluetooth setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {

        if ([peripheralName hasPrefix:filterBLEname] && [peripheralName isNotBlank]) {
            return YES;
        }
        return NO;
    }];

    //设置连接过滤器
    [_bluetooth setFilterOnConnectToPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        @strongify(self);
        if ([peripheralName hasPrefix:filterBLEname]) {
            NSLog(@"准备连接");
            self.blestate = CNBleStateConnecting;
            return YES;
        }
        return NO;
    }];

    //连接成功
    [_bluetooth setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        @strongify(self);
        NSLog(@"设备：%@--连接成功", peripheral.name);
        if (self.connectResultBlock) {
            self.connectResultBlock(central,peripheral,nil);
        }
    }];

    //设备连接失败
    [_bluetooth setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        @strongify(self);
        NSLog(@"设备：%@--连接失败", peripheral.name);
        //清除主动断开标志
        self.APPCancelConnect = NO;
        if (self.connectResultBlock) {
            self.connectResultBlock(central,peripheral,error);
        }
    }];

    //发现设备的services委托
    [_bluetooth setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        @strongify(self);
        NSLog(@"发现服务");
        //更新蓝牙状态,进入已连接状态
        self.blestate = CNBleStateConnected;
    }];
    [_bluetooth setBlockOnDidReadRSSI:^(NSNumber *RSSI, NSError *error) {
        NSLog(@"当前连接设备的RSSI值为:%@", RSSI);
    }];
    //设置发现services的characteristics
    [_bluetooth setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        @strongify(self);
        NSLog(@"===service name:%@", service.UUID);
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID.UUIDString isEqualToString:UUIDSTR_ESPRESSIF_Notify]) {
                //订阅通知
                [self.bluetooth notify:peripheral
                        characteristic:characteristic
                                 block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                    NSData *data = characteristic.value;
                    if (data.length < 3) {
                        return;
                    }
                    NSLog(@"接收到数据为%@>>>>>>>>>>>>", data);
                    NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"接收到数据转码%@>>>>>>>>>>",dataStr);
                    
                    [self returnNetResultWithDataStr:dataStr];
                    
                    
//                    [self analyseData:Mutabledata];
                    
                }];
            }
            if ([characteristic.UUID.UUIDString isEqualToString:UUIDSTR_ESPRESSIF_Write]) {
                NSLog(@"UUIDSTR_ESPRESSIF_RX");
                _WriteCharacteristic = characteristic;
            }
        }
    }];

    //读取characteristic
    [_bluetooth setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error){

    }];

    //设置发现characteristics的descriptors的委托
    [_bluetooth setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error){
    }];

    //设置读取Descriptor的委托
    [_bluetooth setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@", descriptor.characteristic.UUID, descriptor.value);
    }];

    //断开连接回调
    [_bluetooth setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        @strongify(self);
        if (error) {
            NSLog(@"断开连接Error %@", error);
        }
        if (self.APPCancelConnect) {
            //清标志位
            self.APPCancelConnect = NO;
            self.blestate = CNBleStateDisconnect;
            NSLog(@"设备：%@--断开连接", peripheral.name);
        } else {
            //更新蓝牙状态,已连接状态
            self.blestate = CNBleStateReConnect;
            //添加自动回连
            [self AutoReconnect:self.currentdevice.Peripheral];
            NSLog(@"设备：%@--重新连接", peripheral.name);
        }
        //断开连接时,如果有数据就保存到数据库
    }];
    //取消所有连接回调
    [_bluetooth setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
    }];
    //********取消扫描回调***********//
    [_bluetooth setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        @strongify(self);
        NSLog(@"通知扫描");
        NSInteger count = self.deviceArray.count;
        if (count <= 0) {
            //更新蓝牙状态,进入无设备状态
            if (self.blestate == CNBleStateUnknown || self.blestate == CNBleStatePoweroff) {
                return ;
            }
            self.blestate = CNBleStateNoDevice;
        }
/*        else if (count >= 1) {
            _currentdevice = [self.BLEDeviceArray firstObject];
            self.blestate = RTBleStateWaitToConnect;
        }*/
    }];
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES };

    NSDictionary *connectOptions = @{ CBConnectPeripheralOptionNotifyOnConnectionKey : @YES,
                                      CBConnectPeripheralOptionNotifyOnDisconnectionKey : @YES,
                                      CBConnectPeripheralOptionNotifyOnNotificationKey : @YES };
    //连接设备->
    [_bluetooth setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectOptions scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    //订阅状态改变
    [_bluetooth setBlockOnDidUpdateNotificationStateForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
        @strongify(self);
        if (error) {
            NSLog(@"订阅 Error");
        }
        if (characteristic.isNotifying) {
            NSLog(@"订阅成功");
            self.blestate = CNBleStateWritable;
            [self SendNegotiateData:YES];
        } else {
            NSLog(@"已经取消订阅");
        }

    }];
    //发送数据完成回调
    [_bluetooth setBlockOnDidWriteValueForCharacteristic:^(CBCharacteristic *characteristic, NSError *error) {
        if (error) {
            NSLog(@"发送数据完成回调%@", error);
            return;
        }
        NSLog(@"----------%@", characteristic.UUID);
        NSLog(@"发送数据完成");

    }];
}

- (void)setCurrentdevice:(CNLiveBoxDevice *)currentdevice {
    _currentdevice = currentdevice;
    self.blestate = CNBleStateWaitToConnect;
}

//蓝牙状态更新调用
- (void)setBlestate:(CNBleState)blestate {
    _blestate = blestate;
    if (_bleStateBlock) {
        _bleStateBlock(blestate);
    }
    switch (blestate) {
        case CNBleStatePowerOn: {
            NSLog(@"蓝牙已打开");
            self.blestate = CNBleStateIdle;
        } break;
        case CNBleStatePoweroff: {
            NSLog(@"蓝牙已关闭");
        } break;
        case CNBleStateIdle: {
            NSLog(@"点击搜索");
        } break;
        case CNBleStateScan: {
            NSLog(@"正在扫描设备");
        } break;
        case CNBleStateCancelConnect: {
            NSLog(@"重新扫描");
        } break;
        case CNBleStateNoDevice: {
            NSLog(@"无设备,点击重新开始");

        } break;
        case CNBleStateWaitToConnect: {
            NSLog(@"等待连接");
        } break;
        case CNBleStateConnecting: {
            NSLog(@"正在连接");
        } break;
        case CNBleStateConnected:
            NSLog(@"蓝牙已连接");
            break;
        case CNBleStateDisconnect:
            NSLog(@"蓝牙已断开,点击重新搜索");
            self.sequence = 0;
//            self.rsaobject = nil;
            self.senddata = nil;
            self.Securtkey = nil;
            break;
        case CNBleStateReConnect: {
            self.sequence = 0;
//            self.rsaobject = nil;
            self.senddata = nil;
            self.Securtkey = nil;
        } break;
        case CNBleStateUnknown:
            NSLog(@"手机不支持蓝牙4.0");
            break;
        case CNBleStateConnecttimeout:
            NSLog(@"重连超时");

            break;
        case CNBleStateReconnecttimeout:
            NSLog(@"重连超时,点击重新开始");
            break;

        default:
            break;
    }
}

#pragma mark - 配网结果回调
- (void)returnNetResultWithDataStr:(NSString *)dataStr {
    
    
    if ([dataStr containsString:@"ssid received"]) {//开始
        NSLog(@"盒子输出 = %@",@"ssid received");
        if (self.netResultBlock) {
            self.netResultBlock(CNBleNetResultStateReceived);
        }
        return;
    }else if ([dataStr containsString:@"WiFi Linking"]) {//连接中
        NSLog(@"盒子输出 = %@",@"WiFi Linking");
        if (self.netResultBlock) {
            self.netResultBlock(CNBleNetResultStateLinking);
        }
        return;
    }else if ([dataStr containsString:@"WiFi Link OK"]) {//连接成功
        NSLog(@"盒子输出 = %@",@"WiFi Link OK");
        if (self.netResultBlock) {
            self.netResultBlock(CNBleNetResultStateLinkOK);
        }
        return;
    }else if ([dataStr containsString:@"bind success"]) {//绑定成功
        NSLog(@"盒子输出 = %@",@"bind success");
        if (self.netResultBlock) {
            self.netResultBlock(CNBleNetResultStateBindSuccess);
        }
        return;
    }else if ([dataStr containsString:@"bind faild"]) {//绑定失败
        NSLog(@"盒子输出 = %@",@"bind faild");
        if (self.netResultBlock) {
            self.netResultBlock(CNBleNetResultStateBindFail);
        }
        return;
    }else {//失败
        if (self.netResultBlock) {
            self.netResultBlock(CNBleNetResultStateLinkFail);
        }
        NSLog(@"盒子输出 = %@",@"WiFi Link Fail");
    }
                       
//    if ([dataStr containsString:@"WiFi Link Fail"]) {
//        NSLog(@"盒子输出 = %@",@"失败");
//        return;
//    }

}

- (void)analyseData:(NSMutableData *)data {
    Byte *dataByte = (Byte *) [data bytes];

    Byte Type = dataByte[0] & 0x03;
    Byte sequence = dataByte[2];
    Byte frameControl = dataByte[1];
    Byte length = dataByte[3];

//    BOOL hash = frameControl & Packet_Hash_FrameCtrlType;
//    BOOL checksum = frameControl & Data_End_Checksum_FrameCtrlType;
//    BOOL Ack = frameControl & ACK_FrameCtrlType;
//    BOOL AppendPacket = frameControl & Append_Data_FrameCtrlType;
//
//    if (hash) {
//        NSLog(@"加密");
//        //解密
//        NSRange range = NSMakeRange(4, length);
//        NSData *Decryptdata = [data subdataWithRange:range];
//        Byte *byte = (Byte *) [Decryptdata bytes];
//        Decryptdata = [DH_AES blufi_aes_DecryptWithSequence:sequence data:byte len:length KeyData:self.Securtkey];
//        [data replaceBytesInRange:range withBytes:[Decryptdata bytes]];
//
//    } else {
//        NSLog(@"无加密");
//    }
//    if (checksum) {
//        NSLog(@"有校验");
//        //计算校验
//        if ([PacketCommand VerifyCRCWithData:data]) {
//            NSLog(@"校验成功");
//        } else {
//            NSLog(@"校验失败,返回");
//            //[HUDTips ShowLabelTipsToView:self.view WithText:@"校验失败"];
//            return;
//        }
//
//    } else {
//        NSLog(@"无校验");
//    }
//    if (Ack) {
//        NSLog(@"回复ACK");
//        [self writeStructDataWithCharacteristic:self.WriteCharacteristic WithData:[PacketCommand ReturnAckWithSequence:self.sequence BackSequence:sequence]];
//    } else {
//        NSLog(@"不回复ACK");
//    }
//    if (AppendPacket) {
//        NSLog(@"有后续包");
//    } else {
//        NSLog(@"没有后续包");
//    }
//
//    if (Type == ContolType) {
//        NSLog(@"接收到控制包===========");
//        [self GetControlPacketWithData:data];
//    } else if (Type == DataType) {
//        NSLog(@"接收到数据包===========");
//        [self GetDataPackectWithData:data];
//    } else {
//        NSLog(@"异常数据包");
//    }
}

- (void)scanPeripherals {
    [_deviceArray removeAllObjects];
    _bluetooth.scanForPeripherals().begin();
}

- (void)stopScanPeripherals {
    [_bluetooth cancelScan];
}

/**
 *  直连
 *
 *
 */
- (void)connectDevice {
    _bluetooth.having(_currentdevice.Peripheral).connectToPeripherals().discoverServices().discoverCharacteristics().begin();
}
//断开自动重连
- (void)AutoReconnect:(CBPeripheral *)peripheral {
    [_bluetooth AutoReconnect:peripheral];
}
//删除自动重连
- (void)AutoReconnectCancel:(CBPeripheral *)peripheral;
{
    [_bluetooth AutoReconnectCancel:peripheral];
}

/**
 *  断开连接
 */
- (void)Disconnect:(CBPeripheral *)Peripheral {
    self.APPCancelConnect = YES;
    //取消某个连接
    [_bluetooth cancelPeripheralConnection:Peripheral];
    self.blestate = CNBleStateDisconnect;
}
//取消所有连接
- (void)cancelAllConnect {
    self.APPCancelConnect = YES;
    //断开所有蓝牙连接
    [_bluetooth cancelAllPeripheralsConnection];
}

//发送协商数据包
- (void)SendNegotiateData:(BOOL)isneedSendSubData {
//    if (!self.rsaobject) {
//        self.rsaobject = [DH_AES DHGenerateKey];
//    }
    NSInteger datacount = 20;
    //发送数据长度
    //    NSData *dataLength= [self.wifiInfoStr dataUsingEncoding:NSUTF8StringEncoding];
    //    uint16_t length = dataLength.length;
    //    NSData *lengthD = [PacketCommand SetNegotiatelength:length Sequence:self.sequence];
    //    [self writeStructDataWithCharacteristic:self.WriteCharacteristic WithData:lengthD];

    //发送数据,需要分包

    if (self.senddata) {
        NSString *wifiInfoStr = [[NSString alloc] initWithData:self.senddata encoding:NSUTF8StringEncoding];
        NSLog(@"+++++++ sendStr %@", wifiInfoStr);
    }

    if (isneedSendSubData) {
        NSInteger number = self.senddata.length / datacount;
        if (number > 0) {
            for (NSInteger i = 0; i < number + 1; i++) {
                if (i == number) {
//                    [[RACScheduler mainThreadScheduler] afterDelay:0.1
//                                                          schedule:^{
//                                                              NSData *data = [NSData dataWithData:self.senddata];
//                                                              NSString *wifiInfoStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                                              NSLog(@"+++++++ last sub  sendStr %@", wifiInfoStr);
//                                                              [self writeStructDataWithCharacteristic:_WriteCharacteristic WithData:data];
//                                                          }];
                } else {
//                    [[RACScheduler mainThreadScheduler] afterDelay:0.1
//                                                          schedule:^{
//                                                              NSData *data = [self.senddata subdataWithRange:NSMakeRange(0, datacount)];
//                                                              NSString *wifiInfoStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                                              NSLog(@"+++++++ sub  sendStr %@", wifiInfoStr);
//                                                              [self writeStructDataWithCharacteristic:_WriteCharacteristic WithData:data];
//                                                              self.senddata = [self.senddata subdataWithRange:NSMakeRange(datacount, self.senddata.length - datacount)];
//                                                          }];
                }
            }
        } else {
            NSData *data = [self.wifiInfoStr dataUsingEncoding:NSUTF8StringEncoding];
            
//            [self writeStructDataWithCharacteristic:_WriteCharacteristic WithData:data];
        }
    } else {
//        [[RACScheduler mainThreadScheduler] afterDelay:0.1
//                                              schedule:^{
//                                                  NSData *data = [self.wifiInfoStr dataUsingEncoding:NSUTF8StringEncoding];
//                                                  [self writeStructDataWithCharacteristic:_WriteCharacteristic WithData:data];
//                                              }];
    }
}

-(void)setOpmodeObject:(CNOpmodeObject *)object devicceID:(NSString *)deviceID {
    

    NSString *userIDStr = [NSString stringWithFormat:@"%@",deviceID];
    NSString *WifiStr = [NSString stringWithFormat:@"v1#%@#%@#%@##", [self convertString:object.wifiSSid], [self convertString:object.wifiPassword], [self convertString:userIDStr]];
    NSString *BluWifiStr = [NSString stringWithFormat:@"1111(%@)2222", WifiStr];
    NSInteger count = BluWifiStr.length / 16;
    NSInteger lastCount = BluWifiStr.length % 16; // 余数
    NSString *lastStr;
    if (lastCount > 0) {
        lastStr = [BluWifiStr substringWithRange:NSMakeRange(BluWifiStr.length - lastCount, lastCount)];
    }
    NSMutableString *fullWifiStr = [NSMutableString string];
    for (int i = 0; i < count; i++) {
        NSString *subStr = [BluWifiStr substringWithRange:NSMakeRange(i * 16, 16)];
        [fullWifiStr appendString:[NSString stringWithFormat:@"DATA%@", subStr]];
    }
    if (lastStr.length > 0) {
        [fullWifiStr appendString:[NSString stringWithFormat:@"DATA%@", lastStr]];
    }
    NSLog(@"========fullwifistr %@", fullWifiStr);
    self.wifiInfoStr = fullWifiStr;
    NSData *data = [fullWifiStr dataUsingEncoding:NSUTF8StringEncoding];
    self.senddata = data;
    [self writeStructDataWithCharacteristic:_WriteCharacteristic WithData:data];
}

- (NSString *)convertString:(NSString *)string {
    NSString *result = string;
    if ([string containsString:@"\\"]) {
        result = [string stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    }

    if ([string containsString:@"#"]) {
        result = [string stringByReplacingOccurrencesOfString:@"#" withString:@"\\#"];
    }
    return result;
}

/**
 *  蓝牙发送数据
 *
 *  @param Characteristic 特征值
 */
- (void)writeStructDataWithCharacteristic:(CBCharacteristic *)Characteristic WithData:(NSData *)data {

    if (self.currentdevice.Peripheral && Characteristic && data) {
        [self.currentdevice.Peripheral writeValue:data forCharacteristic:Characteristic type:CBCharacteristicWriteWithResponse];
        self.sequence = self.sequence + 1;
    }
}

//- (void)GetControlPacketWithData:(NSData *)data {
//
//    Byte *dataByte = (Byte *) [data bytes];
//    Byte SubType = dataByte[0] >> 2;
//    switch (SubType) {
//        case ACK_Esp32_Phone_ControlSubType: {
//            NSLog(@"接收到ACK<<<<<<<<<<<<<<<");
//        } break;
//        case ESP32_Phone_Security_ControlSubType:
//            break;
//
//        case Wifi_Op_ControlSubType:
//            break;
//
//        case Connect_AP_ControlSubType:
//            break;
//        case Disconnect_AP_ControlSubType:
//            break;
//        case Get_Wifi_Status_ControlSubType:
//            break;
//        case Deauthenticate_STA_Device_SoftAP_ControlSubType:
//            break;
//        case Get_Version_ControlSubType:
//            break;
//        case Negotiate_Data_ControlSubType:
//            break;
//
//        default:
//            break;
//    }
//}

//- (void)GetDataPackectWithData:(NSData *)data {
//
//    Byte *dataByte = (Byte *) [data bytes];
//    Byte SubType = dataByte[0] >> 2;
//    Byte length = dataByte[3];

//    switch (SubType) {
//        case Negotiate_Data_DataSubType: //
//        {
//            if (data.length < length + 4) {
//                NSLog(@"数据异常");
//                return;
//            }
//            NSData *NegotiateData = [data subdataWithRange:NSMakeRange(4, length)];
//            self.Securtkey = [DH_AES GetSecurtKey:NegotiateData RsaObject:self.rsaobject];
//            //设置加密模式
//            //            NSData *SetSecuritydata=[PacketCommand SetESP32ToPhoneSecurityWithSecurity:NO CheckSum:YES Sequence:self.sequence];
//            //            [self writeStructDataWithCharacteristic:_WriteCharacteristic WithData:SetSecuritydata];
//
//            //获取状态报告
//            //            [self writeStructDataWithCharacteristic:_WriteCharacteristic WithData:[PacketCommand GetDeviceInforWithSequence:self.sequence]];
//        } break;
//
//        case BSSID_STA_DataSubType:
//
//            break;
//        case SSID_STA_DataSubType:
//
//            break;
//        case Password_STA_DataSubType:
//
//            break;
//        case SSID_SoftaAP_DataSubType:
//
//            break;
//        case Password_SoftAP_DataSubType:
//
//            break;
//        case Max_Connect_Number_SoftAP_DataSubType:
//
//            break;
//        case Authentication_SoftAP_DataSubType:
//
//            break;
//        case Channel_SoftAP_DataSubType:
//
//            break;
//
//        case Username_DataSubType:
//
//            break;
//        case CA_Certification_DataSubType:
//
//            break;
//        case Client_Certification_DataSubType:
//
//            break;
//        case Server_Certification_DataSubType:
//
//            break;
//        case Client_PrivateKey_DataSubType:
//
//            break;
//
//        case Server_PrivateKey_DataSubType:
//
//            break;
//        case Wifi_Connection_state_Report_DataSubType: //连接状态报告
//        {
//            if (length < 3) {
//                return;
//            }
//            NSLog(@"接收到连接状态包<<<<<<<<<<<<<<<<");
//            NSString *OpmodeTitle;
//            switch (dataByte[4]) {
//                case NullOpmode: {
//                    OpmodeTitle = @"Null Mode";
//
//                }
//                    break;
//                case STAOpmode:
//                    OpmodeTitle=@"STA mode";
//
//                    break;
//                case SoftAPOpmode:
//                    OpmodeTitle=@"SoftAP mode";
//
//                    break;
//                case SoftAP_STAOpmode:
//                    OpmodeTitle=@"SoftAP/STA mode";
//
//                    break;
//
//                default:
//                    OpmodeTitle=@"Unknown mode";
//
//                    break;
//            }
//            NSLog(@"%@",OpmodeTitle);
//
//
//            NSString *StateTitle;
//            if (dataByte[5]==0x0) {
//                StateTitle=@"STA连接状态";
//            }else
//            {
//                StateTitle=@"STA非连接状态";
//            }
//            NSLog(@"%@",StateTitle);
//
//
//            NSLog(@"SoftAP连接状态,%d 个STA",dataByte[6]);
//            self.blestate = RTBleStateWritable;
//        }
//            break;
//        case Version_DataSubType:
//
//            break;
//
//        default:
//            break;
//    }
//}


@end
