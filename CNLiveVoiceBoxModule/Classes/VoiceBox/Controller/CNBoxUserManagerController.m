//
//  CNBoxUserManagerController.m
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/10/9.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import "CNBoxUserManagerController.h"
#import "FTPopOverMenu.h"
#import "CNBoxSelectFriendsController.h"
#import "CNBoxEditQRCodeController.h"
#import "CNBoxUserMannagerCell.h"
#import "CNLiveVoiceBoxModelHelper.h"
#import "CNBoxUserAllModel.h"
#import "CNLiveBoxRoleAlertView.h"
#import "CNLiveBoxRoleModel.h"
#import "CNBoxMasterManager.h"

@interface CNBoxUserManagerController ()<UITableViewDelegate,UITableViewDataSource>

/*** 头部headerView ***/
@property (strong, nonatomic) UIView *tableViewHeaderV;

/*** 底部footerView ***/
@property (strong, nonatomic) UIView *tableViewFooterV;
/*** 邀请网家家好友按钮 ***/
@property (strong, nonatomic) UIButton *inviteBtn;
/*** 生成二维码邀请 ***/
@property (strong, nonatomic) UIButton *inviteCodeBtn;

@property (nonatomic, strong) NSArray<FTPopOverMenuModel *> *menuObjectArray;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *managerArray;


/*** 角色数组 ***/
@property (nonatomic, strong) NSMutableArray *rolesArray;

/*** 列表 ***/
@property (strong, nonatomic) UITableView *tableView;


/*** 是否是主 ***/
@property (copy, nonatomic) NSString *isMaster;

@property (strong, nonatomic) UIBarButtonItem *rightBarButtonItem;



@end

@implementation CNBoxUserManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.title = @"使用者管理";
    /*** 右侧按钮 ***/
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    
    self.dataArray = [NSMutableArray array];
    self.managerArray = [NSMutableArray array];
    [self setupUI];
    [self layoutUI];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)setupUI {
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.tableViewFooterV];
    
    
    
}

- (void)layoutUI {
    if (@available(iOS 11.0, *)) {
        self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight - 200 - kNavigationBarHeight);
    }else {
        self.tableView.frame = CGRectMake(0, kNavigationBarHeight, KScreenWidth, KScreenHeight - 200 - kNavigationBarHeight);
    }
    
}


