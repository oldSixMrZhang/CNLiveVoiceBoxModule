//
//  CNVoiceBoxSearchDeviceController.m
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/9/17.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import "CNVoiceBoxSearchDeviceController.h"
#import "CNLiveSearchDeviceCell.h"
#import "CNSearchDeviceHelperController.h"
#import "CNVoiceBoxSearchWifiController.h"
#import "CNBluetoothManager.h"

#define SetAfterEndSeconds 60

@implementation  UIView (MBCNLiveUploadProgressHUD)
// 只显示指示器
- (MBProgressHUD *)showImgProgressHUD {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    if (nil == hud) {
        hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    }
    hud.mode = MBProgressHUDModeCustomView;
    hud.color = [UIColor clearColor];
    
    //loading图片和动画
    UIImage *image = [[UIImage imageNamed:@"device_loding"] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    anima.toValue = @(M_PI*2);
    anima.duration = 1.0f;
    anima.repeatCount = 100;
    anima.removedOnCompletion = NO;
    [imgView.layer addAnimation:anima forKey:nil];
    
    UIImage *image_ye = [[UIImage imageWithColor:[UIColor whiteColor]] imageWithRenderingMode:UIImageRenderingModeAutomatic];
    UIImageView *imgCenterView = [[UIImageView alloc] initWithImage:image_ye];
    
    UIImageView *contentView = [[UIImageView alloc] initWithImage:image_ye];
    [contentView addSubview:imgView];
    [contentView addSubview:imgCenterView];
    imgCenterView.center = contentView.center;
    imgView.center = contentView.center;
    hud.customView = contentView;
    
    //背景颜色
    hud.backgroundColor = [UIColor clearColor];
    [hud.customView setBackgroundColor:[UIColor whiteColor]];
    
    //背景宽高
    CGFloat targetWidth;
    CGFloat targetHeight;
    CGFloat margin = 10.0f;
    targetWidth = imgView.width + margin*2;
    targetHeight = imgView.height + margin*2;
    CGSize newSize = CGSizeMake(targetWidth, targetHeight);
    hud.minSize = newSize;
    
    //颜色
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

// 移除活动指示
- (void)hideImgActivity
{
    NSArray *array = [MBProgressHUD allHUDsForView:self];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        MBProgressHUD *hud = (MBProgressHUD *)obj;
        if (hud) {
            [hud hide:YES];
        }
    }];
}


@end

@interface CNVoiceBoxSearchDeviceController ()<UITableViewDelegate,UITableViewDataSource>

/*** 未发现设备 ***/
@property (strong, nonatomic) UIButton *noDeviceBtn;

/*** 返回 ***/
@property (strong, nonatomic) UIButton *backBtn;

/*** 配对 ***/
@property (strong, nonatomic) UIButton *pairingBtn;

/*** 列表 ***/
@property (strong, nonatomic) UITableView *tableView;

/*** footerView ***/
@property (strong, nonatomic) UIView *failureFooterView;

/*** 蓝牙设备 ***/
@property (strong, nonatomic) CNBluetoothManager *bluetoothManager;
/*** 设备个数 ***/
@property (strong, nonatomic) NSMutableArray *deviceArray;
/*** 扫描状态 ***/
@property (assign, nonatomic) BOOL isSearch;


@end

@implementation CNVoiceBoxSearchDeviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:RGBCOLOR(242, 242, 242)];
    self.title = @"选择配对设备";
    
    [self setupUI];
    [self layoutUI];
    
   
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.deviceArray = [NSMutableArray array];
    if (self.tableView) {
        [self.tableView reloadData];
        [self.view hideImgActivity];
    }
    if (self.bluetoothManager) {
        [self.bluetoothManager cancelAllConnect];
    }
    self.bluetoothManager = [CNBluetoothManager sharedInstance];
    self.isSearch = NO;
    [self startScanPeripherals];
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.noDeviceBtn];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.pairingBtn];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    }else {
        self.tableView.frame = CGRectMake(0, kNavigationBarHeight, KScreenWidth, KScreenHeight);
    }

}

