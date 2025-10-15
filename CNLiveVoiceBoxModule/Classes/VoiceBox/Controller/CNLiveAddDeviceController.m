//
//  CNLiveAddDeviceController.m
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/9/12.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import "CNLiveAddDeviceController.h"
#import "CNLiveVoiceBoxCell.h"
#import "CNLiveAddVoiceBoxCell.h"
#import "CNLiveVoiceBoxSetController.h"
#import "CNLiveVoiceBoxFirstTipController.h"
#import "CNLiveVoiceBoxModelHelper.h"
#import "CNBoxDetailModel.h"
#import "CNLiveBoxSetViewController.h"
#import "CNBoxMasterManager.h"


@interface CNLiveAddDeviceController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) UIBarButtonItem *openItem;

@property (strong, nonatomic) UIBarButtonItem *btnItem;

@property (strong, nonatomic) CLLocationManager *locationManager;



@end

@implementation CNLiveAddDeviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray array];
    
    [self setupUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getFamilyIdAndDetail];
}

- (void)setupUI {
    
    /*** title ***/
    self.title = @"所有设备";
    
    /*** 右侧按钮 ***/
    UIBarButtonItem *openItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"device_box_set"] style:UIBarButtonItemStylePlain target:self action:@selector(boxSetButtonItemAction:)];
    self.openItem = openItem;
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"device_img"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonItemAction:)];
    self.btnItem = btnItem;
    
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    }else {
        self.tableView.frame = CGRectMake(0, kNavigationBarHeight, KScreenWidth, KScreenHeight);
    }
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = self.dataArray.count + 1;
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == self.dataArray.count) {
        return 1;
    }else {
        
        if (self.dataArray.count > 0) {
            CNLiveAllVoiceBoxModel *boxModel = [self.dataArray objectAtIndex:section];
            NSMutableArray *deviceListArray = boxModel.deviceList;
            if (deviceListArray) {
                return deviceListArray.count;
            }else {
                return 0;
            }
        }else {
            return 0;
        }
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == self.dataArray.count) {
        CNLiveAddVoiceBoxCell *addBoxCell = [tableView dequeueReusableCellWithIdentifier:kCNLiveAddVoiceBoxCell forIndexPath:indexPath];
        return addBoxCell;
    }else {
        CNLiveVoiceBoxCell *cell = [tableView dequeueReusableCellWithIdentifier:kCNLiveVoiceBoxCell forIndexPath:indexPath];
        
        CNLiveAllVoiceBoxModel *boxModel = [self.dataArray objectAtIndex:indexPath.section];
        if (boxModel.deviceList.count > 0) {
            CNBoxDeviceModel *boxDeviceModel = [boxModel.deviceList objectAtIndex:indexPath.row];
            if (boxDeviceModel) {
                [cell eidtUI:boxDeviceModel];
            }
        }
        
        return cell;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == self.dataArray.count) {
        
        [self enterFirstTipVC];
        
        
    }else {
        
        CNBoxDeviceModel *boxDeviceModel = nil;
        CNLiveAllVoiceBoxModel *boxModel = [self.dataArray objectAtIndex:indexPath.section];
        
        
        if (boxModel.deviceList.count > 0) {
            boxDeviceModel = [boxModel.deviceList objectAtIndex:indexPath.row];
        }
        if (!boxDeviceModel || !boxModel) {
            [QMUITips showWithText:@"参数不多" inView:self.view hideAfterDelay:0.5];
            return;
        }
        
        NSString *familyId = [NSString stringWithFormat:@"%@",boxModel.familyId];
        
        CNLiveVoiceBoxSetController *setVC = [[CNLiveVoiceBoxSetController alloc] init];
        setVC.deviceModel = boxDeviceModel;
        setVC.boxModel = boxModel;
        setVC.isMaster = [NSString stringWithFormat:@"%@",boxModel.isMaster];
        setVC.familyId = familyId;
        [[AppDelegate sharedAppDelegate] pushViewController:setVC];
        
        
    }
    
    
    
}


