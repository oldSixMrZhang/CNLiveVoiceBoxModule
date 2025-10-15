//
//  CNBoxSelectFriendsController.m
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/10/9.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import "CNBoxSelectFriendsController.h"
#import "CNSearch.h"
#import "CNLiveBoxSelectFirendsCell.h"
#import "BAContact.h"
#import "CNContactHeaderView.h"

#import "IMAGroup+MemberList.h"

#import "CNTopWarningView.h"

#import "CNGroupListAvaterUtil.h"
#import "NSString+Category.h"
#import "NSString+IMPinyin.h"
#import "CNBOXInviteFriendsController.h"
#import "CNLiveVoiceBoxModelHelper.h"
#import "CNLiveBoxRoleModel.h"


#define kFirendCount 11;

@interface CNBoxSelectFriendsController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>{
    UILabel *_noneLab; //没有搜索结果 的提示语
}

/*** 搜索 ***/
@property (nonatomic, strong) CNSearch *searchBar;
/*** 列表 ***/
@property (nonatomic, strong) UITableView *tableView;
/*** 下一步 ***/
@property (nonatomic, strong) UIButton *nextBtn;
/*** 搜索蒙层 ***/
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, assign) BOOL searchStatusActive;



@property (nonatomic, strong) NSMutableArray *searchResultArr;
@property (nonatomic, strong) NSArray *rowArr;
@property (nonatomic, strong) NSArray *sectionArr;
@property (nonatomic, strong) NSMutableArray *totalArr;



@end

@implementation CNBoxSelectFriendsController

- (void)dealloc
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    self.title = @"选择好友";
    
    self.selectedFriends = [NSMutableArray array];
    self.searchResultArr = [NSMutableArray array];
    self.totalArr = [NSMutableArray array];
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.nextBtn];
    [self.view addSubview:self.maskView];
    [self layoutUI];
    
    [self getSelectedFriends];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)layoutUI {
    
    self.searchBar.frame = CGRectMake(0, kNavigationBarHeight, KScreenWidth, 55);
    self.tableView.frame = CGRectMake(0, kNavigationBarHeight + 55, KScreenWidth, KScreenHeight - 55 - 96 - kNavigationBarHeight);
    self.nextBtn.frame = CGRectMake((KScreenWidth - 275)/2, self.tableView.bottom +20, 275, 45);
    
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    // 需要进行的操作
    self.tableView.frame = CGRectMake(0, kNavigationBarHeight + 55, KScreenWidth, KScreenHeight - 55 - 96 - kNavigationBarHeight - height);
    self.nextBtn.frame = CGRectMake((KScreenWidth - 275)/2, self.tableView.bottom +20, 275, 45);
}

//当键退出时调用
-(void)keyboardWillHide:(NSNotification *)aNotification {
    // 界面复原
    self.tableView.frame = CGRectMake(0, kNavigationBarHeight + 55, KScreenWidth, KScreenHeight - 55 - 96 - kNavigationBarHeight);
    self.nextBtn.frame = CGRectMake((KScreenWidth - 275)/2, self.tableView.bottom +20, 275, 45);
    
}


