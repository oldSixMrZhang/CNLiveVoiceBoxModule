//
//  CNLiveBoxPlayingView.m
//  CNLiveNetAdd
//
//  Created by cnliveJunBo on 2019/10/19.
//  Copyright © 2019年 cnlive. All rights reserved.
//

#import "CNLiveBoxPlayingView.h"
#import "CNGCDDelay.h"

static CNLiveBoxPlayingView * instance = nil;

@interface CNLiveBoxPlayingView ()

@property (nonatomic, strong) CNGCDDelay       * delay;

@end

@implementation CNLiveBoxPlayingView

+ (CNLiveBoxPlayingView *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithFrame:CGRectMake(10, KScreenHeight, KScreenWidth - 20, 45)];
        instance.delay = [[CNGCDDelay alloc] init];
    });
    return instance;
}

+ (void)showAlertAddedTo:(UIView *)view{
    
    if (![CNLiveBoxPlayingView sharedInstance].superview) {
        [view addSubview:[CNLiveBoxPlayingView sharedInstance]];
        [[CNLiveBoxPlayingView sharedInstance] showAlerView];
    } else {
        
        [[CNLiveBoxPlayingView sharedInstance].delay gcdCancel];
        [[CNLiveBoxPlayingView sharedInstance].delay gcdDelay:3.0 task:^{
            [[CNLiveBoxPlayingView sharedInstance] hiddenAlerView];
        }];
    }
    
}

+ (void)hideAlerView {
    
    [[CNLiveBoxPlayingView sharedInstance] hiddenAlerView];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBACOLOR(51, 51, 51,0.7);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 7.5;
        [self setupUI];
    }
    return self;
}

- (void)showAlerView {
    
    self.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(10, KScreenHeight - kVerticalBottomSafeHeight - 45, KScreenWidth - 20, 45);
    } completion:^(BOOL finished) {
        weakself
        [self.delay gcdDelay:3.0 task:^{
            [weakSelf hiddenAlerView];
        }];
    }];
}

- (void)hiddenAlerView {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        if (self) {
            [self removeFromSuperview];
            self.frame = CGRectMake(10, KScreenHeight, KScreenWidth - 20, 45);
        }
    }];
}

- (void)setupUI {
    
    [self addSubview:self.contentL];
    [self addSubview:self.ignoreBtn];
    
    self.contentL.frame = CGRectMake(10, 14, KScreenWidth-70, 17);
    self.ignoreBtn.frame = CGRectMake(KScreenWidth-51, 10, 25, 25);
}

#pragma mark - 事件实现
- (void)ignoreBtnAction:(UIButton *)btn {
    [self hiddenAlerView];
}

#pragma mark - Getter

- (UILabel *)contentL {
    if (!_contentL) {
        _contentL = [[UILabel alloc]initWithFrame:CGRectZero];
        _contentL.text = @"正使用音箱播放，打开“更多 > 远程控制”关闭";
        _contentL.textColor = [UIColor whiteColor];
        _contentL.font = [UIFont systemFontOfSize:15];
        _contentL.adjustsFontSizeToFitWidth = YES;
    }
    return _contentL;
}

- (UIButton *)ignoreBtn {
    if (!_ignoreBtn) {
        _ignoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ignoreBtn setImage:[UIImage imageNamed:@"远程播放提示关闭"] forState:UIControlStateNormal];
        [_ignoreBtn addTarget:self action:@selector(ignoreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _ignoreBtn.touchAreaInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return _ignoreBtn;
    
}

- (void)dealloc {
    NSLog(@"");
}

@end
