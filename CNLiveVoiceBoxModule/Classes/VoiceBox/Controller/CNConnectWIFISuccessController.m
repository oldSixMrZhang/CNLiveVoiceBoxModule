//
//  CNConnectWIFISuccessController.m
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/9/17.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import "CNConnectWIFISuccessController.h"
#import "CNBoxSelectFriendsController.h"
#import "CNLiveAddDeviceController.h"
#import "CNBoxEditDeviceNameController.h"
#import "CNBoxMasterManager.h"
#import "CNLiveBoxSuccessView.h"
#import "CNTabBarViewController.h"
#import "CNClassifySegmentController.h"
#import "CNNavigationController.h"
#import "CNTouristsLoginTipsView.h"
#import "CNBoxUserManagerController.h"
#import "CNLiveVoiceBoxManagerController.h"

@interface CNConnectWIFISuccessController ()
/*** 成功图片 ***/
@property (strong, nonatomic) UIImageView *sucessImageV;
/*** 成功提示 ***/
@property (strong, nonatomic) UILabel *connectL;

/*** 邀请使用者  ***/
@property (strong, nonatomic) UIButton *invitationBtn;
/*** 完成 ***/
@property (strong, nonatomic) UIButton *finishBtn;
/*** 更改名字 ***/
@property (strong, nonatomic) UIButton *changeNameBtn;

/*** 线 ***/
@property (strong, nonatomic) UIView *lineView;
/*** 提示 ***/
@property (strong, nonatomic) UILabel *tipContentL;
/*** 听见中国跳转 ***/
@property (strong, nonatomic) UIButton *jumpBtn;


@property (nonatomic, strong) CNTouristsLoginTipsView *fuzzyView;//游客登录弹框


@end

@implementation CNConnectWIFISuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"连接成功";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setupUI];
    [self layoutUI];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults objectForKey:@"FirstSucess"]) {

    }else {
        [userDefaults setBool:YES forKey:@"FirstSucess"];
        
      CNLiveBoxSuccessView *view = [CNLiveBoxSuccessView showAlertAddedTo:AppKeyWindow];
      [view showAlerView];
       
    }
    
    
}


- (void)setupUI {
    [self.view addSubview:self.sucessImageV];
    [self.view addSubview:self.connectL];
    [self.view addSubview:self.invitationBtn];
    [self.view addSubview:self.finishBtn];
    [self.view addSubview:self.changeNameBtn];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.tipContentL];
    [self.view addSubview:self.jumpBtn];

}

- (void)layoutUI {
    
    __weak typeof(self) weakSelf = self;
    [self.sucessImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(66 + kNavigationBarHeight);
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
    
    [self.invitationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.connectL.mas_bottom).offset(85);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.width.mas_equalTo(215);
        make.height.mas_equalTo(45);
    }];
    
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.invitationBtn.mas_bottom).offset(23);
        make.centerX.equalTo(weakSelf.invitationBtn.mas_centerX);
        make.width.mas_equalTo(215);
        make.height.mas_equalTo(45);
    }];
    
    [self.changeNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.finishBtn.mas_bottom).offset(10);
        make.centerX.equalTo(weakSelf.invitationBtn.mas_centerX);
        make.width.mas_equalTo(215);
        make.height.mas_equalTo(30);
    }];
    
    
    [self.jumpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-46);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(34);
    }];
    
    [self.tipContentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.jumpBtn.mas_top).offset(-5);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.width.mas_equalTo(KScreenWidth);
        make.height.mas_equalTo(12);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.tipContentL.mas_top).offset(-27);
        make.left.equalTo(weakSelf.view.mas_left).offset(15);
        make.right.equalTo(weakSelf.view.mas_right).offset(-15);
        make.height.mas_equalTo(1);
    }];
    
    
}



#pragma mark - 事件实现
- (void)invitationBtnAction:(UIButton *)sender {
   CNBoxUserManagerController *selectVC = [[CNBoxUserManagerController alloc]init];
    
    NSDictionary *dic = [CNBoxMasterManager boxMasterMessage];
    NSString *familyIDStr = [dic objectForKey:kBOX_FamilyIdKey];
    selectVC.familyID = [NSString stringWithFormat:@"%@",familyIDStr ?: @""];
    [[AppDelegate sharedAppDelegate] pushViewController:selectVC];
}