#pragma mark - 按钮实现
- (void)rightButtonItemAction:(id)sender event:(UIEvent *)event{
    
    FTPopOverMenuConfiguration *config = [FTPopOverMenuConfiguration defaultConfiguration];
    config.menuWidth = 140;
    config.menuCornerRadius = 10.f;
    config.separatorInset = UIEdgeInsetsMake(0, 15.f, 0, 15.f);
    config.imageSize = CGSizeMake(16.f, 16.f);
    config.selectedTextColor = [UIColor whiteColor];
    
    [FTPopOverMenu showFromEvent:event withMenuArray:self.menuObjectArray imageArray:@[@"device_invite_friends",@"device_invite_code"] configuration:config doneBlock:^(NSInteger selectedIndex) {
        
        NSLog(@"输出选中 = %ld",selectedIndex);
        if (selectedIndex == 0) {
            
            [self enterSelectFriendsVC];
            
            
            
            
        }else {
            
            [self QRCodeInviteVC];
            
        }
        
        
    }dismissBlock:^{
        
    }];
    
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.dataArray.count > 0) {
        return 2;
    }else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.managerArray.count;
    }else {
        return self.dataArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.isMaster isEqualToString:@"1"]) {//isMaster == 1 为主
        
        if (indexPath.section == 0) {
            CNBoxUserMannagerCell *cell = [tableView dequeueReusableCellWithIdentifier:kCNBoxUserMannagerCell forIndexPath:indexPath];
            CNBoxUserModel *model = [self.managerArray objectAtIndex:indexPath.row];
            if (model) {
                [cell editUI:model];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }else {
            CNBoxOtherUserMannagerCell *cell = [tableView dequeueReusableCellWithIdentifier:kCNBoxOtherUserMannagerCell forIndexPath:indexPath];
            CNBoxUserModel *model = [self.dataArray objectAtIndex:indexPath.row];
            if (model) {
                [cell editUI:model indexPath:indexPath];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            __weak typeof(self) weakSelf = self;
            cell.clickCancleBtnAction = ^(CNBoxOtherUserMannagerCell * _Nonnull cell, UIButton * _Nonnull cancleBtn) {
                
                CNBoxUserModel *model = [self.dataArray objectAtIndex:cell.indexpath.row];
                
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"移除提示" message:@"移除后，该用户将不再具备管理\n音箱的权限，确定移除吗？     " preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf cancleWith:model.sid indexPath:indexPath];
                }];
                
                [alertController addAction:cancelAction];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
                
                
            };
            cell.clickEditBtnAction = ^(CNBoxOtherUserMannagerCell * _Nonnull cell, UIButton * _Nonnull editBtn) {
                
                [weakSelf getSetRoleListWithIndePath:cell.indexpath];
                
                
                
            };
            return cell;
        }
        
    }else {
        
        CNBoxUserMannagerCell *cell = [tableView dequeueReusableCellWithIdentifier:kCNBoxUserMannagerCell forIndexPath:indexPath];
        
        if (indexPath.section == 0) {
            CNBoxUserModel *model = [self.managerArray objectAtIndex:indexPath.row];
            if (model) {
                [cell editUI:model];
            }
        }else {
            CNBoxUserModel *model = [self.dataArray objectAtIndex:indexPath.row];
            if (model) {
                [cell editUI:model ];
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
        
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }else {
        return 10;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}

#pragma mark - 事件实现
- (void)rightBtnAction:(id)sender {
    
    self.tableView.tableHeaderView = [UIView new];
    
}

- (void)inviteBtnAction:(id)sender {
    
    [self enterSelectFriendsVC];
    
    
}

- (void)inviteCodeAction:(id)sender {
    
    [self QRCodeInviteVC];
    
}


#pragma mark - 点击弹框部分
/*** 进入邀请好友界面 ***/
- (void)enterSelectFriendsVC {
    
    CNBoxSelectFriendsController *selectVC = [[CNBoxSelectFriendsController alloc]init];
    selectVC.familyID = [NSString stringWithFormat:@"%@",self.familyID ?: @""];
    [[AppDelegate sharedAppDelegate] pushViewController:selectVC];
    
}

/*** 进入邀请我二维码界面 ***/
- (void)QRCodeInviteVC {
    
    CNBoxEditQRCodeController *qrCodeVC = [[CNBoxEditQRCodeController alloc]init];
    qrCodeVC.familyID = [NSString stringWithFormat:@"%@",self.familyID];
    [[AppDelegate sharedAppDelegate] pushViewController:qrCodeVC];
    
}


#pragma mark - 取得数据


#pragma mark - 用于点击Cell部分
/*** 获取设置角色列表 ***/
- (void)getSetRoleListWithIndePath:(NSIndexPath *)indexPath {
    
    NSLog(@"输出内容,准备邀请");
    
    NSString *familyId = [NSString stringWithFormat:@"%@",self.familyID ?: @""];
    [QMUITips showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    [CNLiveVoiceBoxModelHelper getSetRoleListWithFamilyId:familyId completerBlick:^(id  _Nonnull data, NSError * _Nonnull error) {
        [QMUITips hideAllTipsInView:weakSelf.view];
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        if (error) {
            
            NSString *showText = @"网络连接失败，请稍后再试";
            if (error.code == -1001 || error.code == -1009) {//没有网络
                           
            }else {
                showText = @"获取角色列表失败";
            }
                    
            [QMUITips showWithText:showText inView:self.view hideAfterDelay:0.5];
        }else {
            NSDictionary *contentDic = data;
            NSMutableArray *familyTypes = [NSMutableArray array];
            if ([contentDic containsObjectForKey:@"roleList"]) {
                NSMutableArray *roleList = contentDic[@"roleList"];
                [roleList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    NSDictionary *dic = obj;
                    CNLiveBoxRoleModel *model = [CNLiveBoxRoleModel mj_objectWithKeyValues:dic];
                    [familyTypes addObject:model];
                    
                }];
            }
            
            if (familyTypes.count == 0) {
                [QMUITips showWithText:@"无角色列表" inView:self.view hideAfterDelay:0.5];
                return;
            }
            strongSelf.rolesArray = familyTypes;
            CNBoxUserModel *model = [strongSelf.dataArray objectAtIndex:indexPath.row];
            [weakSelf showCNLiveBoxTipAlertViewWithModel:model indexPath:indexPath];
            
        }
        
    }];
    
    
}

/*** 删除成员角色 ***/
- (void)cancleWith:(NSString *)sid  indexPath:(NSIndexPath *)indexPath {
    
    NSString *familyIdStr = [NSString stringWithFormat:@"%@", self.familyID ?: @""];
    NSString *sIdStr = [NSString stringWithFormat:@"%@",sid ?:@""];
    [QMUITips showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    [CNLiveVoiceBoxModelHelper updateFamilyMemberRoleWithFamilyId:familyIdStr sid:sIdStr completerBlick:^(id  _Nonnull data, NSError * _Nonnull error) {
        [QMUITips hideAllTipsInView:weakSelf.view];
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        if (error) {
            [QMUITips showWithText:@"删除失败" inView:weakSelf.view hideAfterDelay:0.5];
        }else {
            [strongSelf.dataArray removeObjectAtIndex:indexPath.row];
            
            if (strongSelf.dataArray.count > 0) {
                strongSelf.tableViewFooterV.hidden = YES;
                if (@available(iOS 11.0, *)) {
                    strongSelf.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
                }else {
                    strongSelf.tableView.frame = CGRectMake(0, kNavigationBarHeight, KScreenWidth, KScreenHeight - kNavigationBarHeight);
                }
                
                
            }else {
                
                if (@available(iOS 11.0, *)) {
                    strongSelf.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight -200);
                }else {
                    strongSelf.tableView.frame = CGRectMake(0, kNavigationBarHeight, KScreenWidth, KScreenHeight -200 -kNavigationBarHeight);
                }
                if ([strongSelf.isMaster isEqualToString:@"1"]) {
                    strongSelf.tableViewFooterV.hidden = NO;
                }else {
                    strongSelf.tableViewFooterV.hidden = YES;
                }
                
            }
            [weakSelf.tableView reloadData];
        }
        
    }];
    
}

/*** 编辑成员角色 ***/
- (void)eidtWithSid:(NSString *)sid role:(NSString *)role indexPath:(NSIndexPath *)indexPath roleName:(NSString *)roleName {
    
    if (sid.length <= 0 || roleName <= 0) {
        [QMUITips showWithText:@"未选择角色" inView:self.view hideAfterDelay:1.5];
        return;
    }
    
    NSString *familyIdStr = [NSString stringWithFormat:@"%@", self.familyID ?: @""];
    [QMUITips showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    [CNLiveVoiceBoxModelHelper editFamilyMemberRoleWithFamilyId:familyIdStr sid:sid role:role completerBlick:^(id  _Nonnull data, NSError * _Nonnull error) {
        
        [QMUITips hideAllTipsInView:weakSelf.view];
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        if (error) {
            [QMUITips showWithText:@"编辑失败" inView:weakSelf.view hideAfterDelay:0.5];
        }else {
            CNBoxUserModel *model  = [strongSelf.dataArray objectAtIndex:indexPath.row];
            model.roleId = role;
            model.roleName = roleName;
            [weakSelf.tableView reloadData];
        }
        
    }];
    
}


#pragma mark - 进入界面获取管理员家庭成员
/*** 获取家庭人员列表 ***/
- (void)loadData {
    [QMUITips showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    
    
    NSString *familyId = [NSString stringWithFormat:@"%@",self.familyID ?: @""];
    
    [CNLiveVoiceBoxModelHelper getFamilyRoleWithFamilyId:familyId completerBlick:^(id  _Nonnull data, NSError * _Nonnull error) {
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
            
            [weakSelf showEmptyViewWithImage:[UIImage imageNamed:@"wufalianjie"] text:showText detailText:@"别紧张，试试看刷新页面~" buttonTitle:@"     重试     " buttonAction:@selector(loadData)];
            [weakSelf setCNAPIErrorEmptyView];
            weakSelf.emptyView.frame = CGRectMake(0, kNavigationBarHeight, KScreenWidth, KScreenHeight - kNavigationBarHeight);
            weakSelf.emptyView.backgroundColor = [UIColor whiteColor];
            
        }else {
            
            /** 有网络 */
            if (weakSelf.emptyView) {
                [weakSelf hideEmptyView];
            }
            
            CNBoxUserAllModel *allModel = [CNBoxUserAllModel mj_objectWithKeyValues:data];
            
            //这里后台isMaster == 1 是主人 0 不是  前面相反
            if ([allModel.isMaster isEqualToString:@"1"]) {
                strongSelf.isMaster = @"1";
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"邀请使用者" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonItemAction:event:)];
            }else {
                strongSelf.isMaster = @"0";
            }
            [strongSelf.dataArray removeAllObjects];
            [strongSelf.managerArray removeAllObjects];
            [allModel.familyRoleList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CNBoxUserModel *userModel = obj;
                if ([userModel.roleId isEqualToString:@"11"]) {//11是管理员
                    [strongSelf.managerArray addObject:userModel];
                }else {
                    [strongSelf.dataArray addObject:userModel];
                };
                
            }];
            
            
            if (strongSelf.dataArray.count > 0) {
                strongSelf.tableViewFooterV.hidden = YES;
                if (@available(iOS 11.0, *)) {
                    strongSelf.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
                }else {
                    strongSelf.tableView.frame = CGRectMake(0, kNavigationBarHeight, KScreenWidth, KScreenHeight- kNavigationBarHeight);
                }
                
               
            }else {
                if (@available(iOS 11.0, *)) {
                    strongSelf.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight -200);
                }else {
                    strongSelf.tableView.frame = CGRectMake(0, kNavigationBarHeight, KScreenWidth, KScreenHeight -200-kNavigationBarHeight);
                }
                
                if ([strongSelf.isMaster isEqualToString:@"1"]) {
                    strongSelf.tableViewFooterV.hidden = NO;
                }else {
                    strongSelf.tableViewFooterV.hidden = YES;
                }
            }
            
            
            [strongSelf.tableView reloadData];
            
        }
        
        
    }];
    
}

