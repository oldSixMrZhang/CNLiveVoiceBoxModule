//
//  CNLiveVoiceBoxManagerController.m
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/9/18.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import "CNLiveVoiceBoxManagerController.h"
#import "CNLiveDeviceManagerCell.h"
#import "CNBoxEditDeviceNameController.h"
#import "CNVoiceBoxSearchWifiController.h"
#import "CNBoxDeviceMessageController.h"
#import "CNBOXFirmwareUpdateController.h"
#import "CNLiveVoiceBoxModelHelper.h"
#import "CNBOXDeviceDetailModel.h"
#import "CNLiveVoiceBoxModelHelper.h"
#import "CNLiveAddDeviceController.h"
#import "CNLiveVoiceBoxNextTipController.h"

@interface CNLiveVoiceBoxManagerController ()<UITableViewDelegate,UITableViewDataSource>


/*** 列表 ***/
@property (strong, nonatomic) UITableView *tableView;

/*** 删除设备 ***/
@property (strong, nonatomic) UIButton *deleteBtn;

/*** 内容 ***/
@property (strong, nonatomic) CNBOXDeviceDetailModel *detailModel;

@end

@implementation CNLiveVoiceBoxManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设备管理";
    [self.view setBackgroundColor:RGBCOLOR(242, 242, 242)];
    
    [self setupUI];
    [self layoutUI];
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *deviceIdStr = [NSString stringWithFormat:@"%@",self.deviceModel.mcid];
    [self getDeviceDetailMsg:deviceIdStr];
}

- (void)loadData {
    NSString *deviceIdStr = [NSString stringWithFormat:@"%@",self.deviceModel.mcid];
    [self getDeviceDetailMsg:deviceIdStr];
}


- (void)setupUI {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.deleteBtn];
    
    if ([self.isMaster isEqualToString:@"1"]) {
        self.deleteBtn.hidden = YES;
    }else {
        self.deleteBtn.hidden = NO;
    }
    
    if (@available(iOS 11.0, *)) {
        self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - kNavigationBarHeight);
    }else {
        self.tableView.frame = CGRectMake(0, kNavigationBarHeight, KScreenWidth, KScreenHeight - kNavigationBarHeight);
    }
       
   
    self.deleteBtn.frame = CGRectMake(0, KScreenHeight - 60, KScreenWidth, 60);
    
}

- (void)layoutUI {
    
    __weak typeof(self) weakSelf = self;
    
}