#pragma mark - 接口
#pragma mark - 家庭详情接口
- (void)getFamilyIdAndDetail {
    [QMUITips showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    [CNLiveVoiceBoxModelHelper getFamilyIdAndBoxDetailCompleterBlock:^(id  _Nonnull data, NSError * _Nonnull error) {
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
            
            [weakSelf showEmptyViewWithImage:[UIImage imageNamed:@"wufalianjie"] text:showText detailText:@"别紧张，试试看刷新页面~" buttonTitle:@"     重试     " buttonAction:@selector(getFamilyIdAndDetail)];
            [weakSelf setCNAPIErrorEmptyView];
            weakSelf.emptyView.frame = CGRectMake(0, kNavigationBarHeight, KScreenWidth, KScreenHeight - kNavigationBarHeight);
            weakSelf.emptyView.backgroundColor = [UIColor whiteColor];
            
            //失败显示一个
            weakSelf.navigationItem.rightBarButtonItems = @[weakSelf.btnItem];
            
            return;
            
        }else {
            
            /** 有网络 */
            if (weakSelf.emptyView) {
                [weakSelf hideEmptyView];
            }
            
            /** 处理数据 */
            NSDictionary *dataDic = data;
            if (dataDic.count > 0 && [dataDic containsObjectForKey:@"users"]) {
                NSMutableArray *usersArray = [dataDic objectForKey:@"users"];
                
                [usersArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary *userDic = obj;
                    if ([userDic containsObjectForKey:@"isMaster"]) {
                        NSString *isMasterStr = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"isMaster"]];
                        if ([isMasterStr isEqualToString:@"0"]) {//0是主人
                            
                            NSMutableDictionary *masterDic = [NSMutableDictionary dictionary];
                            
                            NSString *isMaster = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"isMaster"]];
                            [masterDic setValue:isMaster forKey:kBOX_isMasterKey];
                            NSString *phone = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"phone"]];
                            [masterDic setValue:phone forKey:kBOX_phoneKey];
                            NSString *userId = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"userId"]];
                            [masterDic setValue:userId forKey:kBOX_userIdKey];
                            NSString *idStr = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"id"]];
                            [masterDic setValue:idStr forKey:kBOX_FamilyIdKey];
                            NSString *token = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"token"]];
                            [masterDic setValue:token forKey:kBOX_tokenKey];
                            NSString *name = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"name"]];
                            [masterDic setValue:name forKey:kBOX_nameKey];
                            
                            [CNBoxMasterManager boxUserDefaultsWithDic:masterDic];
                            
                            
                        }
                    }
                    
                }];
            }
            
            
            CNBoxDetailModel *boxDetailModel = [CNBoxDetailModel mj_objectWithKeyValues:data];
            if (boxDetailModel.users) {
                strongSelf.dataArray = boxDetailModel.users;
            }
            
            __block NSInteger deviceCount = 0;
            [strongSelf.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CNLiveAllVoiceBoxModel *boxModel = obj;
                
                NSMutableArray *deviceListArray = boxModel.deviceList;
                [deviceListArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj) {
                        deviceCount ++;
                    }
                    
                }];
                
            }];
            /*** 没设备 ***/
            if (deviceCount > 0) {//有设备
                weakSelf.navigationItem.rightBarButtonItems = @[weakSelf.btnItem,weakSelf.openItem];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CNWjjIsYiDongBoxUserKey];
            }else {//无设备
                weakSelf.navigationItem.rightBarButtonItems = @[weakSelf.btnItem];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:CNWjjIsYiDongBoxUserKey];
            }
            
            
            [weakSelf.tableView reloadData];
            
        }
        
        
        
        
    }];
}




#pragma mark - 事件实现
- (void)rightButtonItemAction:(id)sender {
    
    [self enterFirstTipVC];
    
}

#pragma mark - 定位权限和跳转
- (void)enterFirstTipVC {
    
    if (@available(iOS 13.0, *)) {
        if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
            
            //定位功能可用
            
        }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            
            //定位不能用
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
                
               [self.locationManager requestWhenInUseAuthorization];
                
            }else {
                 [QMUITips showWithText:@"请去系统设置页面->开启定位权限" inView:self.view hideAfterDelay:1.5];
                
            }
           
            return;
            
        }
        
    }
    
    CNLiveVoiceBoxFirstTipController *firstTipVC = [[CNLiveVoiceBoxFirstTipController alloc]init];
    [[AppDelegate sharedAppDelegate] pushViewController:firstTipVC];
    
}

#pragma mark - 定位代理
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NSLog(@"定位中....");
   
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"授权状态改变");
    
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized)) {
                  
           //定位功能可用
           CNLiveVoiceBoxFirstTipController *firstTipVC = [[CNLiveVoiceBoxFirstTipController alloc]init];
           [[AppDelegate sharedAppDelegate] pushViewController:firstTipVC];
                  
       }
}

- (void)boxSetButtonItemAction:(id)sender {
    
    CNLiveBoxSetViewController *setVC = [[CNLiveBoxSetViewController alloc]init];
    [[AppDelegate sharedAppDelegate] pushViewController:setVC];
    
}

#pragma mark - 属性
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[CNLiveVoiceBoxCell class] forCellReuseIdentifier:kCNLiveVoiceBoxCell];
        [_tableView registerClass:[CNLiveAddVoiceBoxCell class] forCellReuseIdentifier:kCNLiveAddVoiceBoxCell];
        [_tableView setBackgroundColor:RGBACOLOR(242, 242, 242, 1)];
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 12)];
        _tableView.tableHeaderView = headerView;
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView = footerView;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}






@end
