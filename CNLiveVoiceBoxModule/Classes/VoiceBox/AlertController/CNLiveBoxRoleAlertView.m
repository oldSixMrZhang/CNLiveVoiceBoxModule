//
//  CNLiveBoxRoleAlertView.m
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/10/15.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import "CNLiveBoxRoleAlertView.h"
#import "CNBOXInviteCollectionViewCell.h"


@interface CNLiveBoxRoleAlertView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIView *showView;


@end

@implementation CNLiveBoxRoleAlertView

//提示
+ (CNLiveBoxRoleAlertView *)showAlertAddedTo:(UIView *)view{
    
    CNLiveBoxRoleAlertView *alertView = [[CNLiveBoxRoleAlertView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [view addSubview:alertView];
    alertView.alpha = 0.5;
    alertView.showView = view;
    
    return alertView;
}

- (void)showAlerView {
    
    self.alpha = 0.5;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
        self.contentView.frame = CGRectMake((KScreenWidth - 280)/2, (KScreenHeight - 336)/2, 280, 336);
    }];
}

- (void)hiddenAlerView {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.5;
        [self removeFromSuperview];
    }];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBACOLOR(51, 51, 51, 0.3);
        
        [self setupUI];
        [self layoutUI];
        
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.tipL];
    [self.contentView addSubview:self.lineV];
    [self.contentView addSubview:self.userImgV];
    [self.contentView addSubview:self.userNameL];
    [self.contentView addSubview:self.collectionV];
    [self.contentView addSubview:self.cancleBtn];
    [self.contentView addSubview:self.sureBtn];
    [self.contentView addSubview:self.horizontalLine];
    [self.contentView addSubview:self.verticalLine];
    
}

- (void)layoutUI {
    
    self.contentView.frame = CGRectMake((KScreenWidth - 280)/2, (KScreenHeight - 336)/2  + 200, 280, 336);
    
    self.tipL.frame = CGRectMake(24, 24, 280 - 48, 20);
    self.lineV.frame = CGRectMake(24, self.tipL.bottom + 23, 280 - 48, 0.5);
    self.userImgV.frame = CGRectMake(56, self.lineV.bottom + 16, 40, 40);
    self.userNameL.frame = CGRectMake(self.userImgV.right + 12, self.userImgV.centerY - 9, 280 - (self.userImgV.right + 12) - 24, 18);
    self.collectionV.frame = CGRectMake(10, self.userImgV.bottom + 6, 280 - 20, 155);
    self.horizontalLine.frame = CGRectMake(0, 336 - 44, 280, 0.5);
    self.verticalLine.frame = CGRectMake(280/2, 336 - 44, 0.5, 44);
    self.cancleBtn.frame = CGRectMake(0, 336 - 43, 278/2, 43);
    self.sureBtn.frame = CGRectMake(282/2, 336 - 43,  278/2, 43);
    
}

#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CNBOXInviteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCNBOXInviteCollectionViewCell forIndexPath:indexPath];
    CNLiveBoxRoleModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell eidtBOXUIWithModel:model];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CNLiveBoxRoleModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if ([model.allowUse isEqualToString:@"0"]) {
        return;
    }
    
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CNLiveBoxRoleModel *model = obj;
        if ([model.allowUse isEqualToString:@"1"]) {
            if ([model.isSelect isEqualToString:@"1"]) {
                model.isSelect = @"0";
            }
        }
       
    }];
    
   
    if ([model.allowUse isEqualToString:@"1"]) {
        model.isSelect = @"1";
       
    }else {
        
    }
    
    self.selectRole = model.ID;
    self.selectRoleName = model.roleName;
    
    [self.collectionV reloadData];
    
    
}


#pragma mark - 实现
- (void)cancleBtnAction:(UIButton *)sender {
    [self hiddenAlerView];
}

- (void)sureBtnAction:(UIButton *)sender {
    
    NSLog(@"输出内容");
    
    if (self.clickSureBtnBlock) {
        self.clickSureBtnBlock(self, sender);
    }
    
    [self hiddenAlerView];
}

#pragma mark - 属性

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    [self.collectionV reloadData];
}

