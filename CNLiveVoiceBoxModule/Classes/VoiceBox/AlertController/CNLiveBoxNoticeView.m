//
//  CNLiveBoxNoticeView.m
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/10/18.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import "CNLiveBoxNoticeView.h"
#import "CNBoxUserManagerController.h"

@interface CNLiveBoxNoticeView ()

@end


@implementation CNLiveBoxNoticeView

+ (CNLiveBoxNoticeView *)showAlertAddedTo:(UIView *)view dic:(NSDictionary *)dic{
    
    CNLiveBoxNoticeView *noticeView = [[CNLiveBoxNoticeView alloc] initWithFrame:CGRectMake(10, KScreenHeight, KScreenWidth - 20, 45)];
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
    [self addSubview:self.ignoreBtn];
    [self addSubview:self.lineV];
    [self addSubview:self.checkBtn];
}

- (void)layoutUI {
    
    self.checkBtn.frame = CGRectMake(KScreenWidth - 20 - 44, 0, 44, 44);
    
    self.lineV.frame = CGRectMake(self.checkBtn.left - 1, 10, 1, 25);
    self.ignoreBtn.frame = CGRectMake(self.lineV.left - 44, 0, 44, 44);
    self.contentL.frame = CGRectMake(10, 10, self.ignoreBtn.left - 20, 24);
}

#pragma mark - 事件实现
- (void)ignoreBtnAction:(UIButton *)btn {
    [self hiddenAlerView];
}

- (void)checkBtnAction:(UIButton *)btn {
    [self hiddenAlerView];
    NSLog(@"去查看");
    if (!self.dic) {
        [QMUITips showWithText:@"参数不全" inView:AppKeyWindow hideAfterDelay:0.5];
        return;
    }
    
//    if ([self.dic containsObjectForKey:@"familyId"]) {
//        self.contentL.text = [NSString stringWithFormat:@"%@",self.dic[@"familyId"]];
//    }
    
    if (self.clickCheckBtnBlock) {
        self.clickCheckBtnBlock(self, btn);
    }
    
    
}


#pragma mark - 属性

- (UILabel *)contentL {
    if (!_contentL) {
        _contentL = [[UILabel alloc]initWithFrame:CGRectZero];
        _contentL.text = @"您被好友绑定成为了亲情关系";
        _contentL.textColor = [UIColor whiteColor];
        _contentL.font = [UIFont systemFontOfSize:15];
        
    }
    return _contentL;
}

- (UIView *)lineV {
    if (!_lineV) {
        _lineV = [[UIView alloc]initWithFrame:CGRectZero];
        [_lineV setBackgroundColor:[UIColor whiteColor]];
    }
    return _lineV;
    
}

- (UIButton *)ignoreBtn {
    if (!_ignoreBtn) {
        _ignoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ignoreBtn setTitle:@"忽略" forState:UIControlStateNormal];
        _ignoreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_ignoreBtn addTarget:self action:@selector(ignoreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ignoreBtn;
    
}

- (UIButton *)checkBtn {
    if (!_checkBtn) {
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBtn setTitle:@"查看" forState:UIControlStateNormal];
        _checkBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_checkBtn addTarget:self action:@selector(checkBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkBtn;
    
}

@end
