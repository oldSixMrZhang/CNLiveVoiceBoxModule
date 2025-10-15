//
//  CNLiveBoxTipAlertView.m
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/9/19.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import "CNLiveBoxWIFITipAlertView.h"

#define kWIFITipViewW 270
#define kWIFITipViewH 151

@implementation CNLiveBoxWIFITipAlertView
//提示
+ (CNLiveBoxWIFITipAlertView *)showAlertAddedTo:(UIView *)view{
    
    CNLiveBoxWIFITipAlertView *alertView = [[CNLiveBoxWIFITipAlertView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    alertView.alpha = 0.5;
    [view addSubview:alertView];
    
    return alertView;
}

- (void)showAlerView {
    
    self.alpha = 0.5;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
    
    
}

- (void)hiddenAlerView {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.3;
        [self removeFromSuperview];
    }];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBACOLOR(51, 51, 51, 0.3);
        [self setupUI];
        [self layoutUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.enterTF];
    [self.bgView addSubview:self.showPWBtn];
    [self.bgView addSubview:self.bottomLineV];
    [self.bgView addSubview:self.contenL];
    [self.bgView addSubview:self.cancleBtn];
    [self.bgView addSubview:self.sureBtn];
    [self.bgView addSubview:self.horizontalLine];
    [self.bgView addSubview:self.verticalLine];
    
}

- (void)layoutUI {
    
    self.bgView.frame = CGRectMake((KScreenWidth - kWIFITipViewW)/2, (KScreenHeight - kWIFITipViewH)/2, kWIFITipViewW, kWIFITipViewH);
    self.contenL.frame = CGRectMake(10, 21, kWIFITipViewW - 20, 17);
    self.showPWBtn.frame = CGRectMake(kWIFITipViewW - 50 , self.contenL.bottom + 15, 40, 38);
    self.enterTF.frame = CGRectMake(20, self.showPWBtn.centerY - 19, kWIFITipViewW - 80, 38);
    self.bottomLineV.frame = CGRectMake(20, self.showPWBtn.bottom + 1, kWIFITipViewW - 40, 0.5);

    self.horizontalLine.frame = CGRectMake(0, kWIFITipViewH - 44, kWIFITipViewW, 0.5);
    self.verticalLine.frame = CGRectMake(kWIFITipViewW/2, kWIFITipViewH - 44, 0.5, 44);
    self.cancleBtn.frame = CGRectMake(0, kWIFITipViewH - 43, kWIFITipViewW/2, 43);
    self.sureBtn.frame = CGRectMake(kWIFITipViewW/2, kWIFITipViewH - 43,  kWIFITipViewW/2, 43);
    
    [self.bgView setBackgroundColor:[UIColor whiteColor]];
    
}

#pragma mark - 实现
- (void)showPWBtnAction:(UIButton *)sender {
    
}

- (void)sureBtnAction:(UIButton *)sender {
    
}

- (void)cancleBtnAction:(UIButton *)sender {
    
}


#pragma mark - 属性

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectZero];
        [_bgView setBackgroundColor:[UIColor whiteColor]];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 15;
    }
    return _bgView;
}

- (UITextField *)enterTF {
    if (!_enterTF) {
        _enterTF = [[UITextField alloc]initWithFrame:CGRectZero];
       
    }
    return _enterTF;
}

- (UIButton *)showPWBtn {
    if (!_showPWBtn) {
        _showPWBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showPWBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_showPWBtn setTitleColor:RGBCOLOR(153, 153, 153) forState:UIControlStateNormal];
        _showPWBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _showPWBtn.backgroundColor = [UIColor clearColor];
        [_showPWBtn addTarget:self action:@selector(showPWBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
    
}

- (UIView *)bottomLineV {
    if (!_bottomLineV) {
        _bottomLineV = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _bottomLineV;
}

- (UILabel *)contenL {
    if (!_contenL) {
        _contenL = [[UILabel alloc]initWithFrame:CGRectZero];
        _contenL.textColor = [UIColor blackColor];
        _contenL.font = [UIFont systemFontOfSize:17];
    }
    return _contenL;
}


- (UIView *)horizontalLine {
    
    if (!_horizontalLine) {
        _horizontalLine = [[UIView alloc]initWithFrame:CGRectZero];
        [_horizontalLine setBackgroundColor:RGBCOLOR(199, 199, 199)];
    }
    return _horizontalLine;
}

- (UIView *)verticalLine {
    
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc]initWithFrame:CGRectZero];
        [_verticalLine setBackgroundColor:RGBCOLOR(199, 199, 199)];
    }
    return _verticalLine;
    
}

- (UIButton *)cancleBtn {
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleBtn setTitleColor:RGBCOLOR(153, 153, 153) forState:UIControlStateNormal];
        _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _cancleBtn.backgroundColor = [UIColor clearColor];
        [_cancleBtn addTarget:self action:@selector(cancleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
    
}


- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:RGBCOLOR(11, 190, 6) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _sureBtn.backgroundColor = [UIColor clearColor];
        [_sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //获取手指触摸view是的任意一个触摸对象
    UITouch * touch = [touches anyObject];
    //获取是手指触摸的view
    UIView *view = [touch view];
    if ([view isEqual:self]) {
        [self hiddenAlerView];
    }
    
}



@end