#pragma mark -
#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_searchStatusActive) {
        return 1;
    } else {
        return self.sectionArr.count;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_searchStatusActive) {
        return _searchResultArr.count;
    } else {
        return [self.rowArr[section] count];
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CNLiveBoxSelectFirendsCell *selectFriendsCell = [tableView dequeueReusableCellWithIdentifier:kCNLiveBoxSelectFirendsCell forIndexPath:indexPath];
    
    if (_searchStatusActive) {
        if (self.searchResultArr.count > 0) {
            IMAUser *user = (IMAUser *)[self.searchResultArr objectAtIndex:indexPath.row];
            if (user) {
                [selectFriendsCell editUI:user];
            }
        }
       
        
    }else {
        if (self.rowArr.count > 0) {
            NSArray *users = self.rowArr[indexPath.section];
            if (users.count > 0) {
                IMAUser *user = users[indexPath.row];
                if (user) {
                    [selectFriendsCell editUI:user];
                }
            }
            
        }
       
    }
    
    return selectFriendsCell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (_searchStatusActive) {
        return [UIView new];
    } else {
        CNContactHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CNContactHeaderView"];
        [view setText:self.sectionArr[section]];
        return view;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (_searchStatusActive) {
        return 0.1;
    } else {
        return 23;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSInteger selectTotalCount = kFirendCount;
    selectTotalCount = selectTotalCount - self.existedFriends.count;
    /*** 获取选中人数 ***/
    __block NSInteger selectCount = 0;
    [self.totalArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        IMAUser *user = obj;
        if (user.isSelected) {
            selectCount ++;
        }
    }];
    
    
    if (selectCount == selectTotalCount) {
        
         if (_searchStatusActive) {
               IMAUser *user = (IMAUser *)[self.searchResultArr objectAtIndex:indexPath.row];
               if (user.isInvate) {
                   return;
               }else {
                   
                   if (user.isSelected) {
                       
                   }else {
                       [QMUITips showWithText:@"最多可以邀请10人" inView:self.view hideAfterDelay:0.5];
                       return;
                   }
               }
               
           }else {
               NSArray *users = self.rowArr[indexPath.section];
               IMAUser *user = users[indexPath.row];
               if (user.isInvate) {
                   return;
               }else {
                     if (user.isSelected) {
                                        
                     }else {
                         [QMUITips showWithText:@"最多可以邀请10人" inView:self.view hideAfterDelay:0.5];
                         return;
                     }
               }
               
           }

    }
    
    if (_searchStatusActive) {
        IMAUser *user = (IMAUser *)[self.searchResultArr objectAtIndex:indexPath.row];
        if (user.isInvate) {
            return;
        }else {
            user.isSelected = !user.isSelected;
            [self.tableView reloadData];
        }
        
    }else {
        NSArray *users = self.rowArr[indexPath.section];
        IMAUser *user = users[indexPath.row];
        if (user.isInvate) {
            return;
        }else {
            user.isSelected = !user.isSelected;
        }
        
        [self.tableView reloadData];
        
    }
    
    __block NSInteger showSelectCount = 0;
    [self.selectedFriends removeAllObjects];
    [self.totalArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        IMAUser *user = obj;
        if (user.isSelected) {
            showSelectCount ++;
            [self.selectedFriends addObject:user];
        }
    }];
    
    if (showSelectCount > 0) {
        self.nextBtn.enabled = YES;
        self.nextBtn.backgroundColor = RGBCOLOR(35, 212, 30);
    }else {
        self.nextBtn.enabled = NO;
        self.nextBtn.backgroundColor = RGBCOLOR(200, 200, 200);
    }
    
    NSString *nextStr = [NSString stringWithFormat:@"%@(%ld)",@"下一步",showSelectCount];
    [self.nextBtn setTitle:nextStr forState:UIControlStateNormal];
    
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    _searchStatusActive = YES;
    if (_searchResultArr.count > 0) {
        
    }
    else
    {
        _maskView.hidden = NO;
        _noneLab.text = @"";
    }
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if ([searchText isEqualToString:@""]) {
        _maskView.hidden = NO;
        _noneLab.text = @"";
        
        return;
    }
    searchText = [searchText chineseTransformPinyin:searchText];
    //需要事先情况存放搜索结果的数组
    [self.searchResultArr removeAllObjects];
    [self.tableView reloadData];
    //加个多线程，否则数量量大的时候，有明显的卡顿现象
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    dispatch_async(globalQueue, ^{
        if (searchText != nil && searchText.length > 0) {
            
            //遍历需要搜索的所有内容，其中self.dataArray为存放总数据的数组
            
            [self.totalArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                IMAUser *user = obj;
                NSString *tempStr = [user showTitle];
                
                //----------->把所有的搜索结果转成成拼音
                NSString *pinyin = CNLiveStringTransformToPinyin(tempStr);
                
                if ([pinyin rangeOfString:searchText options:NSCaseInsensitiveSearch].length >0 ) {
                    //把搜索结果存放self.resultArray数组
                    [self.searchResultArr addObject:user];
                }
            }];
            
        }
        
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.searchResultArr.count > 0) {
                _searchStatusActive = YES;
                _maskView.hidden = YES;
                [self.tableView reloadData];
                
            }
            else
            {
                _maskView.hidden = NO;
                _noneLab.text = [NSString stringWithFormat:@"没有找到“%@”相关结果",searchBar.text];
                [self.tableView reloadData];
                
                
            }
            
        });
    });
    
    
}

