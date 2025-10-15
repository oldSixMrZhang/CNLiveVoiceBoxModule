//
//  CNLiveVoiceBoxFirstTipController.m
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/9/16.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import "CNLiveVoiceBoxFirstTipController.h"
#import "CNLiveVoiceBoxNextTipController.h"

@interface CNLiveVoiceBoxFirstTipController ()
/*** 内容View ***/
@property (strong, nonatomic) UIView *contentView;

/*** tipImageView ***/
@property (strong, nonatomic) UIImageView *tipImageV;

/*** tipName ***/
@property (strong, nonatomic) UILabel *tipNameL;

/*** nextBtn ***/
@property (strong, nonatomic) UIButton *nextBtn;


@end

@implementation CNLiveVoiceBoxFirstTipController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:RGBCOLOR(242, 242, 242)];
    [self setupUI];
    [self layoutUI];
    
}

- (void)setupUI {
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.tipImageV];
    [self.view addSubview:self.tipNameL];
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
        make.top.equalTo(weakSelf.contentView.mas_top).offset(60);
    }];
    
    [self.tipImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.top.equalTo(weakSelf.tipNameL.mas_bottom).offset(70);
        make.width.mas_equalTo(265);
        make.height.mas_equalTo(222);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-44);
        make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        make.width.mas_equalTo(260);
        make.height.mas_equalTo(50);
    }];
    
}


#pragma mark - 事件实现
- (void)nextBtnAction:(UIButton *)sender {
    
    CNLiveVoiceBoxNextTipController *nextTipVC = [[CNLiveVoiceBoxNextTipController alloc]init];
    [[AppDelegate sharedAppDelegate] pushViewController:nextTipVC];
    
    
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
        _tipImageV.image = [UIImage imageNamed:@"device_firstTip"];
    }
    return _tipImageV;
}

- (UILabel *)tipNameL {
    if (!_tipNameL) {
        _tipNameL = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipNameL.font = [UIFont systemFontOfSize:18];
        _tipNameL.textColor = RGBCOLOR(40, 40, 40);
        _tipNameL.textAlignment = NSTextAlignmentCenter;
        _tipNameL.text = @"音箱接通电源，指示灯亮起";
        _tipNameL.numberOfLines = 0;
    }
    return _tipNameL;
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

@end
