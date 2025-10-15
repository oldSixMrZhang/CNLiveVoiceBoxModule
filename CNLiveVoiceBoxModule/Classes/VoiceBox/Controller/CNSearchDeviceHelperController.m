//
//  CNSearchDeviceHelperController.m
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/9/17.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import "CNSearchDeviceHelperController.h"

@interface CNSearchDeviceHelperController ()

@property (strong, nonatomic) UILabel *tipL;
@property (strong, nonatomic) UILabel *contentL;

@end

@implementation CNSearchDeviceHelperController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"帮助";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.tipL];
    [self.view addSubview:self.contentL];
    
    __weak typeof(self) weakSelf = self;
    [self.tipL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(13);
        make.top.equalTo(weakSelf.view.mas_top).offset(23 + kNavigationBarHeight);
        make.right.equalTo(weakSelf.view.mas_right).offset(-13);
        make.height.mas_equalTo(18);
    }];
    
    [self.contentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(13);
        make.top.equalTo(weakSelf.tipL.mas_bottom).offset(23);
        make.right.equalTo(weakSelf.view.mas_right).offset(-13);
       
    }];
}

- (UILabel *)tipL {
    if (!_tipL) {
        _tipL = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipL.font = [UIFont systemFontOfSize:16];
        _tipL.textColor = RGBCOLOR(40, 40, 40);
        _tipL.textAlignment = NSTextAlignmentLeft;
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"未发现设备？" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:18],NSForegroundColorAttributeName: [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1.0]}];

        _tipL.attributedText = string;
        _tipL.numberOfLines = 1;
    }
    return _tipL;
}

- (UILabel *)contentL {
    if (!_contentL) {
        _contentL = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentL.font = [UIFont systemFontOfSize:15];
        _contentL.textColor = RGBCOLOR(40, 40, 40);
        _contentL.textAlignment = NSTextAlignmentLeft;
        _contentL.text = @"1.请先检查手机系统版本是否满足最低要求（仅 支持Android4.4版本以上，ios8.0 iPhone4S以上 的手机）。\n\n2.请确认手机已经打开蓝牙。\n\n3.请确保设备已进入配网模式（即听到音箱提示： 进入配网模式，请根据手机APP提示进行配网）。\n\n4.请确保音箱设备是否损坏或连接了其他手机。\n\n5.可尝试关闭手机蓝牙，重新打开手机蓝牙后进 入app重试。\n\n6.重启音箱设备后进行配置。";

        _contentL.numberOfLines = 0;
    }
    return _contentL;
}

@end