#pragma mark - 接口
/*** 进入邀请好友界面 ***/
- (void)getSelectedFriends {
    
    self.selectedFriends = [NSMutableArray array];
    self.searchResultArr = [NSMutableArray array];
    self.totalArr = [NSMutableArray array];
    
    NSString *familyIDStr = [NSString stringWithFormat:@"%@",self.familyID ?: @""];
    [QMUITips showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    [CNLiveVoiceBoxModelHelper getFamilyMemberWithFamilyId:familyIDStr completerBlick:^(id  _Nonnull data, NSError * _Nonnull error) {
        [QMUITips hideAllTipsInView:weakSelf.view];
        
        if (error) {
            
            NSString *showText = @"网络连接失败，请稍后再试";
            if (error.code == -1001 || error.code == -1009) {//没有网络
                
            }else {
                showText = @"请求失败,请重试";
            }
            
            [weakSelf showEmptyViewWithImage:[UIImage imageNamed:@"wufalianjie"] text:showText detailText:@"别紧张，试试看刷新页面~" buttonTitle:@"     重试     " buttonAction:@selector(getSelectedFriends)];
            [weakSelf setCNAPIErrorEmptyView];
            weakSelf.emptyView.frame = CGRectMake(0, kNavigationBarHeight, KScreenWidth, KScreenHeight - kNavigationBarHeight);
            weakSelf.emptyView.backgroundColor = [UIColor whiteColor];
            
            
        }else {
            
            /** 有网络 */
            if (weakSelf.emptyView) {
                [weakSelf hideEmptyView];
            }
            
            NSDictionary *dataDic = data;
            NSMutableArray *sidArr  = [NSMutableArray array];
            if ([dataDic containsObjectForKey:@"sids"]) {
                sidArr = dataDic[@"sids"];
            }
            
            weakSelf.existedFriends = sidArr;
            [weakSelf loadData];
            
        }
        
        
    }];
    
}


- (void)loadData {
    
    IMASubGroup *subGroup = [[[[IMAPlatform sharedInstance].contactMgr subGroupList] safeArray] objectAtIndex:0];
    
    self.totalArr = [NSMutableArray arrayWithArray:[subGroup.friends safeArray]] ;
    
    for (IMAUser *user in self.totalArr) {
        NSLog(@"nickName = %@",user.nickName);
        
    }
    //把自己加入通讯录
    IMAHost *host = [IMAPlatform sharedInstance].host;
    //如果先把自己移除掉
    [self.totalArr removeObject:host];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (IMAUser *user in self.totalArr) {
        
        user.isSelected = NO;
        
        [self.existedFriends enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj isEqualToString:user.userId]) {
                user.isInvate = YES;
                *stop = YES;
            }else {
                user.isInvate = NO;
            }
            
        }];
        
        NSLog(@"输出是否邀请过 = %ld",user.isInvate);
        [tempArray addObject:user];
        
    }
    self.totalArr = tempArray;
    
    NSDictionary *dict = [BAKit_LocalizedIndexedCollation ba_localizedWithDataArray:self.totalArr localizedNameSEL:@selector(sortName)];
    
    self.sectionArr     = dict[kBALocalizedIndexArrayKey];
    self.rowArr         = dict[kBALocalizedGroupArrayKey];
    
    [self.tableView reloadData];
    
}



