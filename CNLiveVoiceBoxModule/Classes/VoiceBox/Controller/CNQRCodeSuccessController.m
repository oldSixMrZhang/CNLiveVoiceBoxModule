//
//  CNQRCodeSuccessController.m
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/10/16.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import "CNQRCodeSuccessController.h"
#import "CNLiveVoiceBoxModelHelper.h"

@interface CNQRCodeSuccessController ()

@property (strong, nonatomic) UIImageView *showImageV;

@property (strong, nonatomic) UILabel *showL;

@property (strong, nonatomic) UILabel *showContentL;

@property (strong, nonatomic) UIButton *finishBtn;

@end

@implementation CNQRCodeSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setupUI];
    [self layoutUI];
    
    [self familyGroupInviteWithFamilyId:self.familyId roleId:self.roleId uuId:self.uuId];
    
}

- (void)setupUI {
    [self.view addSubview:self.showImageV];
    [self.view addSubview:self.showL];
    [self.view addSubview:self.showContentL];
    [self.view addSubview:self.finishBtn];
    
}

- (void)layoutUI {
    
    __weak typeof(self) weakSelf = self;
    [self.showImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(kNavigationBarHeight + 67);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.width.mas_equalTo(57);
        make.height.mas_equalTo(57);
    }];
    
    [self.showL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.top.equalTo(weakSelf.showImageV.mas_bottom).offset(35);
        make.height.mas_equalTo(20);
    }];
    
    [self.showContentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.top.equalTo(weakSelf.showL.mas_bottom).offset(102);
        make.height.mas_equalTo(15);
    }];
    
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.showContentL.mas_bottom).offset(34);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(30);
    }];
    
}

#pragma mark - 实现
- (void)finishBtnAction:(UIButton *)sender {
     [[AppDelegate sharedAppDelegate] popToRootViewController];
}

#pragma mark - 接口
- (void)familyGroupInviteWithFamilyId:(NSString *)familyId roleId:(NSString *)roleId uuId:(NSString *)uuId {
    
    NSString *familyIdStr = [NSString stringWithFormat:@"%@",familyId];
    NSString *roleIdStr = [NSString stringWithFormat:@"%@",roleId];
    NSString *uuIdStr = [NSString stringWithFormat:@"%@",uuId];
    
    __weak typeof(self) weakSelf = self;
    [QMUITips showLoadingInView:self.view];
    [CNLiveVoiceBoxModelHelper QRCodeFamilyGroupInviteWithFamilyId:familyIdStr roleId:roleIdStr uuid:uuIdStr completerBlick:^(id  _Nonnull data, NSError * _Nonnull error) {
        [QMUITips hideAllTipsInView:weakSelf.view];
        if (error) {
            if (error.code == 4309 || error.code == 4310 || error.code == 4304 || error.code == 4313 || error.code == 4305) {
                
                NSString *msgStr = [NSString stringWithFormat:@"%@",error.domain];
                [weakSelf editUI:CNQRCodeStatusFail showText:msgStr];
                
            }else {
                [weakSelf editUI:CNQRCodeStatusFail showText:@"联系人邀请失败"];
            }
            
        }else {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CNWjjIsYiDongBoxUserKey];
            NSString *showStr = [NSString stringWithFormat:@"%@",data[@"errorMessage"]];
            
            [weakSelf editUI:CNQRCodeStatusSuccess showText:showStr];
        }
        
    }];
    
}


#pragma mark - 私有方法
- (void)editUI:(CNQRCodeStatus)status showText:(NSString *)showText {
    
    if (status == CNQRCodeStatusSuccess) {
        self.showImageV.image = [UIImage imageNamed:@"device_sucess"];
        self.showL.text = @"绑定成功";
        self.showL.textColor = RGBCOLOR(35, 212, 30);
        self.showContentL.text = showText;
        self.finishBtn.hidden = NO;
        
    }else {
        self.showImageV.image = [UIImage imageNamed:@"device_failImage"];
        self.showL.text = @"绑定失败";
        self.showL.textColor = [UIColor redColor];
        self.showContentL.text = showText;
        self.finishBtn.hidden = YES;
    }
    
    
}

#pragma mark - 属性
- (UIImageView *)showImageV {
    if (!_showImageV) {
        _showImageV = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    return _showImageV;
}


- (UILabel *)showL {
    if (!_showL) {
        _showL = [[UILabel alloc]initWithFrame:CGRectZero];
        _showL.font = [UIFont systemFontOfSize:20];
        _showL.textColor = RGBCOLOR(35, 212, 30);
        _showL.textAlignment = NSTextAlignmentCenter;
    }
    return _showL;
}

- (UILabel *)showContentL {
    if (!_showContentL) {
        _showContentL = [[UILabel alloc]initWithFrame:CGRectZero];
        _showContentL.font = [UIFont systemFontOfSize:15];
        _showContentL.textColor = RGBCOLOR(153, 153, 153);
        _showContentL.textAlignment = NSTextAlignmentCenter;
    }
    return _showContentL;
}

- (UIButton *)finishBtn {
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _finishBtn.layer.masksToBounds = YES;
        _finishBtn.layer.cornerRadius = 15;
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_finishBtn addTarget:self action:@selector(finishBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _finishBtn.backgroundColor = RGBCOLOR(35, 212, 30);
    }
    return _finishBtn;
    
}



@end
