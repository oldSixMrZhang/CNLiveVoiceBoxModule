//
//  CNLiveVoiceBoxSetController.m
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/9/16.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import "CNLiveVoiceBoxSetController.h"
#import "CNLiveBoxSetCell.h"
#import "CNLiveVoiceBoxManagerController.h"
#import "CNLiveBoxInstructionsController.h"
#import "CNBoxUserManagerController.h"
#import "CNLiveVoiceBoxModelHelper.h"

#define kTableViewHeaderView @"TableViewHeaderView"


@interface CNLiveVoiceBoxSetController ()<UITableViewDelegate,UITableViewDataSource>

/*** 列表 ***/
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UISwitch *switchBtn;


@end

@implementation CNLiveVoiceBoxSetController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:RGBCOLOR(242, 242, 242)];
    
    self.title = @"小家智能音箱";
    
    [self setupUI];
    [self layoutUI];
    
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 100);
    }else {
        self.tableView.frame = CGRectMake(0, kNavigationBarHeight, KScreenWidth, KScreenHeight - 100);
    }
    
    
    
    
}

- (void)layoutUI {
    
    
    
}


#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CNLiveBoxSetCell *cell = [tableView dequeueReusableCellWithIdentifier:kCNLiveBoxSetCell forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell editUIWithTop:@"1"];
        cell.tipImageV.image = [UIImage imageNamed:@"device_people"];
        cell.tipL.text = @"使用者管理";
        cell.msgL.hidden = YES;
    }else if (indexPath.row == 1){
        [cell editUIWithTop:@"2"];
        cell.tipImageV.image = [UIImage imageNamed:@"device_manager"];
        cell.tipL.text = @"设备管理";
        cell.msgL.hidden = YES;
    }else {
        [cell editUIWithTop:@"0"];
        cell.tipImageV.image = [UIImage imageNamed:@"device_instructions"];
        cell.tipL.text = @"设备说明";
        cell.msgL.hidden = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 61;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {//设置用户
        CNBoxUserManagerController *userManagerVC = [[CNBoxUserManagerController alloc]init];
        userManagerVC.familyID = [NSString stringWithFormat:@"%@",self.familyId];
        [[AppDelegate sharedAppDelegate] pushViewController:userManagerVC];
        
    }else if (indexPath.row == 1) {//设置音箱
        CNLiveVoiceBoxManagerController *boxManagerVC = [[CNLiveVoiceBoxManagerController alloc]init];
        //这里的isMaster 0 为主人
        boxManagerVC.isMaster = [NSString stringWithFormat:@"%@",self.isMaster];
        boxManagerVC.deviceModel = self.deviceModel;
        boxManagerVC.boxModel = self.boxModel;
        [[AppDelegate sharedAppDelegate] pushViewController:boxManagerVC];
        
        
    }else {//说明
        CNLiveBoxInstructionsController *boxInstructionsVC = [[CNLiveBoxInstructionsController alloc]init];
        [[AppDelegate sharedAppDelegate] pushViewController:boxInstructionsVC];
    }
}


#pragma mark - 属性
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[CNLiveBoxSetCell class] forCellReuseIdentifier:kCNLiveBoxSetCell];
        [_tableView setBackgroundColor:RGBACOLOR(242, 242, 242, 1)];
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView = footerView;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


@end
