//
//  CNLiveBoxInstructionsController.m
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/9/18.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import "CNLiveBoxInstructionsController.h"
#import "CNLiveBoxInstructionsCell.h"

@interface CNLiveBoxInstructionsController ()<UITableViewDelegate,UITableViewDataSource>

/*** 列表 ***/
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation CNLiveBoxInstructionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设备说明";
    
    [self setupUI];
    [self layoutUI];
    
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    }else {
        self.tableView.frame = CGRectMake(0, kNavigationBarHeight, KScreenWidth, KScreenHeight);
    }
    
}

- (void)layoutUI {
    
    __weak typeof(self) weakSelf = self;
    
}


#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CNLiveBoxInstructionsCell *cell = [tableView dequeueReusableCellWithIdentifier:kCNLiveBoxInstructionsCell forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.contentL.text = @"按键图示说明";
        cell.contentImg.image = [UIImage imageNamed:@"device_keys"];
        
    }else {
        cell.contentL.text = @"环形灯效果说明";
        cell.contentImg.image = [UIImage imageNamed:@"device_instructionsTip"];
        
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 400;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    
}

#pragma mark - 属性
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[CNLiveBoxInstructionsCell class] forCellReuseIdentifier:kCNLiveBoxInstructionsCell];
        [_tableView setBackgroundColor:RGBACOLOR(242, 242, 242, 1)];
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        _tableView.tableFooterView = footerView;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}



@end
