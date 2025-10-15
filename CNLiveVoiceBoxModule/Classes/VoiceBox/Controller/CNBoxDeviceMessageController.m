//
//  CNBoxDeviceMessageController.m
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/10/9.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import "CNBoxDeviceMessageController.h"
#import "CNLiveDeviceManagerCell.h"

@interface CNBoxDeviceMessageController ()<UITableViewDelegate,UITableViewDataSource>

/*** 列表 ***/
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation CNBoxDeviceMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"设备信息";
    [self setupUI];
    [self layoutUI];
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    }else {
        self.tableView.frame = CGRectMake(0, kNavigationBarHeight, KScreenWidth, KScreenHeight - kNavigationBarHeight);
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CNLiveDeviceMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:kCNLiveDeviceMessageCell forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        if (self.detailModel) {
            cell.contentL.text = [NSString stringWithFormat:@"%@",self.detailModel.iP ?: @""];
        }
        cell.nameL.text = @"IP地址";
        
    }else if (indexPath.row == 1) {
        cell.nameL.text = @"设备Mac地址";
        if (self.detailModel) {
            cell.contentL.text = [NSString stringWithFormat:@"%@",self.detailModel.mAC ?: @""];
        }
    }else if (indexPath.row == 2) {
        cell.nameL.text = @"SN号";
         if (self.detailModel) {
             cell.contentL.text = [NSString stringWithFormat:@"%@",self.detailModel.sN ?: @""];;
         }
    }
          
    return cell;
          
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section > 3) {
        return 91;
    }
    return 61;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    

}



#pragma mark - 属性
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[CNLiveDeviceMessageCell class] forCellReuseIdentifier:kCNLiveDeviceMessageCell];
        [_tableView setBackgroundColor:RGBACOLOR(242, 242, 242, 1)];
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView = footerView;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


@end
