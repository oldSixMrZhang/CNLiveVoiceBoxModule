//
//  CNBOXFirmwareUpdateController.m
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/10/10.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import "CNBOXFirmwareUpdateController.h"

@interface CNBOXFirmwareUpdateController ()

/*** 音箱图片 ***/
@property (strong, nonatomic) UIImageView *deviceImageV;

/*** 当前版本 ***/
@property (strong, nonatomic) UILabel *currentL;

/*** 最新版本 ***/
@property (strong, nonatomic) UILabel *updateL;

/*** 保存按钮 ***/
@property (strong, nonatomic) UIButton *checkBtn;

@end

@implementation CNBOXFirmwareUpdateController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"固件升级";
    
    [self setupUI];
    [self layoutUI];
}

- (void)setupUI {
    
    [self.view addSubview:self.deviceImageV];
    [self.view addSubview:self.currentL];
    [self.view addSubview:self.updateL];
    [self.view addSubview:self.checkBtn];
     
    self.currentL.text = [NSString stringWithFormat:@"%@%@",@"当前版本v:",self.versionStr];
    self.updateL.text = [NSString stringWithFormat:@"%@%@",@"最新版本v:",self.versionStr];
    
    
}

- (void)layoutUI {
    __weak typeof(self) weakSelf = self;
    [self.deviceImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(62);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.width.mas_equalTo(274);
        make.height.mas_equalTo(159);
    }];
       
    [self.currentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.deviceImageV.mas_bottom).offset(40);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.width.mas_equalTo(KScreenWidth);
        make.height.mas_equalTo(20);
    }];
       
    [self.updateL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.currentL.mas_bottom).offset(22);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.width.mas_equalTo(KScreenWidth);
        make.height.mas_equalTo(20);
    }];
    
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-78);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.width.mas_equalTo(215);
        make.height.mas_equalTo(45);
    }];
       
    
}


#pragma mark - 事件实现
- (void)checkBtnAction:(UIButton *)sender {
    
    [QMUITips showWithText:@"已经是最新版本了" inView:self.view hideAfterDelay:0.5];
}


#pragma mark - 属性

- (UIImageView *)deviceImageV {
    if (!_deviceImageV) {
        _deviceImageV = [[UIImageView alloc]initWithFrame:CGRectZero];
        _deviceImageV.image = [UIImage imageNamed:@"device_ImageV"];
    }
    return _deviceImageV;
}

- (UILabel *)currentL {
    if (!_currentL) {
        _currentL = [[UILabel alloc]initWithFrame:CGRectZero];
        _currentL.font = [UIFont systemFontOfSize:15];
        _currentL.textAlignment = NSTextAlignmentCenter;
        
    }
    return _currentL;
}

- (UIView *)updateL {
    if (!_updateL) {
        _updateL = [[UILabel alloc] initWithFrame:CGRectZero];
        _updateL.textAlignment = NSTextAlignmentCenter;
        _updateL.font = [UIFont systemFontOfSize:15];
    }
    return _updateL;
}

- (UIButton *)checkBtn {
    if (!_checkBtn) {
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkBtn.layer.masksToBounds = YES;
        _checkBtn.layer.cornerRadius = 22.5;
        [_checkBtn setTitle:@"检查更新" forState:UIControlStateNormal];
        _checkBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_checkBtn addTarget:self action:@selector(checkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_checkBtn setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
        _checkBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _checkBtn.backgroundColor = RGBCOLOR(35, 212, 30);

    }
    return _checkBtn;
    
}



@end