#pragma mark - 事件实现
- (void)nextBtnAction:(UIButton *)sender {
    
    if (self.selectedFriends.count < 0) {
        return;
    }
    
    NSLog(@"输出内容,准备邀请");
    
    NSString *familyId = [NSString stringWithFormat:@"%@",self.familyID ?: @""];
    [QMUITips showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    [CNLiveVoiceBoxModelHelper getSetRoleListWithFamilyId:familyId completerBlick:^(id  _Nonnull data, NSError * _Nonnull error) {
        [QMUITips hideAllTipsInView:weakSelf.view];
        
        if (error) {
            [QMUITips showWithText:@"获取角色列表失败" inView:self.view hideAfterDelay:0.5];
        }else {
            NSDictionary *contentDic = data;
            NSMutableArray *familyTypes = [NSMutableArray array];
            if ([contentDic containsObjectForKey:@"roleList"]) {
                NSMutableArray *roleList = contentDic[@"roleList"];
                [roleList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary *dic = obj;
                    [familyTypes addObject:dic];
                    
                }];
            }
            
            if (familyTypes.count == 0) {
                [QMUITips showWithText:@"无角色列表" inView:self.view hideAfterDelay:0.5];
                return;
            }
            CNBOXInviteFriendsController *inviteVC = [[CNBOXInviteFriendsController alloc]init];
            inviteVC.inviteFriendsArr = self.selectedFriends;
            inviteVC.familyTypeArr = familyTypes;
            inviteVC.familyID = [NSString stringWithFormat:@"%@",self.familyID ?: @""];
            [[AppDelegate sharedAppDelegate] pushViewController:inviteVC];
        }
        
    }];
    
    
}


#pragma mark - Tap
- (void)tapMaskView {
    _searchStatusActive = NO;
    _maskView.hidden = YES;
    [self.searchBar resignFirstResponder];
    [self.tableView reloadData];
}

- (void)setSearchStatusActive:(BOOL)searchStatusActive {
    _searchStatusActive = searchStatusActive;
    if (_searchStatusActive) {
        
    }else {
        self.tableView.frame = CGRectMake(0, kNavigationBarHeight + 55, KScreenWidth, KScreenHeight - 55 - 96 - kNavigationBarHeight);
        self.nextBtn.frame = CGRectMake((KScreenWidth - 275)/2, self.tableView.bottom +20, 275, 45);
    }
}


#pragma mark - Getter
- (CNSearch *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[CNSearch alloc] initWithFrame:CGRectZero];
        _searchBar.placeholder = @"搜索";
        _searchBar.delegate = self;
        
        
        if (@available(iOS 13.0, *)) {
            for (UIView *view in _searchBar.subviews.lastObject.subviews) {
                if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                    view.layer.contents = nil;
                    break;
                }
            }
            
        }else {
            
            //修改背景色，并移除灰色view
            UIView *firstSubView = _searchBar.subviews.firstObject;
            firstSubView.backgroundColor = RGBACOLOR(242, 242, 242, 1);
            UIView *backgroundImageView = [firstSubView.subviews firstObject];
            [backgroundImageView removeFromSuperview];
            
        }
        
    }
    return _searchBar;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[CNContactHeaderView class] forHeaderFooterViewReuseIdentifier:@"CNContactHeaderView"];
        [_tableView registerClass:[CNLiveBoxSelectFirendsCell class] forCellReuseIdentifier:kCNLiveBoxSelectFirendsCell];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.layer.masksToBounds = YES;
        _nextBtn.enabled = NO;
        _nextBtn.layer.cornerRadius = 22;
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _nextBtn.backgroundColor = RGBCOLOR(200, 200, 200);
    }
    return _nextBtn;
    
}

- (UIView *)maskView
{
    if (!_maskView) {
        NSInteger searchBarH = 55;
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight + searchBarH, KScreenWidth, KScreenHeight-kNavigationBarHeight-searchBarH)];
        _maskView.hidden = YES;
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = _maskView.bounds;
        [_maskView addSubview:effectView];
        
        _noneLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 50, KScreenWidth-60, 20)];
        _noneLab.textAlignment = NSTextAlignmentCenter;
        _noneLab.text = @"暂无标签";
        _noneLab.textColor = KTextBlackColor;
        _noneLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [_maskView addSubview:_noneLab];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMaskView)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}


- (NSMutableArray *)searchResultArr
{
    if (!_searchResultArr) {
        _searchResultArr = [[NSMutableArray alloc] init];
    }
    return _searchResultArr;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
