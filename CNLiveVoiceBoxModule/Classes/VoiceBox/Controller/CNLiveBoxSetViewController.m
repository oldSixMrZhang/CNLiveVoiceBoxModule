//
//  CNLiveBoxSetViewController.m
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/10/14.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import "CNLiveBoxSetViewController.h"
#import "CNLiveVoiceBoxModelHelper.h"
#import "CNLiveBoxOpenCell.h"


@interface CNLiveBoxSetViewController ()<UITableViewDelegate,UITableViewDataSource>

/*** 列表 ***/
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UISwitch *switchBtn;


@end

@implementation CNLiveBoxSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:RGBCOLOR(242, 242, 242)];
    
    self.title = @"远程控制管理";
    
    [self setupUI];
    [self layoutUI];

    [self getBackOnlineType];
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight- kNavigationBarHeight - 100);
    }else {
        self.tableView.frame = CGRectMake(0, kNavigationBarHeight, KScreenWidth, KScreenHeight- kNavigationBarHeight - 100);
    }
    
    
    
}

- (void)layoutUI {
    
    
    
}


#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CNLiveBoxOpenCell *cell = [tableView dequeueReusableCellWithIdentifier:kCNLiveBoxOpenCell forIndexPath:indexPath];
    self.switchBtn = cell.boxOpenSwitch;
    __weak typeof(self) weakSelf = self;
    cell.clickSwitchBtnBlock = ^(CNLiveBoxOpenCell * _Nonnull cell, UISwitch * _Nonnull boxOpenSwitch) {
        NSString *isOpen = @"1";
        if (boxOpenSwitch.isOn) {
            isOpen = @"0";
        }
        [weakSelf remoteControlDevStatus:isOpen];

    };
           
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 92;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - 接口
- (void)remoteControlDevStatus:(NSString *)devStatus {
    NSString *devStatusStr = [NSString stringWithFormat:@"%@",devStatus];
    [QMUITips showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    [CNLiveVoiceBoxModelHelper remoteControlDeviceWithType:devStatusStr completerBlick:^(id  _Nonnull data, NSError * _Nonnull error) {

        [QMUITips hideAllTipsInView:weakSelf.view];
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        if (error) {
            [QMUITips showWithText:@"设置失败" inView:weakSelf.view hideAfterDelay:0.5];
            if ([devStatus isEqualToString:@"0"]) {
                [weakSelf.switchBtn setOn:NO];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:CNWjjRemoteControlStatusKey];
            }else {
                [weakSelf.switchBtn setOn:YES];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CNWjjRemoteControlStatusKey];
            }
            
        }else {
            
            if ([devStatus isEqualToString:@"0"]) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CNWjjRemoteControlStatusKey];
            }else {
                 [[NSUserDefaults standardUserDefaults] setBool:NO forKey:CNWjjRemoteControlStatusKey];
            }
           
        }
        
        
    }];
    
}

- (void)getBackOnlineType {
    
    [QMUITips showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    [CNLiveVoiceBoxModelHelper getBackOnlineTypeCompleterBlick:^(id  _Nonnull data, NSError * _Nonnull error) {
     
        [QMUITips hideAllTipsInView:weakSelf.view];

        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }

        if (error) {
            NSString *showText = @"网络连接失败，请稍后再试";
            if (error.code == -1001 || error.code == -1009) {//没有网络
               
            }else {
                showText = @"请求失败,请重试";
                }
                       
            [weakSelf showEmptyViewWithImage:[UIImage imageNamed:@"wufalianjie"] text:showText detailText:@"别紧张，试试看刷新页面~" buttonTitle:@"     重试     " buttonAction:@selector(getBackOnlineType)];
                                                       [weakSelf setCNAPIErrorEmptyView];
            weakSelf.emptyView.frame = CGRectMake(0, kNavigationBarHeight, KScreenWidth, KScreenHeight - kNavigationBarHeight);
            weakSelf.emptyView.backgroundColor = [UIColor whiteColor];
            
            

        }else {
            
            /** 有网络 */
            if (weakSelf.emptyView) {
                [weakSelf hideEmptyView];
            }
            
            
            NSDictionary *dic = data;
            NSString *remoteControlStatus = [NSString stringWithFormat:@"%@",dic[@"remoteControlStatus"]];
            if ([remoteControlStatus isEqualToString:@"0"]) {
                [weakSelf.switchBtn setOn:NO];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:CNWjjRemoteControlStatusKey];
            }else {
                [weakSelf.switchBtn setOn:YES];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:CNWjjRemoteControlStatusKey];
            }
        }

    }];
}


#pragma mark - 属性
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        [_tableView registerClass:[CNLiveBoxOpenCell class] forCellReuseIdentifier:kCNLiveBoxOpenCell];
        [_tableView setBackgroundColor:RGBACOLOR(242, 242, 242, 1)];

        UILabel *footerL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
        footerL.text = @"若您添加了多台设备,此开关会控制您所有设备的远程播放功能";
        footerL.font = [UIFont systemFontOfSize:12];
        footerL.textAlignment = NSTextAlignmentCenter;
        _tableView.tableFooterView = footerL;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


@end