- (void)layoutUI {
    
    __weak typeof(self) weakSelf = self;
    [self.pairingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-40);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.width.mas_equalTo(263);
        make.height.mas_equalTo(44);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.pairingBtn.mas_top).offset(-10);
        make.centerX.equalTo(weakSelf.pairingBtn.mas_centerX);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(44);
    }];
    
    [self.noDeviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.backBtn.mas_top);
        make.centerX.equalTo(weakSelf.pairingBtn.mas_centerX);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(50);
    }];
    
}

/*** 开启扫描 ***/
- (void)startScanPeripherals {
    if (self.isSearch == YES) {
        return;
    }
    
    [self.bluetoothManager scanPeripherals];
    self.isSearch = YES;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.view showImgProgressHUD];
    [self.view bringSubviewToFront:self.backBtn];
    [self.view bringSubviewToFront:self.noDeviceBtn];
    __weak typeof(self) weakSelf = self;
    self.bluetoothManager.searchResultBlock = ^(NSMutableArray *deviceArray) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        [weakSelf.view hideImgActivity];
        if (deviceArray.count > 0) {
            strongSelf.deviceArray = deviceArray;
            [weakSelf.tableView reloadData];
        }
    };
      
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( SetAfterEndSeconds* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        [weakSelf.view hideImgActivity];
          
        [self.bluetoothManager stopScanPeripherals];
        self.isSearch = NO;
        if (strongSelf.deviceArray.count == 0) {
            weakSelf.failureFooterView.hidden = NO;
            weakSelf.failureFooterView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 200);
            weakSelf.tableView.tableFooterView = weakSelf.failureFooterView;
        }else {
            weakSelf.failureFooterView.hidden = YES;
            weakSelf.failureFooterView.frame = CGRectZero;
            weakSelf.tableView.tableFooterView = weakSelf.failureFooterView;
        }
    });
}



#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.deviceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
#pragma mark - TODO:根据接口数据来绑定选择显示

    CNLiveSearchDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:kCNLiveSearchDeviceCell forIndexPath:indexPath];
    if (self.deviceArray.count > indexPath.row) {
        CNLiveBoxDevice *device = [self.deviceArray objectAtIndex:indexPath.row];
        [cell eidtUI:device];
    }

    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __block BOOL isHaveSelect = NO;
    [self.deviceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CNLiveBoxDevice *device = obj;
        if (device) {
            if (idx == indexPath.row) {
                device.isSelect = !device.isSelect;
            }else {
                device.isSelect = NO;
            }
        }
        if (device.isSelect) {
            isHaveSelect = YES;
        }
      
    }];
    
    [self.tableView reloadData];
    
    if (isHaveSelect) {
        self.pairingBtn.selected = NO;
        self.pairingBtn.backgroundColor = RGBCOLOR(47, 221, 32);
        CNLiveBoxDevice *device = [self.deviceArray objectAtIndex:indexPath.row];
        if (device) {
            self.bluetoothManager.currentdevice = device;
        }
       
    }else {
        self.pairingBtn.selected = YES;
        self.pairingBtn.backgroundColor = RGBCOLOR(200, 200, 200);
        self.bluetoothManager.currentdevice = nil;
    }
    
}



#pragma mark - 事件实现
- (void)noDeviceBtnAction:(UIButton *)noDeviceBtn {
    CNSearchDeviceHelperController *helperVC = [[CNSearchDeviceHelperController alloc]init];
    [[AppDelegate sharedAppDelegate] pushViewController:helperVC];
}

- (void)backBtnAction:(UIButton *)backBtn {
    [[AppDelegate sharedAppDelegate] popViewController];

}

- (void)pairingBtnAction:(UIButton *)pairingBtn {
    
    __block BOOL isHaveSelect = NO;
    [self.deviceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CNLiveBoxDevice *device = obj;
        if (device.isSelect) {
            isHaveSelect = YES;
        }
      
    }];
    
    if (!isHaveSelect) {
        return;
    }

    if (self.bluetoothManager.currentdevice) {
        [self.bluetoothManager connectDevice];
        [QMUITips showLoadingInView:self.view];
        __weak typeof(self) weakSelf = self;
        __block BOOL isEnter = NO;
        self.bluetoothManager.connectResultBlock = ^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
 
           [QMUITips hideAllTipsInView:weakSelf.view];
            if (isEnter == NO) {
                 
                 if (error) {
                     [QMUITips showInfo:@"配对失败" inView:weakSelf.view hideAfterDelay:0.5];
                               return;
                 }else {
                     CNVoiceBoxSearchWifiController *searchWifiVC = [[CNVoiceBoxSearchWifiController alloc]init];
                     searchWifiVC.wifiStatus = VoiceBoxSearchWifiStatusNormal;
                     [[AppDelegate sharedAppDelegate] pushViewController:searchWifiVC];
                 }
            }

            isEnter = YES;
            
        };
    }
    
}

