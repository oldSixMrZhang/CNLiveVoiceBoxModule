//
//  CNBOXInviteFriendsController.m
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/10/11.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import "CNBOXInviteFriendsController.h"
#import "CNBOXInviteFriendsCell.h"
#import "CNBOXIMUser.h"
#import "CNLiveBoxRoleModel.h"
#import "CNLiveVoiceBoxModelHelper.h"
#import "CNBoxUserManagerController.h"
#import "CNBoxSelectFriendsController.h"


typedef NS_ENUM(NSUInteger, CNBOXInviteFriendsStatus) {
    //将一个变成选中 -> (当前人的这个角色为选中  其他人这个角色都为不可选)
    CNBOXInviteFriendsNormalChangeSelect,
    //将选中的变为不可选中 -> (点击了同一个人的同一个角色  当前人的这个角色未选中 其他人这个角色都为可选且默认)
    CNBOXInviteFriendsSelectChangeNormal,
    //将有选中角色的用户,一个有选中角色的人选择不同角色  ->(点击同个人的不同角色 当前角色变为选中, 其他人不可选这个角色  之前角色变为可选,其他人都可选 )
    CNBOXInviteFriendsSelectOtherNormalChangeSelect,
};

@interface CNBOXInviteFriendsController ()<UITableViewDelegate,UITableViewDataSource>

/*** 头部headerView ***/
@property (strong, nonatomic) UIView *tableViewHeaderV;

/*** 列表 ***/
@property (strong, nonatomic) UITableView *tableView;

/*** 下一步 ***/
@property (nonatomic, strong) UIButton *inviteBtn;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation CNBOXInviteFriendsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置角色";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.dataArray = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    [self.inviteFriendsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        IMAUser *user = obj;
        CNBOXIMUser *boxIMUser = [[CNBOXIMUser alloc]init];
        boxIMUser.user = user;

        NSMutableArray *dataArr = [[NSMutableArray alloc] init];
        [self.familyTypeArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            CNLiveBoxRoleModel *model = [CNLiveBoxRoleModel mj_objectWithKeyValues:dic];
            model.isSelect = @"0";
            model.isCurrentUse = @"1";
            
            [dataArr addObject:model];
        }];
        
        boxIMUser.roles = dataArr;
        [weakSelf.dataArray addObject:boxIMUser];
    }];
    
    CGFloat height = 65;
    NSInteger remainder = self.familyTypeArr.count % 4;
    NSInteger count = self.familyTypeArr.count /4;
    if (remainder >0) {
        count ++;
    }
    height += count *24 + (count + 1)*10;
    self.cellHeight = height;
    
    [self setupUI];
    [self layoutUI];
}

- (void)setupUI {
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.inviteBtn];
    
    
}

- (void)layoutUI {
    if (@available(iOS 11.0, *)) {
        self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight -104);
    }else {
        self.tableView.frame = CGRectMake(0, kNavigationBarHeight, KScreenWidth, KScreenHeight -104 - kNavigationBarHeight);
    }
    self.inviteBtn.frame = CGRectMake((KScreenWidth - 275)/2, KScreenHeight - 94, 275, 45);
}


#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CNBOXInviteFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:kCNBOXInviteFriendsCell forIndexPath:indexPath];
    CNBOXIMUser *user = self.dataArray [indexPath.section];
    if (user) {
        [cell editUI:user indexPath:indexPath];
    }
    __weak typeof(self) weakSelf = self;
    cell.clickFriendsTypes = ^(CNBOXInviteFriendsCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, NSInteger selectCount) {
        [weakSelf editData:cell indexPath:indexPath selectCount:selectCount];
    };
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.cellHeight;
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

