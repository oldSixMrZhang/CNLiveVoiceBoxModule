//
//  CNVoiceBoxSearchWifiController.m
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/9/17.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import "CNVoiceBoxSearchWifiController.h"
#import "CNConnectWIFISuccessController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "CNBluetoothManager.h"
#import "CNLiveVoiceBoxModelHelper.h"
#import "CNBoxNetResultModel.h"
#import "CNConnectWifiFailController.h"
#import "CNLiveBOXWiFiCell.h"
#import "CNBoxMasterManager.h"

@interface CNVoiceBoxSearchWifiController ()<UITableViewDelegate,UITableViewDataSource>
/*** 返回 ***/
@property (strong, nonatomic) UIButton *backBtn;
/*** 下一页 ***/
@property (strong, nonatomic) UIButton *nextBtn;

/*** 列表 ***/
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *wifiArray;

@property (copy, nonatomic) NSString *wifiSSid;
@property (copy, nonatomic) NSString *wifiBSSid;
@property (copy, nonatomic) NSString *wifiPassword;

@end

@implementation CNVoiceBoxSearchWifiController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"选择WIFI网络";
    [self.view setBackgroundColor:RGBCOLOR(242, 242, 242)];
    self.wifiArray = [NSMutableArray array];
    [self setupUI];
    [self layoutUI];
    
    __weak typeof(self) weakSelf = self;
    [CNVoiceBoxSearchWifiController  networkStatusWithBlock:^(CNLiveNetworkStatusType status) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.wifiArray removeAllObjects];
            weakSelf.wifiBSSid = @"";
            NSString *wifiName = [self currentWifiBSSID];
            if (wifiName) {
                weakSelf.wifiBSSid = [self getWifiBSSidWithCallback];
                [weakSelf.wifiArray addObject:wifiName];
            }
            [weakSelf.tableView reloadData];
        });
        
       
    }];
    
    if (self.wifiStatus == VoiceBoxSearchWifiStatusChange) {
        [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    }else {
        [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    }
    
    [self addNotificationCenter];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.wifiArray removeAllObjects];
    self.wifiBSSid = @"";
    NSString *wifiName = [self currentWifiBSSID];
    if (wifiName) {
        self.wifiBSSid = [self getWifiBSSidWithCallback];
        [self.wifiArray addObject:wifiName];
    }
    [self.tableView reloadData];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addNotificationCenter {
    /*** 程序进入后台时调用.(释放资源) ***/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidEnterBackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    /*** 从活动状态进入非活动状态.(这个阶段应该保存UI状态) ***/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    /*** 程序进入前台并处于活动状态时调用.(这个阶段应该恢复UI状态) ***/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    /*** 程序进入前台，但是还没有处于活动状态时调用.(这个阶段应该恢复用户数据) ***/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
}
#pragma mark - ***************** 通知实现 ******************
/*** 从活动状态进入非活动状态.(这个阶段应该保存UI状态) ***/
- (void)onAppWillResignActive:(NSNotification *)notification {
    
    
}
/*** 程序进入前台并处于活动状态时调用.(这个阶段应该恢复UI状态) ***/
- (void)onAppDidBecomeActive:(NSNotification *)notification {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.wifiArray removeAllObjects];
        self.wifiBSSid = @"";
        NSString *wifiName = [self currentWifiBSSID];
        if (wifiName) {
            self.wifiBSSid = [self getWifiSsidWithCallback];
            [self.wifiArray addObject:wifiName];
        }
        [self.tableView reloadData];
    });
}

/*** 程序进入后台时调用.(释放资源) ***/
- (void)onAppDidEnterBackGround:(NSNotification *)notification {
    
    
}

/*** 程序进入前台，但是还没有处于活动状态时调用.(这个阶段应该恢复用户数据) ***/
- (void)onAppWillEnterForeground:(NSNotification *)notification {
   
    
}



- (void)setupUI {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.nextBtn];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 150);
    }else {
        self.tableView.frame = CGRectMake(0, kNavigationBarHeight, KScreenWidth, KScreenHeight - 150);
    }
    
}

