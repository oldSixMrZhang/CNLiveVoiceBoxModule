//
//  CNConnectWifiFailController.m
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/10/8.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import "CNConnectWifiFailController.h"

@interface CNConnectWifiFailController ()

/*** 成功图片 ***/
@property (strong, nonatomic) UIImageView *sucessImageV;
/*** 成功提示 ***/
@property (strong, nonatomic) UILabel *connectL;
/*** 失败内容 ***/
@property (strong, nonatomic) UILabel *showContentsL;

@property (strong, nonatomic) UIButton *jumpBtn;


@end

@implementation CNConnectWifiFailController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupUI];
    [self layoutUI];
    
    self.showContentsL.text = [NSString stringWithFormat:@"%@",self.showContentL.length >0 ? self.showContentL: @"设备配网失败"];
    
    if (self.phoneNumber.length > 0) {
        self.jumpBtn.hidden  = NO;
    }
}


- (void)setupUI {
    [self.view addSubview:self.sucessImageV];
    [self.view addSubview:self.connectL];
    [self.view addSubview:self.showContentsL];
    [self.view addSubview:self.jumpBtn];

}

- (void)layoutUI {
    
    __weak typeof(self) weakSelf = self;
    [self.sucessImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(66+ kNavigationBarHeight);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.width.mas_equalTo(57);
        make.height.mas_equalTo(57);
    }];
    
    [self.connectL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.sucessImageV.mas_bottom).offset(35);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.width.mas_equalTo(KScreenWidth);
        make.height.mas_equalTo(20);
    }];
    
    [self.showContentsL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.connectL.mas_bottom).offset(117);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.width.mas_equalTo(KScreenWidth - 70);
    }];
    
    [self.jumpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.showContentsL.mas_bottom).offset(60);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
    }];
  
    
}



#pragma mark - 事件实现

- (void)jumpBtnAction:(UIButton *)sender {
    
    NSLog(@"进行跳转");
    if (self.phoneNumber.length > 0) {
        NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneNumber];

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
   
    
}

#pragma mark - 懒加载

- (UIImageView *)sucessImageV {
    if (!_sucessImageV) {
        _sucessImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
        _sucessImageV.image = [UIImage imageNamed:@"device_failImage"];
    }
    return _sucessImageV;
}

- (UILabel *)connectL {
    if (!_connectL) {
        _connectL = [[UILabel alloc] initWithFrame:CGRectZero];
        _connectL.font = [UIFont systemFontOfSize:20];
        _connectL.textColor = RGBCOLOR(214, 2, 2);
        _connectL.textAlignment = NSTextAlignmentCenter;
        _connectL.text = @"配置失败";
        _connectL.numberOfLines = 1;
    }
    return _connectL;
}

- (UILabel *)showContentsL {
    if (!_showContentsL) {
        _showContentsL = [[UILabel alloc] initWithFrame:CGRectZero];
        _showContentsL.font = [UIFont systemFontOfSize:15];
        _showContentsL.textColor = RGBCOLOR(153, 153, 153);
        _showContentsL.textAlignment = NSTextAlignmentCenter;
        _showContentsL.numberOfLines = 0;
       }
    return _showContentsL;
    
}

- (UIButton *)jumpBtn {
    if (!_jumpBtn) {
        _jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _jumpBtn.layer.masksToBounds = YES;
        _jumpBtn.layer.cornerRadius = 15;
        [_jumpBtn setTitle:@"联系" forState:UIControlStateNormal];
        [_jumpBtn setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
        [_jumpBtn addTarget:self action:@selector(jumpBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _jumpBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _jumpBtn.backgroundColor = RGBCOLOR(35, 212, 30);
        _jumpBtn.hidden = YES;
    }
    return _jumpBtn;
}


@end
