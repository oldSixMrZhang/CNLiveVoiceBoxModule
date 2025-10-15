//
//  CNLiveBoxSuccessView.m
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/10/18.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import "CNLiveBoxSuccessView.h"

#define kTipViewW 357
#define kTipViewH 400

@implementation CNLiveBoxSuccessView

//提示
+ (CNLiveBoxSuccessView *)showAlertAddedTo:(UIView *)view{
    
    CNLiveBoxSuccessView *alertView = [[CNLiveBoxSuccessView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
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
        self.backgroundColor = RGBACOLOR(51, 51, 51,0.7);
        [self setupUI];
        [self layoutUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.successImgV];
    [self.contentView addSubview:self.cancleBtn];
    
}

- (void)layoutUI {
    
    self.contentView.frame = CGRectMake((KScreenWidth - kTipViewW)/2, (KScreenHeight - kTipViewH)/2, kTipViewW, kTipViewH);
    self.successImgV.frame = CGRectMake(0, 0, kTipViewW, 326);
    self.cancleBtn.frame = CGRectMake((kTipViewW - 44)/2, self.successImgV.bottom + 10, 44, 44);
    
}

#pragma mark - 实现

- (void)cancleBtnAction:(UIButton *)sender {
    [self hiddenAlerView];
}


#pragma mark - 属性

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _contentView;
}


- (UIView *)successImgV {
    if (!_successImgV) {
        _successImgV = [[UIImageView alloc]initWithFrame:CGRectZero];
        _successImgV.image = [UIImage imageNamed:@"device_gift"];
    }
    return _successImgV;
}

- (UIButton *)cancleBtn {
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleBtn setImage:[UIImage imageNamed:@"device_cancle"] forState:UIControlStateNormal];
        [_cancleBtn addTarget:self action:@selector(cancleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
    
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