#pragma mark - 实现
- (void)showCNLiveBoxTipAlertViewWithModel:(CNBoxUserModel *)model indexPath:(NSIndexPath *)indexPath {
    
    CNLiveBoxRoleAlertView *alerV = [CNLiveBoxRoleAlertView showAlertAddedTo:AppKeyWindow];
    [alerV showAlerView];
    alerV.dataArray = self.rolesArray;
    alerV.boxUserModel = model;
    __weak typeof(self) weakSelf = self;
    alerV.clickSureBtnBlock = ^(CNLiveBoxRoleAlertView * _Nonnull view, UIButton * _Nonnull sureBtn) {
        NSString *sidStr = [NSString stringWithFormat:@"%@",view.boxUserModel.sid ?: @""];
        NSString *roleStr = [NSString stringWithFormat:@"%@",view.selectRole];
        NSString *roleName = [NSString stringWithFormat:@"%@",view.selectRoleName];
        [weakSelf eidtWithSid:sidStr role:roleStr indexPath:indexPath roleName:roleName];
        
    };
    
}


#pragma mark - 属性
- (NSArray<FTPopOverMenuModel *> *)menuObjectArray {
    if (!_menuObjectArray) {
        _menuObjectArray = @[[[FTPopOverMenuModel alloc] initWithTitle:@"邀请网家家好友" image:@"device_invite_friends" selected:NO],[[FTPopOverMenuModel alloc] initWithTitle:@"生成二维码邀请" image:@"device_invite_code" selected:NO]];
    }
    return _menuObjectArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[CNBoxUserMannagerCell class] forCellReuseIdentifier:kCNBoxUserMannagerCell];
        [_tableView registerClass:[CNBoxOtherUserMannagerCell class] forCellReuseIdentifier:kCNBoxOtherUserMannagerCell];
        [_tableView setBackgroundColor:RGBACOLOR(242, 242, 242, 1)];
        _tableView.tableHeaderView = self.tableViewHeaderV;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
    }
    return _tableView;
}