#pragma mark - 点击编辑数据
- (void)editData:(CNBOXInviteFriendsCell *) cell indexPath:(NSIndexPath *)indexPath selectCount:(NSInteger) selectCount {
    
    
    NSLog(@"输出点击了");
    
    CNBOXIMUser *user = self.dataArray [indexPath.section];//取人
    NSMutableArray *rolesArray = user.roles;
    
    __block CNLiveBoxRoleModel *selectModel = nil;//一个cell的选中model
    [rolesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CNLiveBoxRoleModel *model = obj;
        if ([model.isSelect isEqualToString:@"1"]) {
            selectModel = model;
        }
        
    }];
    
    if (selectModel) {// 取人含有角色
        
        CNLiveBoxRoleModel *model = user.roles[selectCount];
        
        if ([model.allowUse isEqualToString:@"1"]) {
            
            if ([model.isCurrentUse isEqualToString:@"1"]) {
                
                if ([model.isSelect isEqualToString:@"1"]) {
                    [self editStatus:CNBOXInviteFriendsSelectChangeNormal indexPath:indexPath selectCount:selectCount];
                }else {
                    [self editStatus:CNBOXInviteFriendsSelectOtherNormalChangeSelect indexPath:indexPath selectCount:selectCount];
                }
                
            }else {
                NSLog(@"输出角色在页面之后已经使用");
                return;
            }
            
        }else {//不可选
            NSLog(@"输出角色在页面之前已经使用");
            return;
        }
        
    }else {
        CNLiveBoxRoleModel *model = user.roles[selectCount];
        
        if ([model.allowUse isEqualToString:@"1"]) {
            
            if ([model.isCurrentUse isEqualToString:@"1"]) {
                
                [self editStatus:CNBOXInviteFriendsNormalChangeSelect indexPath:indexPath selectCount:selectCount];
                
            }else {
                NSLog(@"输出角色在页面之后已经使用");
                return;
            }
            
        }else {//不可选
            NSLog(@"输出角色在页面之前已经使用");
            return;
        }
    }
    
    
    [self.tableView reloadData];
    
    
    if ([self checkAllSelect]) {
        
        self.inviteBtn.enabled = YES;
        self.inviteBtn.backgroundColor = RGBCOLOR(35, 212, 30);
        
    }else {
        self.inviteBtn.enabled = NO;
        self.inviteBtn.backgroundColor = RGBCOLOR(200, 200, 200);
    }
    
    
}

/*** 判断是否全部有角色 ***/
- (BOOL)checkAllSelect {
    
    __block BOOL isAllSelect = YES;
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               
        CNBOXIMUser *user = obj;
        NSMutableArray *roles = user.roles;
        __block BOOL isSelect = NO;
        [roles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CNLiveBoxRoleModel *model = roles[idx];
            if ([model.isSelect isEqualToString:@"1"]) {
                isSelect = YES;
            }
                                  
                                  
        }];
        
        if (!isSelect) {
            isAllSelect = NO;
            *stop = YES;
           
        }
               
    }];
    return isAllSelect;
    
}



- (void)editStatus:(CNBOXInviteFriendsStatus) status indexPath:(NSIndexPath *)indexPath selectCount:(NSInteger)selectCount {
    
    
    if (status == CNBOXInviteFriendsNormalChangeSelect) {//
        
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CNBOXIMUser *user = obj;
            NSMutableArray *roles = user.roles;
            [roles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                               
                if (idx == selectCount) {
                    CNLiveBoxRoleModel *model = roles[idx];
                    model.isCurrentUse = @"0";
                }
                               
                               
            }];
            
        }];
    
        CNBOXIMUser *user = self.dataArray [indexPath.section];//取人
        NSMutableArray *rolesArray = user.roles;
        CNLiveBoxRoleModel *model = rolesArray[selectCount];
        model.isCurrentUse = @"1";
        model.isSelect = @"1";
        
        
    }else if (status == CNBOXInviteFriendsSelectChangeNormal) {
        
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CNBOXIMUser *user = obj;
            NSMutableArray *roles = user.roles;
            if (idx == indexPath.section) {
                
                [roles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                    if (idx == selectCount) {
                        CNLiveBoxRoleModel *model = roles[idx];
                        model.isSelect = @"0";
                    }
                    
                    
                }];
                
                
            }else {
                
                [roles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if (idx == selectCount) {
                        CNLiveBoxRoleModel *model = roles[idx];
                        model.isCurrentUse = @"1";
                    }
                    
                    
                }];
                
            }
            
        }];
        
    }else {
        
        __block NSInteger selectIndex = -1;
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CNBOXIMUser *user = obj;
            NSMutableArray *roles = user.roles;
            
            if (idx == indexPath.section) {
                [roles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                               
                    CNLiveBoxRoleModel *model = roles[idx];
                    if ([model.isSelect isEqualToString:@"1"]) {
                        selectIndex = idx;
                    }
                               
                }];
                       
            }
        
        }];
        
        
        if (selectIndex >= 0) {
            __block NSInteger selectIdx = selectIndex;
            [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                CNBOXIMUser *user = obj;
                NSMutableArray *roles = user.roles;
                if (idx == indexPath.section) {
                    
                    [roles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                        if (idx == selectIdx) {
                            CNLiveBoxRoleModel *model = roles[idx];
                            model.isSelect = @"0";
                        }
                        
                        
                    }];
                    
                    
                }else {
                    
                    [roles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        if (idx == selectIdx) {
                            CNLiveBoxRoleModel *model = roles[idx];
                            model.isCurrentUse = @"1";
                        }
                        
                        
                    }];
                    
                }
                
            }];
            
        }else {
            return;
        }
        
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                CNBOXIMUser *user = obj;
                NSMutableArray *roles = user.roles;
                [roles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                   
                    if (idx == selectCount) {
                        CNLiveBoxRoleModel *model = roles[idx];
                        model.isCurrentUse = @"0";
                    }
                                   
                                   
                }];
                
            }];
        
            CNBOXIMUser *user = self.dataArray [indexPath.section];//取人
            NSMutableArray *rolesArray = user.roles;
            CNLiveBoxRoleModel *model = rolesArray[selectCount];
            model.isCurrentUse = @"1";
            model.isSelect = @"1";
    
        
    }
    
}