- (void)retryBtnAction:(UIButton *)retryBtn {
    [self startScanPeripherals];
    
}


#pragma mark - 懒加载

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[CNLiveSearchDeviceCell class] forCellReuseIdentifier:kCNLiveSearchDeviceCell];
        [_tableView setBackgroundColor:RGBACOLOR(242, 242, 242, 1)];
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 12)];
        _tableView.tableHeaderView = headerView;
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView = footerView;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        
    }
    return _tableView;
}

- (UIButton *)noDeviceBtn {
    if (!_noDeviceBtn) {
        _noDeviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_noDeviceBtn setTitleColor:RGBCOLOR(153, 153, 153) forState:UIControlStateNormal];
        [_noDeviceBtn addTarget:self action:@selector(noDeviceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _noDeviceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        NSString *sum_str = [NSString stringWithFormat:@"%@",@"未发现设备?"];
        NSMutableAttributedString * att_str = [[NSMutableAttributedString alloc] initWithString:sum_str];
        [att_str addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(153, 153, 153) range:[sum_str rangeOfAll]];
        [att_str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:[sum_str rangeOfAll]];
        [_noDeviceBtn setAttributedTitle:att_str forState:UIControlStateNormal];
    }
    return _noDeviceBtn;
    
}


- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setTitleColor:RGBCOLOR(35, 212, 30) forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        NSString *sum_str = [NSString stringWithFormat:@"%@",@"上一步"];
        [_backBtn setTitle:sum_str forState:UIControlStateNormal];
    }
    return _backBtn;
    
}

- (UIButton *)pairingBtn {
    if (!_pairingBtn) {
        _pairingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _pairingBtn.layer.masksToBounds = YES;
        _pairingBtn.layer.cornerRadius = 22;
        [_pairingBtn setTitle:@"配对" forState:UIControlStateNormal];
        [_pairingBtn setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
        [_pairingBtn addTarget:self action:@selector(pairingBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _pairingBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _pairingBtn.backgroundColor = RGBCOLOR(200, 200, 200);
    }
    return _pairingBtn;
    
}

- (UIView *)failureFooterView {
    if (!_failureFooterView) {
        _failureFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 200)];
        
        UILabel *showTextL = [[UILabel alloc]initWithFrame:CGRectMake(10, 134, KScreenWidth, 22)];
        showTextL.text = @"未发现设备";
        showTextL.textColor = UIColorMake(195, 195, 195);
        showTextL.font = [UIFont systemFontOfSize:22];
        showTextL.textAlignment = NSTextAlignmentCenter;
        [_failureFooterView addSubview:showTextL];
        
        UIButton *retryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [retryBtn setTitle:@"重试" forState:UIControlStateNormal];
        [retryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        retryBtn.backgroundColor = UIColorMake(35, 212, 30);
        [retryBtn addTarget:self action:@selector(retryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        retryBtn.frame = CGRectMake(showTextL.centerX - 35, showTextL.bottom + 74, 70, 30);
        [_failureFooterView addSubview:retryBtn];
        
        UILabel *showTipL = [[UILabel alloc]initWithFrame:CGRectMake(0, retryBtn.bottom + 32, KScreenWidth, 15)];
        showTipL.textAlignment = NSTextAlignmentCenter;
        showTextL.text = @"请尝试重启设备或重新进入配网模式";
        showTextL.font = [UIFont systemFontOfSize:15];
        showTextL.textColor = UIColorMake(40, 40, 40);
        [_failureFooterView addSubview:showTipL];
        
        
    }
    
    return _failureFooterView;
}





@end
