//
//  CNBoxEditDeviceController.m
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/10/9.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import "CNBoxEditDeviceNameController.h"
#import "CNLiveVoiceBoxModelHelper.h"

@interface CNBoxEditDeviceNameController ()

/*** 音箱名称 ***/
@property (strong, nonatomic) UILabel *deviceNameTipL;

/*** 音箱名称输入 ***/
@property (strong, nonatomic) UITextField *deviceTF;

/*** 线 ***/
@property (strong, nonatomic) UIView *lineV;

/*** 提示 ***/
@property (strong, nonatomic) UILabel *tipL;

/*** 保存按钮 ***/
@property (strong, nonatomic) UIButton *saveBtn;



@end

@implementation CNBoxEditDeviceNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"更改音箱名称";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupUI];
    [self layoutUI];
    
    self.deviceTF.text = self.boxNameStr;
    
}


- (void)setupUI {
    [self.view addSubview:self.deviceNameTipL];
    [self.view addSubview:self.deviceTF];
    [self.view addSubview:self.lineV];
    [self.view addSubview:self.tipL];
    [self.view addSubview:self.saveBtn];

}

- (void)layoutUI {
        
    __weak typeof(self) weakSelf = self;
    [self.deviceNameTipL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(39+kNavigationBarHeight);
        make.left.equalTo(weakSelf.view.mas_left).offset(22);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(14);
    }];
        
    [self.deviceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.deviceNameTipL.mas_centerY);
        make.left.equalTo(weakSelf.deviceNameTipL.mas_right);
        make.right.equalTo(weakSelf.view.mas_right).offset(-10);
        make.height.mas_equalTo(30);
    }];
        
    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.deviceNameTipL.mas_bottom).offset(15);
        make.left.equalTo(weakSelf.view.mas_left).offset(22);
        make.right.equalTo(weakSelf.view.mas_right).offset(-22);
        make.height.mas_equalTo(0.5);
    }];

    [self.tipL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.lineV.mas_bottom).offset(12);
        make.left.equalTo(weakSelf.view.mas_left).offset(22);
        make.right.equalTo(weakSelf.view.mas_right).offset(-22);
        make.height.mas_equalTo(20);
    }];

    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.tipL.mas_bottom).offset(34);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.width.mas_equalTo(280);
        make.height.mas_equalTo(50);
    }];
        
        
}

#pragma mark - 按钮实现
- (void)saveBtnAction:(id)sender {
    
    NSLog(@"按钮点击了");
    
    [self changeName];
    
}

//监听改变方法
- (void)textFieldTextDidChange:(UITextField *)textChange{
    NSLog(@"文字改变：%@",textChange.text);
    
    if (textChange.text.length > 40) {
        NSString *textStr = [textChange.text substringToIndex:40];
        textChange.text = textStr;
    }
    
    if (textChange.text.length > 2) {
        self.saveBtn.enabled = YES;
        self.saveBtn.backgroundColor = RGBCOLOR(47, 221, 32);
    }else {
        self.saveBtn.enabled = NO;
        self.saveBtn.backgroundColor = RGBCOLOR(200, 200, 200);
    }
    
}

#pragma mark - 接口
- (void)changeName {
//    http://apiwjjtest.cnlive.com/Daren/sound/updateDeviceName.action
    
    NSString *deviceID = [NSString stringWithFormat:@"%@",self.deviceID];
    NSString *newName =  [NSString stringWithFormat:@"%@",self.deviceTF.text];
    newName = [newName stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (newName.length <= 0 ) {
        [QMUITips showWithText:@"请输入设备名" inView:self.view hideAfterDelay:1.5];
        return;
    }
    NSString *oldName = [NSString stringWithFormat:@"%@",self.boxNameStr?:@""];
    
    [QMUITips showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    [CNLiveVoiceBoxModelHelper updateDeviceNameWithDeviceId:deviceID newName:newName oldName:oldName completerBlick:^(id  _Nonnull data, NSError * _Nonnull error) {
        [QMUITips hideAllTipsInView:weakSelf.view];
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        if (error) {
            
            NSString *showText = @"更改设备名失败,请重试";
            if (error.code == 4311 || error.code == 403 || error.code == 4318) {//没有网络
                showText = [NSString stringWithFormat:@"%@",error.domain];
            }else {
                showText = @"请求失败,请重试";
            }
                      
            [QMUITips showWithText:showText inView:weakSelf.view hideAfterDelay:0.5];
            
        }else {
            
            [[AppDelegate sharedAppDelegate] popViewController];
        }
        
        
    }];
}



#pragma mark - 属性

- (UILabel *)deviceNameTipL {
    if (!_deviceNameTipL) {
        _deviceNameTipL = [[UILabel alloc]initWithFrame:CGRectZero];
        _deviceNameTipL.text = @"音箱名称";
        _deviceNameTipL.font = [UIFont systemFontOfSize:15];
        _deviceNameTipL.textColor = [UIColor blackColor];
    }
    return _deviceNameTipL;
}

- (UITextField *)deviceTF {
    if (!_deviceTF) {
        _deviceTF = [[UITextField alloc]initWithFrame:CGRectZero];
        _deviceTF.font = [UIFont systemFontOfSize:15];
        _deviceTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        //添加监听
        [_deviceTF addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _deviceTF;
}

- (UIView *)lineV {
    if (!_lineV) {
        _lineV = [[UIView alloc] initWithFrame:CGRectZero];
        [_lineV setBackgroundColor:RGBCOLOR(242, 242, 242)];
    }
    return _lineV;
}

- (UILabel *)tipL {
    if (!_tipL) {
        _tipL = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipL.textColor = RGBCOLOR(153, 153, 153);
        _tipL.text = @"40个字符以内，支持汉字、字母、数字或下划线";
        _tipL.font = [UIFont systemFontOfSize:12];
        
    }
    return _tipL;
}

- (UIButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.layer.masksToBounds = YES;
        _saveBtn.layer.cornerRadius = 25;
        _saveBtn.enabled = NO;
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_saveBtn addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_saveBtn setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _saveBtn.backgroundColor = RGBCOLOR(200, 200, 200);

    }
    return _saveBtn;
    
}



@end