- (void)layoutUI {
    
    __weak typeof(self) weakSelf = self;
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-100);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-49);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.width.mas_equalTo(275);
        make.height.mas_equalTo(50);
    }];
    
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.wifiArray.count == 0) {
        return 1;
    }else {
        return self.wifiArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CNLiveBOXWiFiCell *cell = [tableView dequeueReusableCellWithIdentifier:kCNLiveBOXWiFiCell forIndexPath:indexPath];
    if (self.wifiArray.count == 0) {
        cell.wifiName.text = @"点击选择WIFI";
    }else {
        NSString *wifiStr = [NSString stringWithFormat:@"%@",self.wifiArray[indexPath.row] ? self.wifiArray[indexPath.row]:@""];
        cell.wifiName.text = wifiStr;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 51;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    
}



#pragma mark - 事件实现

- (void)alertViewTextFieldDidChange:(NSNotification *)notification {
    
    UITextField *textField = notification.object;
    
    NSLog(@"输出textField变化%@",notification.object);
    
    self.wifiPassword = [NSString stringWithFormat:@"%@",textField.text];
    
    
}

- (void)backBtnAction:(UIButton *)backBtn {
    [[AppDelegate sharedAppDelegate] popViewController];
    
}

- (void)nextBtnAction:(UIButton *)nextBtn {
    
    if (self.wifiArray.count <= 0 ) {
        [QMUITips showWithText:@"手机当前没有连接WIFI" inView:self.view hideAfterDelay:0.5];
        return;
    }
    
    if (self.wifiStatus == VoiceBoxSearchWifiStatusChange) {
        
        [self changeWIFI];
        
    }else {
        [self setWIFI];
    }
    
    
}

#pragma mark - 私有方法

- (void)changeWIFI {
    if (!self.detailModel || !self.deviceModel) {
        [QMUITips showWithText:@"设备信息为空" inView:self.view hideAfterDelay:0.5];
    }
    
    
    NSString *deviceID = [NSString stringWithFormat:@"%@",self.deviceModel.mcid];
    NSString *wifiStr = @"";
    if (self.wifiArray.count > 0) {
        wifiStr = [NSString stringWithFormat:@"%@",self.wifiArray[0]];
    }else {
        [QMUITips showWithText:@"手机未连接WIFI" inView:self.view hideAfterDelay:0.5];
        return;
    }
    NSString *macStr = [NSString stringWithFormat:@"%@",self.wifiBSSid];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入WIFI密码" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"密码";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertViewTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    }];;
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *wifiPassword = [NSString stringWithFormat:@"%@",self.wifiPassword];
        
        __weak typeof(self) weakSelf = self;
        [QMUITips showLoadingInView:self.view];
        [CNLiveVoiceBoxModelHelper changeWiFiWithDeviceId:deviceID name:wifiStr passwd:wifiPassword mac:macStr completerBlick:^(id  _Nonnull data, NSError * _Nonnull error) {
            [QMUITips hideAllTipsInView:weakSelf.view];
            
            if (error) {
                [QMUITips showWithText:@"切换WiFi失败" inView:weakSelf.view hideAfterDelay:0.5];
            }else {
                [[AppDelegate sharedAppDelegate] popViewController];
            }
            
        }];
        
        
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    
}

- (void)setWIFI {
    
    NSString *wifiStr = [NSString stringWithFormat:@"%@",self.wifiArray[0]];
    self.wifiSSid = wifiStr;
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入WIFI密码" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"密码";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertViewTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    }];;
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        CNOpmodeObject *wifiMssage = [[CNOpmodeObject alloc]init];
        wifiMssage.wifiSSid = self.wifiSSid;
        wifiMssage.wifiPassword = self.wifiPassword;
        
        NSDictionary *boxMasterDic = [CNBoxMasterManager boxMasterMessage];
        if (!boxMasterDic) {
            [QMUITips showWithText:@"参数异常" inView:self.view hideAfterDelay:0.3];
            return;
        }
        NSString *familyId = [boxMasterDic objectForKey:kBOX_FamilyIdKey];
        if (!familyId) {
            [QMUITips showWithText:@"参数异常" inView:self.view hideAfterDelay:0.3];
            return;
        }
        
        [QMUITips showLoadingInView:self.view];
        
        NSString *deviceId = [boxMasterDic objectForKey:kBOX_userIdKey];
        if (!deviceId) {
            [QMUITips showWithText:@"参数异常" inView:self.view hideAfterDelay:0.3];
            return;
        }
        [[CNBluetoothManager sharedInstance] setOpmodeObject:wifiMssage devicceID:deviceId];
        __weak typeof(self) weakSelf = self;
        [CNBluetoothManager sharedInstance].netResultBlock = ^(CNBleNetResultState resultState) {
            if (resultState == CNBleNetResultStateBindSuccess) {
                [QMUITips hideAllTipsInView:weakSelf.view];
                
                [QMUITips showLoadingInView:self.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [QMUITips hideAllTipsInView:weakSelf.view];
                    
                    [QMUITips showLoadingInView:weakSelf.view];
                    NSString *familyIdStr = familyId;
                    [CNLiveVoiceBoxModelHelper getNetworkResultWithFamilyId:familyIdStr completerBlick:^(id  _Nonnull data, NSError * _Nonnull error) {
                        
                        [QMUITips hideAllTipsInView:weakSelf.view];
                        
                        __strong typeof(weakSelf) strongSelf = weakSelf;
                        if (!strongSelf) {
                            return;
                        }
                        
                        
                        if (error) {
                            [QMUITips showWithText:@"配网失败,请重新配网" inView:weakSelf.view hideAfterDelay:0.5];
                            if (error.code == 4301) {
                                CNConnectWifiFailController *wifiFailVC = [[CNConnectWifiFailController alloc]init];
                                wifiFailVC.showContentL = @"配网失败,请重新配网";
                                [[AppDelegate sharedAppDelegate] pushViewController:wifiFailVC];
                                return;
                            }
                            
                        }else {
                            CNBoxNetResultModel *boxNetResultModel = [CNBoxNetResultModel mj_objectWithKeyValues:data];
                            if ([boxNetResultModel.isBinded isEqualToString:@"1"] && [boxNetResultModel.result isEqualToString:@"success"]) {
                                CNConnectWIFISuccessController *wifiVC = [[CNConnectWIFISuccessController alloc]init];
                                wifiVC.boxNetResultModel = boxNetResultModel;
                                [[AppDelegate sharedAppDelegate] pushViewController:wifiVC];
                                return;
                            }else if ([boxNetResultModel.isBinded isEqualToString:@"0"]) {
                                [QMUITips showWithText:@"设备已被其他用户绑定" inView:AppKeyWindow hideAfterDelay:1];
                                NSString *contentStr = [NSString stringWithFormat:@"该设备已被%@绑定\n请联系对方删除此设备或添加你为音箱“使用者”",boxNetResultModel.bindtel?:@"xxxxxxxxxxx"];
                                CNConnectWifiFailController *wifiFailVC = [[CNConnectWifiFailController alloc]init];
                                wifiFailVC.showContentL = contentStr;
                                wifiFailVC.phoneNumber = [NSString stringWithFormat:@"%@",boxNetResultModel.phone ?: @""];
                                [[AppDelegate sharedAppDelegate] pushViewController:wifiFailVC];
                                return;
                            }else {
                                [QMUITips showWithText:@"配网失败,请重新配网" inView:AppKeyWindow hideAfterDelay:1];
                                CNConnectWifiFailController *wifiFailVC = [[CNConnectWifiFailController alloc]init];
                                wifiFailVC.showContentL = @"配网失败,请重新配网";
                                [[AppDelegate sharedAppDelegate] pushViewController:wifiFailVC];
                                return;
                            }
                        }
                        
                        
                    }];
                    
                });
                
            }
            
            
            if (resultState == CNBleNetResultStateBindFail) {
                
                [QMUITips hideAllTipsInView:weakSelf.view];
                
                [QMUITips showLoadingInView:weakSelf.view];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [QMUITips hideAllTipsInView:weakSelf.view];
                    
                    [QMUITips showLoadingInView:weakSelf.view];
                    NSString *familyIdStr = familyId;
                    [CNLiveVoiceBoxModelHelper getNetworkResultWithFamilyId:familyIdStr completerBlick:^(id  _Nonnull data, NSError * _Nonnull error) {
                        
                        [QMUITips hideAllTipsInView:weakSelf.view];
                        
                        __strong typeof(weakSelf) strongSelf = weakSelf;
                        if (!strongSelf) {
                            return;
                        }
                        
                        
                        if (error) {
                            [QMUITips showWithText:@"配网失败,请重新配网" inView:weakSelf.view hideAfterDelay:0.5];
                            if (error.code == 4301) {
                                CNConnectWifiFailController *wifiFailVC = [[CNConnectWifiFailController alloc]init];
                                wifiFailVC.showContentL = @"配网失败,请重新配网";
                                [[AppDelegate sharedAppDelegate] pushViewController:wifiFailVC];
                                return;
                            }
                            
                        }else {
                            CNBoxNetResultModel *boxNetResultModel = [CNBoxNetResultModel mj_objectWithKeyValues:data];
                            if ([boxNetResultModel.isBinded isEqualToString:@"1"] && [boxNetResultModel.result isEqualToString:@"success"]) {
                                CNConnectWIFISuccessController *wifiVC = [[CNConnectWIFISuccessController alloc]init];
                                wifiVC.boxNetResultModel = boxNetResultModel;
                                [[AppDelegate sharedAppDelegate] pushViewController:wifiVC];
                                return;
                            }else if ([boxNetResultModel.isBinded isEqualToString:@"0"]) {
                                [QMUITips showWithText:@"设备已被其他用户绑定" inView:AppKeyWindow hideAfterDelay:1];
                                NSString *contentStr = [NSString stringWithFormat:@"该设备已被%@绑定\n请联系对方删除此设备或添加你为音箱“使用者”",boxNetResultModel.bindtel?:@"xxxxxxxxxxx"];
                                CNConnectWifiFailController *wifiFailVC = [[CNConnectWifiFailController alloc]init];
                                wifiFailVC.showContentL = contentStr;
                                wifiFailVC.phoneNumber = [NSString stringWithFormat:@"%@",boxNetResultModel.phone ?: @""];
                                [[AppDelegate sharedAppDelegate] pushViewController:wifiFailVC];
                                return;
                            }else {
                                [QMUITips showWithText:@"配网失败,请重新配网" inView:AppKeyWindow hideAfterDelay:1];
                                CNConnectWifiFailController *wifiFailVC = [[CNConnectWifiFailController alloc]init];
                                wifiFailVC.showContentL = @"配网失败,请重新配网";
                                [[AppDelegate sharedAppDelegate] pushViewController:wifiFailVC];
                                return;
                            }
                        }
                        
                        
                    }];
                    
                });
                
            }
            
            if (resultState == CNBleNetResultStateLinkFail) {
                if (weakSelf) {
                    [QMUITips hideAllTipsInView:weakSelf.view];
                    [QMUITips showWithText:@"配网失败,请重新配网" inView:weakSelf.view hideAfterDelay:1.5];
                }
                
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (weakSelf) {
                    [QMUITips hideAllTipsInView:weakSelf.view];
                    [QMUITips showWithText:@"配网失败,请重新配网" inView:weakSelf.view hideAfterDelay:1.5];
                }
                
            });
            
            
            
        };
        
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}



