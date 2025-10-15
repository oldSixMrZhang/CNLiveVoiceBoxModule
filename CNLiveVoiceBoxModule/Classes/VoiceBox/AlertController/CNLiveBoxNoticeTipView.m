//
//  CNLiveBoxNoticeTipView.m
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/10/22.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import "CNLiveBoxNoticeTipView.h"

@implementation CNLiveBoxNoticeTipView

+ (CNLiveBoxNoticeTipView *)showAlertAddedTo:(UIView *)view dic:(NSDictionary *)dic{
    
    CNLiveBoxNoticeTipView *noticeView = [[CNLiveBoxNoticeTipView alloc] initWithFrame:CGRectMake(10, KScreenHeight, KScreenWidth - 20, 45)];
    [view addSubview:noticeView];
    noticeView.dic = dic;
    if ([noticeView.dic containsObjectForKey:@"text"]) {
        noticeView.contentL.text = [NSString stringWithFormat:@"%@",noticeView.dic[@"text"]];
    }
 
    return noticeView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBACOLOR(51, 51, 51,0.7);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 7.5;
        [self setupUI];
        [self layoutUI];
        [self showAlerView];
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf hiddenAlerView];
        });
    }
    return self;
}

- (void)showAlerView {
    

    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(10, KScreenHeight - 55, KScreenWidth - 20, 45);
    }];
    
    
}

- (void)hiddenAlerView {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.3;
        if (self) {
            [self removeFromSuperview];
        }
        
    }];
}

- (void)setupUI {
    [self addSubview:self.contentL];
    [self addSubview:self.cancelBtn];
}

- (void)layoutUI {
    
    self.cancelBtn.frame = CGRectMake(KScreenWidth - 20 - 44, 0, 44, 44);

    self.contentL.frame = CGRectMake(10, 10, self.cancelBtn.left - 20, 24);
}

#pragma mark - 事件实现

- (void)checkBtnAction:(UIButton *)btn {
    [self hiddenAlerView];
    
    
}


#pragma mark - 属性

- (UILabel *)contentL {
    if (!_contentL) {
        _contentL = [[UILabel alloc]initWithFrame:CGRectZero];
        _contentL.text = @"您被好友解除绑定亲情关系";
        _contentL.textColor = [UIColor whiteColor];
        _contentL.font = [UIFont systemFontOfSize:15];
        
    }
    return _contentL;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setImage:[UIImage imageNamed:@"device_header_cancle"] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelBtn addTarget:self action:@selector(checkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
    
}


@end