#pragma mark - 事件实现
- (void)rightBtnAction:(UIButton *)sender {
    _tableView.tableHeaderView = [UIView new];
}

- (void)nextBtnAction:(UIButton *)sender {
    NSLog(@"可以点击了");
    if (!self.familyID) {
        [QMUITips showWithText:@"家庭信息不全" inView:self.view hideAfterDelay:0.5];
    }
    
    NSMutableArray *dicArray = [NSMutableArray array];
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *familyIdStr = [NSString stringWithFormat:@"%@",self.familyID];
        [dic setValue:familyIdStr forKey:@"familyId"];
        CNBOXIMUser *user = obj;
        NSString *sidStr = [NSString stringWithFormat:@"%@",user.user.userId];
        [dic setValue:sidStr forKey:@"sid"];
        [user.roles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CNLiveBoxRoleModel *model = obj;
            if ([model.allowUse isEqualToString:@"1"] && [model.isSelect isEqualToString:@"1"]) {
                NSString *roleStr = [NSString stringWithFormat:@"%@",model.ID];
                [dic setValue:roleStr forKey:@"roleId"];
            }
            
        }];
        [dicArray addObject:dic];
    }];
    
    [self familyGroupInviteWithMembers:dicArray];
}

#pragma mark - 接口
- (void)familyGroupInviteWithMembers:(NSMutableArray *)members {
     
    __weak typeof(self) weakSelf = self;
    [QMUITips showLoadingInView:self.view];
    [CNLiveVoiceBoxModelHelper familyGroupInviteWithMembers:members completerBlick:^(id  _Nonnull data, NSError * _Nonnull error) {
        [QMUITips hideAllTipsInView:weakSelf.view];
        
        if (error) {
            if (error.code == 4313) {
                NSString *errorMsg = [NSString stringWithFormat:@"%@",error.domain];
                [QMUITips showWithText:errorMsg inView:weakSelf.view hideAfterDelay:1.0];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    UIViewController *target = nil;
                       for (UIViewController * controller in self.navigationController.viewControllers) {
                           if ([controller isKindOfClass:[CNBoxSelectFriendsController class]]) {
                               target = controller;
                               CNBoxSelectFriendsController *selectFriendsVC = (CNBoxSelectFriendsController *)controller;
                               
                               [selectFriendsVC getSelectedFriends];
                           }
                       }
                       if (target) {
                           [[AppDelegate sharedAppDelegate] popToViewController:target];
                       }else {
                           [[AppDelegate sharedAppDelegate] popToRootViewController];
                       }
                });
                
            }else {
                [QMUITips showWithText:@"邀请失败" inView:weakSelf.view hideAfterDelay:0.5];
            }
            
        }else {
            [QMUITips showWithText:@"邀请成功" inView:weakSelf.view hideAfterDelay:0.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIViewController *target = nil;
                for (UIViewController * controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[CNBoxUserManagerController class]]) {
                        target = controller;
                        CNBoxUserManagerController *vc =  (CNBoxUserManagerController *)controller;
                        [vc loadData];
                    }
                }
                if (target) {
                    [[AppDelegate sharedAppDelegate] popToViewController:target];
                }else {
                    [[AppDelegate sharedAppDelegate] popToRootViewController];
                }
            });
            
        }
        
    }];
    
}

#pragma mark - 属性

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[CNBOXInviteFriendsCell class] forCellReuseIdentifier:kCNBOXInviteFriendsCell];
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
        textL.textAlignment = NSTextAlignmentCenter;
        textL.textColor = [UIColor whiteColor];
        textL.font = [UIFont systemFontOfSize:15];
        [_tableViewHeaderV addSubview:textL];
        textL.text = @"对已选用户设置角色，确立亲情关系";
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_tableViewHeaderV addSubview:rightBtn];
        rightBtn.frame = CGRectMake(KScreenWidth - 34, 0, 34, 44);
        [rightBtn setImage:[UIImage imageNamed:@"device_header_cancle"] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _tableViewHeaderV;
}


- (UIButton *)inviteBtn {
    if (!_inviteBtn) {
        _inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _inviteBtn.layer.masksToBounds = YES;
        _inviteBtn.enabled = NO;
        _inviteBtn.layer.cornerRadius = 22;
        [_inviteBtn setTitle:@"一键邀请" forState:UIControlStateNormal];
        [_inviteBtn setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
        [_inviteBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _inviteBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _inviteBtn.backgroundColor = RGBCOLOR(200, 200, 200);
    }
    return _inviteBtn;
    
}


@end