- (void)finishBtnAction:(UIButton *)sender {
    
    UIViewController *target = nil;
    for (UIViewController * controller in self.navigationController.viewControllers) {
        
        if ([controller isKindOfClass:[CNLiveVoiceBoxManagerController class]]) {
            target = controller;
            break;
        }
        
        if ([controller isKindOfClass:[CNLiveAddDeviceController class]]) {
            target = controller;
        }
    }
    if (target) {
        [[AppDelegate sharedAppDelegate] popToViewController:target];
    }else {
        [[AppDelegate sharedAppDelegate] popToRootViewController];
    }
    
}

- (void)changeNameBtnAction:(UIButton *)sender {
    
    CNBoxEditDeviceNameController *editDeviceNameVC = [[CNBoxEditDeviceNameController alloc]init];
    editDeviceNameVC.boxNameStr = [NSString stringWithFormat:@"%@",@""];
    editDeviceNameVC.deviceID = [NSString stringWithFormat:@"%@",self.boxNetResultModel.mainctl?: @""];
    editDeviceNameVC.isMaster = [NSString stringWithFormat:@"%@", @"0"];
    [[AppDelegate sharedAppDelegate] pushViewController:editDeviceNameVC];
           
    
}

- (void)jumpBtnAction:(UIButton *)sender {
    
    NSLog(@"进行跳转");
#pragma mark - TODO:跳转听见中国
    
    [self.navigationController popToRootViewControllerAnimated:NO];
   UIViewController *tabbarController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    if ([tabbarController isKindOfClass:[CNTabBarViewController class]]) {
        CNTabBarViewController *tabbar = (CNTabBarViewController *)tabbarController;
        tabbar.selectedIndex = 1;
        
        //一先处理分类的频道数据->保证本地有频道数据
        CNClassifySegmentController *controller = [self getClassifySegmentController];
        if ([controller isKindOfClass:[CNClassifySegmentController class]]) {
            [controller dataDivideIntoNormalAndOtherWithFirst:YES];
        }
        //二判断我的频道是否存在游客浏览的频道
        NSInteger selectChannelId = [self containsWithChannelId:@"219"];
        if(selectChannelId == -1){
            //1我的频道中没有这个频道
            //弹窗提示用户
            [AppKeyWindow addSubview:self.fuzzyView];
            
        }else{
            //2我的频道中有这个频道
            //2.1选中一级分类
            if ([controller isKindOfClass:[CNClassifySegmentController class]]) {
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0/*延迟执行时间*/ * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [controller categoryView:controller.titleImageCategoryView didSelectedItemAtIndex:selectChannelId];
                });
                
            }
        }
    }
    
}

//游客登录判断是否有这个频道
- (NSInteger)containsWithChannelId:(NSString *)channelId {
    NSString *normalKey = [NSString stringWithFormat:@"%@_%@",NormalChannelArray,CNUserShareModel.uid];
    NSMutableArray *channelArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:normalKey]];
    
    NSInteger i = 0;
    for (NSString *str in channelArray) {
        NSDictionary *dic = CNLiveStringJsonToDictionary(str);
        CNCategoryGetChannelModel *model = [CNCategoryGetChannelModel mj_objectWithKeyValues:dic];
        if ([model.id isEqualToString:channelId]) {
            return i;
        }
        i++;
    }
    return -1;
    
}

- (CNClassifySegmentController *)getClassifySegmentController{
    UIViewController *tabbarController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    if ([tabbarController isKindOfClass:[CNTabBarViewController class]]) {
        CNTabBarViewController *tabbar = (CNTabBarViewController *)tabbarController;
        NSArray *controllers = tabbar.viewControllers;
        if(controllers.count > 0){
            CNNavigationController *nav = controllers[1];
            CNClassifySegmentController *controller = nav.qmui_rootViewController;
            return controller;
        }
        
    }
    return nil;
    
}