- (void)setBoxUserModel:(CNBoxUserModel *)boxUserModel {
    
    if (!boxUserModel) {
        return;
    }
    
    _boxUserModel = boxUserModel;
    if (boxUserModel.userMsg) {
        NSString *userImgStr = [NSString stringWithFormat:@"%@",boxUserModel.userMsg.image];
        [self.userImgV sd_setImageWithURL:[NSURL URLWithString:userImgStr] placeholderImage:kDefaultUserIcon];
        self.userNameL.text = [NSString stringWithFormat:@"%@",boxUserModel.userMsg.nickName];
    }
    self.selectRoleName = [NSString stringWithFormat:@"%@",boxUserModel.roleName ?: @""];
    self.selectRole = [NSString stringWithFormat:@"%@",boxUserModel.roleId ?: @""];
    
    if (self.dataArray) {
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CNLiveBoxRoleModel *roleModel = obj;
            if ([roleModel.allowUse isEqualToString:@"0"]) {
                if ([roleModel.ID isEqualToString:boxUserModel.roleId]) {
                    roleModel.isSelect = @"1";
                    roleModel.allowUse = @"1";
                }
            }else {
                if ([roleModel.ID isEqualToString:boxUserModel.roleId]) {
                    roleModel.isSelect = @"1";
                }else {
                    roleModel.isSelect = @"0";
                }
                
            }
            
        }];
    }
    
   [self.collectionV reloadData];
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectZero];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 15;
    }
    return _contentView;
}

- (UILabel *)tipL {
    if (!_tipL) {
        _tipL = [[UILabel alloc]initWithFrame:CGRectZero];
        _tipL.font = [UIFont systemFontOfSize:20];
        _tipL.text = @"编辑角色";
        _tipL.textAlignment = NSTextAlignmentCenter;
    }
    return _tipL;
}

- (UIView *)lineV {
    if (!_lineV) {
        _lineV = [[UIView alloc]initWithFrame:CGRectZero];
        [_lineV setBackgroundColor:RGBCOLOR(199, 199, 199)];
    }
    return _lineV;
}

- (UIImageView *)userImgV {
    if (!_userImgV) {
        _userImgV = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    return _userImgV;
}

- (UILabel *)userNameL {
    if (!_userNameL) {
        _userNameL = [[UILabel alloc]initWithFrame:CGRectZero];
        _userNameL.textColor = [UIColor blackColor];
        _userNameL.font = [UIFont systemFontOfSize:17];
    }
    return _userNameL;
}


- (UICollectionView *)collectionV {
    if (!_collectionV) {
        
        UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc]init];
        // 最小行间距，默认是0
        layout.minimumLineSpacing = 10;
        // 最小左右间距，默认是10
        layout.minimumInteritemSpacing = 27;
        // 区域内间距，默认是 UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSizeMake((280 - 20 - 3*27)/3, 24);
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _collectionV = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionV.backgroundColor = [UIColor whiteColor];
        [_collectionV registerClass:[CNBOXInviteCollectionViewCell class] forCellWithReuseIdentifier:kCNBOXInviteCollectionViewCell];
        _collectionV.delegate = self;
        _collectionV.dataSource = self;
        _collectionV.scrollEnabled = NO;
    
    }
    return _collectionV;
    
}

- (UIView *)horizontalLine {
    
    if (!_horizontalLine) {
        _horizontalLine = [[UIView alloc]initWithFrame:CGRectZero];
        [_horizontalLine setBackgroundColor:RGBCOLOR(199, 199, 199)];
    }
    return _horizontalLine;
}

- (UIView *)verticalLine {
    
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc]initWithFrame:CGRectZero];
        [_verticalLine setBackgroundColor:RGBCOLOR(199, 199, 199)];
    }
    return _verticalLine;
    
}

- (UIButton *)cancleBtn {
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleBtn setTitleColor:RGBCOLOR(153, 153, 153) forState:UIControlStateNormal];
        _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _cancleBtn.backgroundColor = [UIColor clearColor];
        [_cancleBtn addTarget:self action:@selector(cancleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
    
}


- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:RGBCOLOR(11, 190, 6) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _sureBtn.backgroundColor = [UIColor clearColor];
        [_sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //获取手指触摸view是的任意一个触摸对象
    UITouch * touch = [touches anyObject];
    //获取是手指触摸的view
    UIView *view = [touch view];
    if ([view isEqual:self]) {
        [self hiddenAlerView];
    }
    
    
}


@end