- (NSString *)currentWifiBSSID{
    
    if (@available(iOS 13.0, *)) {
        //用户明确拒绝，可以弹窗提示用户到设置中手动打开权限
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            
            [QMUITips showWithText:@"获取地理定位授权失败,请打开地理授定位权重试" inView:self.view hideAfterDelay:0.5];
            //使用下面接口可以打开当前应用的设置页面
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            return nil;
        }
        CLLocationManager* cllocation = [[CLLocationManager alloc] init];
        if(![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
            
            //递归等待用户选选择
            [QMUITips showWithText:@"获取地理定位授权失败,请打开地理授定位权重试" inView:self.view hideAfterDelay:0.5];
            
            return nil;
        }
    }
    
    NSString *wifiName = nil;
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    if (!wifiInterfaces) {
        return nil;
    }
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    return wifiName;
}

- (NSString *)getWifiSsidWithCallback{
    
    NSString *wifiName = nil;
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    if (!wifiInterfaces) {
        return nil;
    }
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    return wifiName;
    
}

- (NSString *)getWifiBSSidWithCallback {
    
    NSString *wifiName = nil;
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    if (!wifiInterfaces) {
        return nil;
    }
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeyBSSID];
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    return wifiName;
    
}

#pragma mark - 懒加载

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.layer.masksToBounds = YES;
        _backBtn.layer.cornerRadius = 25;
        [_backBtn setTitle:@"上一步" forState:UIControlStateNormal];
        [_backBtn setTitleColor:RGBCOLOR(47, 221, 32) forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _backBtn;
    
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.layer.masksToBounds = YES;
        _nextBtn.layer.cornerRadius = 25;
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _nextBtn.backgroundColor = RGBCOLOR(47, 221, 32);
    }
    return _nextBtn;
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[CNLiveBOXWiFiCell class] forCellReuseIdentifier:kCNLiveBOXWiFiCell];
        [_tableView setBackgroundColor:RGBACOLOR(242, 242, 242, 1)];
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 12)];
        _tableView.tableHeaderView = headerView;
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 200)];
        UILabel *contentL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, 200)];
        [footerView addSubview:contentL];
        contentL.numberOfLines = 0;
        contentL.text = @"\n1. 去系统设置连接WIFI[设置-无线局域网],返回此页面点击\"下一步\"输入密码连接.\n2. 若页面未刷新,请耐心等待或重试";
        contentL.font = [UIFont systemFontOfSize:14];
        //让内容置顶
        [contentL sizeToFit];
        contentL.textColor = RGBCOLOR(143, 143, 143);
        _tableView.tableFooterView = footerView;
       
        
        
    }
    return _tableView;
}



@end