#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section <= 3) {
        CNLiveDeviceManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:kCNLiveDeviceManagerCell forIndexPath:indexPath];
        
        if (indexPath.section == 0) {
            [cell editUIWithStatus:CNLiveDeviceManagerCellStatusTip];
            cell.nameL.text = @"音箱名称";
            cell.contentL.text = [NSString stringWithFormat:@"%@",self.detailModel.deviceName ?: @""];
            
        }else if (indexPath.section == 1) {
            [cell editUIWithStatus:CNLiveDeviceManagerCellStatusNormal];
            cell.nameL.text = @"WIFI设置";
            cell.contentL.text = [NSString stringWithFormat:@"%@",self.detailModel.wifiName ?: @""];
            
        }else if (indexPath.section == 2) {
            [cell editUIWithStatus:CNLiveDeviceManagerCellStatusNoTip];
            cell.nameL.text = @"设备信息";
            
            
        }else if (indexPath.section == 3) {
            [cell editUIWithStatus:CNLiveDeviceManagerCellStatusNormal];
            cell.nameL.text = @"固件升级";
            cell.contentL.text = [NSString stringWithFormat:@"%@",self.detailModel.ver ? : @""];;
            
        }
        
        
        return cell;
    }else {
        
        CNLiveDeviceControlCell *cell = [tableView dequeueReusableCellWithIdentifier:kCNLiveDeviceControlCell forIndexPath:indexPath];
        
        if (indexPath.section == 4) {
            cell.nameL.text = @"远程控制";
            cell.contentL.text = @"手机可远程控制音箱播放的内容，但仅限听见中国";
            
        }else if (indexPath.section == 5) {
            cell.nameL.text = @"小家音箱播放";
            cell.contentL.text = @"音箱可作为蓝牙音箱，播放手机内所有声音";
            
        }
        
        return cell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 3) {
        return 91;
    }
    return 61;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {//音箱名字更改
        if ([self.isMaster isEqualToString:@"1"]) {
            [QMUITips showWithText:@"没有设置权限" inView:self.view hideAfterDelay:0.5];
            return;
        }
        CNBoxEditDeviceNameController *editDeviceNameVC = [[CNBoxEditDeviceNameController alloc]init];
        editDeviceNameVC.boxNameStr = [NSString stringWithFormat:@"%@",self.detailModel.deviceName ?: @""];
        editDeviceNameVC.deviceID = [NSString stringWithFormat:@"%@",self.deviceModel.mcid ?: @""];
        editDeviceNameVC.isMaster = [NSString stringWithFormat:@"%@", self.isMaster];
        [[AppDelegate sharedAppDelegate] pushViewController:editDeviceNameVC];
        
    }else if (indexPath.section == 1) {//配网
        
        if ([self.isMaster isEqualToString:@"1"]) {
            [QMUITips showWithText:@"没有设置权限" inView:self.view hideAfterDelay:0.5];
            return;
        }
        
        CNLiveVoiceBoxNextTipController *nextTipVC = [[CNLiveVoiceBoxNextTipController alloc]init];
        [[AppDelegate sharedAppDelegate] pushViewController:nextTipVC];
        
        
//        CNVoiceBoxSearchWifiController *firstTipVC = [[CNVoiceBoxSearchWifiController alloc]init];
//        firstTipVC.wifiStatus = VoiceBoxSearchWifiStatusChange;
//        firstTipVC.detailModel = self.detailModel;
//        firstTipVC.deviceModel = self.deviceModel;
//        [[AppDelegate sharedAppDelegate] pushViewController:firstTipVC];
        
    }else if (indexPath.section == 2) {//设备信息
        CNBoxDeviceMessageController *messageVC = [[CNBoxDeviceMessageController alloc]init];
        messageVC.detailModel = self.detailModel;
        [[AppDelegate sharedAppDelegate] pushViewController:messageVC];
        
        
    }else if (indexPath.section == 3) {//硬件升级
        CNBOXFirmwareUpdateController *firmwareUpdateVC = [[CNBOXFirmwareUpdateController alloc]init];
        firmwareUpdateVC.versionStr = [NSString stringWithFormat:@"%@",self.detailModel.ver ?: @""];
        firmwareUpdateVC.updateVerStr = [NSString stringWithFormat:@"%@",self.detailModel.updateVer ?: @""];
        [[AppDelegate sharedAppDelegate] pushViewController:firmwareUpdateVC];
        
    }
    
    
}
#pragma mark - 实现
- (void)deleteBtnAction:(UIButton *)sender {
    
    
    NSLog(@"删除设备");
    
    NSString *decID = [NSString stringWithFormat:@"%@",self.deviceModel.mcid ?: @""];
    NSString *oldName = [NSString stringWithFormat:@"%@",self.detailModel.deviceName ?: @""];
    [QMUITips showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    [CNLiveVoiceBoxModelHelper deleteDeviceWithDevId:decID oldName:oldName completerBlick:^(id  _Nonnull data, NSError * _Nonnull error) {
        [QMUITips hideAllTipsInView:weakSelf.view];
        if (error) {
            [QMUITips showWithText:@"解绑失败" inView:weakSelf.view hideAfterDelay:0.5];
        }else {
            UIViewController *target = nil;
            for (UIViewController * controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[CNLiveAddDeviceController class]]) {
                    target = controller;
                }
            }
            if (target) {
                [[AppDelegate sharedAppDelegate] popToViewController:target];
            }else {
                [[AppDelegate sharedAppDelegate] popToRootViewController];
            }
            
            
            
        }
        
    }];
    
    
    
}

#pragma mark - 接口
- (void)getDeviceDetailMsg:(NSString *)devId {
    NSString *deviceStr = [NSString stringWithFormat:@"%@",devId];
    
    [QMUITips showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    [CNLiveVoiceBoxModelHelper getDeviceDetailMsgWithDeviceId:deviceStr completerBlick:^(id  _Nonnull data, NSError * _Nonnull error) {
        [QMUITips hideAllTipsInView:weakSelf.view];
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        if (error) {
            
            NSString *showText = @"网络连接失败，请稍后再试";
            if (error.code == -1001 || error.code == -1009) {//没有网络
                
            }else {
                showText = @"请求失败,请重试";
            }
            
            [weakSelf showEmptyViewWithImage:[UIImage imageNamed:@"wufalianjie"] text:showText detailText:@"别紧张，试试看刷新页面~" buttonTitle:@"     重试     " buttonAction:@selector(loadData)];
            [weakSelf setCNAPIErrorEmptyView];
            weakSelf.emptyView.frame = CGRectMake(0, kNavigationBarHeight, KScreenWidth, KScreenHeight - kNavigationBarHeight);
            weakSelf.emptyView.backgroundColor = [UIColor whiteColor];
            
        }else {
            
            /** 有网络 */
            if (weakSelf.emptyView) {
                [weakSelf hideEmptyView];
            }
            
            NSDictionary *contentDic = data;
            CNBOXDeviceDetailModel *detailModel = [CNBOXDeviceDetailModel mj_objectWithKeyValues:contentDic];
            weakSelf.detailModel = detailModel;
            [weakSelf.tableView reloadData];
            
        }
        
    }];
    
}


#pragma mark - 属性
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[CNLiveDeviceManagerCell class] forCellReuseIdentifier:kCNLiveDeviceManagerCell];
        [_tableView registerClass:[CNLiveDeviceControlCell class] forCellReuseIdentifier:kCNLiveDeviceControlCell];
        [_tableView setBackgroundColor:RGBACOLOR(242, 242, 242, 1)];
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView = footerView;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:RGBCOLOR(235, 61, 63) forState:UIControlStateNormal];
        _deleteBtn.backgroundColor = [UIColor whiteColor];
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
    
}




@end