- (UIView *)tableViewHeaderV {
    if (!_tableViewHeaderV) {
        _tableViewHeaderV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
        [_tableViewHeaderV setBackgroundColor:RGBACOLOR(247, 176, 84, 1)];
        UILabel *textL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth - 34, 44)];
        textL.textAlignment = NSTextAlignmentRight;
        textL.textColor = [UIColor whiteColor];
        textL.font = [UIFont systemFontOfSize:15];
        [_tableViewHeaderV addSubview:textL];
        textL.text = @"使用者可以共同管理音箱，最多支持10个人管理";
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tableViewHeaderV addSubview:rightBtn];
        rightBtn.frame = CGRectMake(KScreenWidth - 34, 0, 34, 44);
        [rightBtn setImage:[UIImage imageNamed:@"device_header_cancle"] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _tableViewHeaderV;
}

- (UIView *)tableViewFooterV {
    
    if (!_tableViewFooterV) {
        _tableViewFooterV = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 200, KScreenWidth, 200)];
        [_tableViewFooterV setBackgroundColor:[UIColor clearColor]];
        _inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tableViewFooterV addSubview:_inviteBtn];
        _inviteBtn.frame = CGRectMake(60, 25, KScreenWidth - 120 , 44);
        [_inviteBtn setTitle:@"邀请网家家好友" forState:UIControlStateNormal];
        [_inviteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _inviteBtn.layer.masksToBounds = YES;
        _inviteBtn.layer.cornerRadius = 22;
        _inviteBtn.backgroundColor = RGBCOLOR(35, 212, 30);
        _inviteBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_inviteBtn addTarget:self action:@selector(inviteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _inviteCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tableViewFooterV addSubview:_inviteCodeBtn];
        _inviteCodeBtn.layer.masksToBounds = YES;
        _inviteCodeBtn.layer.cornerRadius = 22;
        _inviteCodeBtn.frame = CGRectMake(60, 89, KScreenWidth - 120 , 44);
        [_inviteCodeBtn setTitle:@"生成二维码邀请" forState:UIControlStateNormal];
        [_inviteCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _inviteCodeBtn.backgroundColor = RGBCOLOR(35, 212, 30);
        _inviteCodeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_inviteCodeBtn addTarget:self action:@selector(inviteCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tableViewFooterV;
    
}





@end