#pragma mark - 懒加载

- (CNTouristsLoginTipsView *)fuzzyView{
    if (!_fuzzyView) {
        _fuzzyView = [[CNTouristsLoginTipsView alloc] initWithFrame:AppKeyWindow.bounds];
        _fuzzyView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _fuzzyView.delegate = self;
    }
    return _fuzzyView;
    
}

- (UIImageView *)sucessImageV {
    if (!_sucessImageV) {
        _sucessImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
        _sucessImageV.image = [UIImage imageNamed:@"device_sucess"];
    }
    return _sucessImageV;
}

- (UILabel *)connectL {
    if (!_connectL) {
        _connectL = [[UILabel alloc] initWithFrame:CGRectZero];
        _connectL.font = [UIFont systemFontOfSize:20];
        _connectL.textColor = RGBCOLOR(35, 212, 30);
        _connectL.textAlignment = NSTextAlignmentCenter;
        _connectL.text = @"连接成功";
        _connectL.numberOfLines = 1;
    }
    return _connectL;
}

- (UIButton *)invitationBtn {
    if (!_invitationBtn) {
        _invitationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _invitationBtn.layer.masksToBounds = YES;
        _invitationBtn.layer.cornerRadius = 22.5;
        [_invitationBtn setTitle:@"邀请使用者" forState:UIControlStateNormal];
        [_invitationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _invitationBtn.backgroundColor = RGBCOLOR(35, 212, 30);
        _invitationBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_invitationBtn addTarget:self action:@selector(invitationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _invitationBtn;
}

- (UIButton *)finishBtn{
    if (!_finishBtn) {
        _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _finishBtn.layer.masksToBounds = YES;
        _finishBtn.layer.cornerRadius = 22.5;
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:RGBCOLOR(35, 212, 30) forState:UIControlStateNormal];
        _finishBtn.backgroundColor = [UIColor whiteColor];
        _finishBtn.layer.borderColor = RGBCOLOR(35, 212, 30).CGColor;
        _finishBtn.layer.borderWidth = 1;
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_finishBtn addTarget:self action:@selector(finishBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishBtn;
}

- (UIButton *)changeNameBtn {
    if (!_changeNameBtn) {
        _changeNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeNameBtn.layer.masksToBounds = YES;
        _changeNameBtn.layer.cornerRadius = 22.5;
        [_changeNameBtn setTitle:@"给音箱取个名字吧 >>" forState:UIControlStateNormal];
        [_changeNameBtn setTitleColor:RGBCOLOR(35, 212, 30) forState:UIControlStateNormal];
        _changeNameBtn.backgroundColor = [UIColor whiteColor];
        _changeNameBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_changeNameBtn addTarget:self action:@selector(changeNameBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeNameBtn;
}


- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectZero];
        [_lineView setBackgroundColor:UIColorMake(195, 195, 195)];
    }
    return _lineView;
}

- (UILabel *)tipContentL {
    if (!_tipContentL) {
        _tipContentL = [[UILabel alloc] initWithFrame:CGRectZero];
        _tipContentL.font = [UIFont systemFontOfSize:12];
        _tipContentL.textColor = RGBCOLOR(153, 153, 153);
        _tipContentL.textAlignment = NSTextAlignmentCenter;
        _tipContentL.text = @"也可以去“听见中国”听听有趣的故事";
        _tipContentL.numberOfLines = 1;
    }
    return _tipContentL;
}


- (UIButton *)jumpBtn {
    if (!_jumpBtn) {
        _jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _jumpBtn.layer.masksToBounds = YES;
        _jumpBtn.layer.cornerRadius = 25;
        [_jumpBtn setTitle:@"前往听见中国 >>" forState:UIControlStateNormal];
        [_jumpBtn setTitleColor:RGBCOLOR(47, 221, 32) forState:UIControlStateNormal];
        _jumpBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_jumpBtn addTarget:self action:@selector(jumpBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _jumpBtn;
    
}

@end
