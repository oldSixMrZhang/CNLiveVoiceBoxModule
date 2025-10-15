//
//  CNLiveVoiceBoxNextTipController.m
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/9/17.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import "CNLiveVoiceBoxNextTipController.h"
#import "CNVoiceBoxSearchDeviceController.h"
#import "CNBluetoothManager.h"

@interface CNLiveVoiceBoxNextTipController ()

/*** 内容View ***/
@property (strong, nonatomic) UIView *contentView;

/*** tipImageView ***/
@property (strong, nonatomic) UIImageView *tipImageV;

/*** tipName ***/
@property (strong, nonatomic) UILabel *tipNameL;

/*** 返回 ***/
@property (strong, nonatomic) UIButton *backBtn;

/*** nextBtn ***/
@property (strong, nonatomic) UIButton *nextBtn;

@property (strong, nonatomic) CNBluetoothManager *bluetoothManager;

@end

@implementation CNLiveVoiceBoxNextTipController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:RGBCOLOR(242, 242, 242)];
    [self setupUI];
    [self layoutUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.bluetoothManager = [CNBluetoothManager sharedInstance];
    self.bluetoothManager.bleStateBlock = ^(CNBleState bleState) {
        
        NSLog(@"蓝牙状态更变");
        
    };
}


- (void)setupUI {
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.tipImageV];
    [self.view addSubview:self.tipNameL];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.nextBtn];
    
}

- (void)layoutUI {
    
    __weak typeof(self) weakSelf = self;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(15);
        make.right.equalTo(weakSelf.view.mas_right).offset(-15);
        make.top.equalTo(weakSelf.view.mas_top).offset(24 + kNavigationBarHeight);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-24);
    }];
    
    [self.tipNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(15);
        make.right.equalTo(weakSelf.view.mas_right).offset(-15);
        make.top.equalTo(weakSelf.contentView.mas_top).offset(40);
    }];
    
    [self.tipImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.tipNameL.mas_bottom).offset(50);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(10);
        make.right.equalTo(weakSelf.contentView.mas_right).offset(-10);
        make.height.mas_equalTo(273);
    }];
    
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-44);
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.width.mas_equalTo(260);
        make.height.mas_equalTo(50);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.nextBtn.mas_top).offset(-20);
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(44);
    }];
    
}


#pragma mark - 事件实现
- (void)nextBtnAction:(UIButton *)sender {
    
    __block int enterCount = 0;

    if (self.bluetoothManager.blestate == CNBleStatePoweroff || self.bluetoothManager.blestate == CNBleStateUnknown || self.bluetoothManager.blestate == CNBleStateUnauthorized) {
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"小家音箱需开启蓝牙，请前往系统设置->开启蓝牙" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                                             
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        enterCount = 1;
         
    }else {
        CNVoiceBoxSearchDeviceController *searchDeviceVC = [[CNVoiceBoxSearchDeviceController alloc]init];
        [[AppDelegate sharedAppDelegate] pushViewController:searchDeviceVC];
       
    }
    
    
}

- (void)backBtnAction:(UIButton *)sender {

    [[AppDelegate sharedAppDelegate] popViewController];
}


#pragma mark - 懒加载

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _contentView.layer.shadowColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:0.06].CGColor;
        _contentView.layer.shadowOffset = CGSizeMake(-5,0);
        _contentView.layer.shadowOpacity = 1;
        _contentView.layer.shadowRadius = 10;
        _contentView.layer.cornerRadius = 4;
        
    }
    return _contentView;
}

- (UIImageView *)tipImageV {
    if (!_tipImageV) {
        _tipImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
        _tipImageV.image = [UIImage imageNamed:@"device_nextTip"];
    }
    return _tipImageV;
}

- (UILabel *)tipNameL {
    if (!_tipNameL) {
        _tipNameL = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipNameL.font = [UIFont systemFontOfSize:16];
        _tipNameL.textColor = RGBCOLOR(40, 40, 40);
        _tipNameL.textAlignment = NSTextAlignmentCenter;
        _tipNameL.text = @"手机开启蓝牙\n同时按住音箱的“暂停/播放键”和“禁麦键”\n直到听到“进入配网模式”提示音";
        _tipNameL.numberOfLines = 0;
    }
    return _tipNameL;
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.layer.masksToBounds = YES;
        _nextBtn.layer.cornerRadius = 25;
        [_nextBtn setTitle:@"已听到\"进入配网模式\"" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _nextBtn.backgroundColor = RGBCOLOR(47, 221, 32);
    }
    return _nextBtn;
    
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setTitleColor:RGBCOLOR(153, 153, 153) forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        NSString *sum_str = [NSString stringWithFormat:@"%@",@"上一步"];
        NSMutableAttributedString * att_str = [[NSMutableAttributedString alloc] initWithString:sum_str];
        [att_str addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(47, 221, 32) range:[sum_str rangeOfAll]];
        [att_str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:[sum_str rangeOfAll]];
        [_backBtn setAttributedTitle:att_str forState:UIControlStateNormal];
    }
    return _backBtn;
    
}

@end
