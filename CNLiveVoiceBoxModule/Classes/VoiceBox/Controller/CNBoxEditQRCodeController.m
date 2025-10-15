//
//  CNBoxEditQRCodeController.m
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/10/9.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import "CNBoxEditQRCodeController.h"
#import "CNBOXInviteCollectionViewCell.h"
#import "CNBoxCodeCardInviteController.h"
#import "CNGroupActiveViewModel.h"
#import "SGQRCodeGenerateManager.h"
#import "CNLiveVoiceBoxModelHelper.h"

@interface CNBoxEditQRCodeController ()<UICollectionViewDelegate,UICollectionViewDataSource>


/*** 盒子名字 ***/
@property (strong, nonatomic) UILabel *familTipL;

/*** 家庭列表 ***/
@property (strong, nonatomic) UICollectionView *collectionV;

/*** 选择家人角色二维码Img ***/
@property (strong, nonatomic)UIImageView *QRCodeImg;

/*** 二维码背景图 ***/
@property (strong, nonatomic)UIImageView *QRCodeBackImg;

/*** 二维码提示图 ***/
@property (strong, nonatomic)UILabel *showTextL;

/*** tip ***/
@property (strong, nonatomic) UILabel *showTip;

/*** 提示 ***/
@property (strong, nonatomic) UIView * firstContentV;

@property (strong, nonatomic) UIView *secondContentV;

@property (strong, nonatomic) UIView *thirdContentV;

/*** 保存并分享家人 ***/
@property (nonatomic, strong) UIButton *saveBtn;

/*** 数据 ***/
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) CNLiveBoxRoleModel *selectModel;

@end

@implementation CNBoxEditQRCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"二维码邀请加入";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.dataArray = [NSMutableArray array];
    
    [self setupUI];
    [self layoutUI];
    [self QRCodeInviteLoad];
    
}

- (void)setupUI {
    
    [self.view addSubview:self.familTipL];
    [self.view addSubview:self.collectionV];
    [self.view addSubview:self.QRCodeImg];
    [self.QRCodeImg addSubview:self.QRCodeBackImg];
    [self.QRCodeImg addSubview:self.showTextL];
    [self.view addSubview:self.showTip];
    [self.view addSubview:self.firstContentV];
    [self.view addSubview:self.secondContentV];
    [self.view addSubview:self.thirdContentV];
    [self.view addSubview:self.saveBtn];
    
    
}

- (void)layoutUI {
    self.familTipL.frame = CGRectMake(24, 12, KScreenWidth-48, 15);
    CGFloat height = 0;
    NSInteger remainder = self.familyTypeArr.count % 4;
    NSInteger count = self.familyTypeArr.count /4;
    if (remainder >0) {
        count ++;
    }
    height += count *24 + (count + 1)*10;
    self.collectionV.frame = CGRectMake(10,kNavigationBarHeight + self.familTipL.bottom +5, KScreenWidth - 20, height);
    
    self.QRCodeImg.frame = CGRectMake((KScreenWidth - 200)/2, self.collectionV.bottom +20, 200, 200);
    self.QRCodeBackImg.frame =  CGRectMake(0, 0, 202, 202);
    self.showTextL.frame = CGRectMake(0, 0, 200, 200);
    
    self.showTip.frame = CGRectMake(10, self.QRCodeImg.bottom +35, KScreenWidth - 20, 18);
    self.secondContentV.frame = CGRectMake((KScreenWidth - 75)/2, self.showTip.bottom +20, 90, 15);
    self.firstContentV.frame = CGRectMake(self.secondContentV.left - 100, self.showTip.bottom +20, 100, 15);
    self.thirdContentV.frame = CGRectMake(self.secondContentV.right , self.showTip.bottom +20, 100, 15);
    
    self.saveBtn.frame = CGRectMake((KScreenWidth - 275)/2, self.view.bottom -74, 275, 44);
    
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
    if (model) {
        [cell eidtUIWithQRCode:model];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CNLiveBoxRoleModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if ([model.allowUse isEqualToString:@"1"]) {
        if ([model.isSelect isEqualToString:@"1"]) {
            return;
        }
       
    }else{//不可寻啊啊
        return;
    }
    
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CNLiveBoxRoleModel *roleModel = obj;
        if ([roleModel.allowUse isEqualToString:@"1"]) {
            roleModel.isSelect = @"0";
        }
        
    }];
    
    if ([model.allowUse isEqualToString:@"1"]) {
        model.isSelect = @"1";
        self.selectModel = model;
    }else {
        
    }
    
    [self.collectionV reloadData];
    
    
    [self addQRCodeWithModel:model];
    
    if (self.selectModel) {
        self.saveBtn.enabled = YES;
        self.saveBtn.backgroundColor = RGBCOLOR(35, 212, 30);
    }
    
}


/*** 进入邀请我二维码界面 ***/
- (void)QRCodeInviteLoad {
    
    NSString *familyId = [NSString stringWithFormat:@"%@",self.familyID ?: @""];
    [QMUITips showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    [CNLiveVoiceBoxModelHelper getSetRoleListWithFamilyId:familyId completerBlick:^(id  _Nonnull data, NSError * _Nonnull error) {
        [QMUITips hideAllTipsInView:weakSelf.view];
        
        if (error) {
            NSString *showText = @"网络连接失败，请稍后再试";
            if (error.code == -1001 || error.code == -1009) {//没有网络
                
            }else {
                showText = @"请求失败,请重试";
            }
            
            [weakSelf showEmptyViewWithImage:[UIImage imageNamed:@"wufalianjie"] text:showText detailText:@"别紧张，试试看刷新页面~" buttonTitle:@"     重试     " buttonAction:@selector(QRCodeInviteLoad)];
            [weakSelf setCNAPIErrorEmptyView];
            weakSelf.emptyView.frame = CGRectMake(0, kNavigationBarHeight, KScreenWidth, KScreenHeight - kNavigationBarHeight);
            weakSelf.emptyView.backgroundColor = [UIColor whiteColor];
        }else {
            /** 有网络 */
            if (weakSelf.emptyView) {
                [weakSelf hideEmptyView];
            }
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
            weakSelf.familyTypeArr = familyTypes;
            weakSelf.dataArray = [NSMutableArray array];
            NSMutableArray *dataArr = [NSMutableArray array];
            [weakSelf.familyTypeArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = obj;
                CNLiveBoxRoleModel *model = [CNLiveBoxRoleModel mj_objectWithKeyValues:dic];
                model.isSelect = @"0";
                model.isCurrentUse = @"1";
                [dataArr addObject:model];
            }];
            weakSelf.dataArray = dataArr;
            [weakSelf.collectionV reloadData];
            [weakSelf layoutUI];
            
        }
        
    }];
    
}


- (void)addQRCodeWithModel:(CNLiveBoxRoleModel *)model {
    [QMUITips showLoadingInView:self.view];
    __weak typeof(self) weakSelf = self;
    [[CNGroupActiveViewModel sharedCNGroupActiveViewModel] requestServerForDownloadAppActionUrlSourceCompleterBlock:^(NSString *shareUrl) {
        [QMUITips hideAllTipsInView:weakSelf.view];
        
        //    http://wjjh5.cnlive.com/apkdownload.html?channelName=530
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *roleID = [NSString stringWithFormat:@"%@",model.ID];
        NSString *familyIdStr = [NSString stringWithFormat:@"%@",self.familyID ?: @""];
        NSString *UUIDStr = [self getUniqueStrByUUID];
        UUIDStr = [UUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        [dic setValue:roleID forKey:@"roleId"];
        [dic setValue:familyIdStr forKey:@"familyId"];
        [dic setValue:UUIDStr forKey:@"uuid"];
        
        
        NSString *xiajiaContentStr = [dic mj_JSONString];
        NSString *type = @"xiaoJiaSpeakerType";
        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
        long time = [date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
        NSString *currentTime = [NSString stringWithFormat:@"%ld",time];
        
        NSString * wjjQr = [EncryptAndDecrypt base64StringFromText:[@{@"xiajiaContent":xiajiaContentStr,@"type":type,@"time":currentTime} mj_JSONString] encryptKey:@"cnliveIm"];
        NSString *shareUrlStr = [NSString stringWithFormat:@"%@wjjQrSkipType=wjjQrXiaojiaBoxType&isWjjQr=%@",shareUrl,wjjQr];
        
        NSString *qrCode = shareUrlStr;
        
        UIImage *qrImage = [SGQRCodeGenerateManager generateWithLogoQRCodeData:qrCode logoImageName:@"ewm_lcon" logoScaleToSuperView:0.2];;
        if (qrImage) {
            weakSelf.QRCodeImg.image = qrImage;
            weakSelf.showTextL.hidden = YES;
        }
        
        
    }];
}


- (NSString *)getUniqueStrByUUID
{
    CFUUIDRef uuidObj = CFUUIDCreate(nil);//create a new UUID
    
    //get the string representation of the UUID
    CFStringRef uuidString = CFUUIDCreateString(nil, uuidObj);
    
    NSString *str = [NSString stringWithString:(__bridge NSString *)uuidString];
    
    CFRelease(uuidObj);
    CFRelease(uuidString);
    
    return [str lowercaseString];
}


#pragma mark - 实现
- (void)saveBtnAction:(UIButton *)sender {
    
    if (!self.selectModel) {
        return;
    }
    
    if (!self.QRCodeImg.image) {
        return;
    }
    
    CNBoxCodeCardInviteController *boxCodeCardInviteVC = [[CNBoxCodeCardInviteController alloc]init];
    boxCodeCardInviteVC.QRImage = self.QRCodeImg.image;
    [[AppDelegate sharedAppDelegate] pushViewController:boxCodeCardInviteVC];
    
    
}

#pragma mark - 属性

- (UILabel *)familTipL {
    if (!_familTipL) {
        _familTipL = [[UILabel alloc]initWithFrame:CGRectZero];
        _familTipL.font = [UIFont systemFontOfSize:16];
        _familTipL.text = @"选择家人角色";
        _familTipL.textAlignment = NSTextAlignmentLeft;
        
    }
    return _familTipL;
}

- (UICollectionView *)collectionV {
    if (!_collectionV) {
        
        UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc]init];
        // 最小行间距，默认是0
        layout.minimumLineSpacing = 10;
        // 最小左右间距，默认是10
        layout.minimumInteritemSpacing = 27;
        // 区域内间距，默认是 UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSizeMake((KScreenWidth - 40 - 3*27)/4, 24);
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _collectionV = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionV registerClass:[CNBOXInviteCollectionViewCell class] forCellWithReuseIdentifier:kCNBOXInviteCollectionViewCell];
        [_collectionV setBackgroundColor:[UIColor whiteColor]];
        _collectionV.delegate = self;
        _collectionV.dataSource = self;
        _collectionV.scrollEnabled = NO;
        
    }
    return _collectionV;
    
}

- (UIImageView *)QRCodeImg {
    if (!_QRCodeImg) {
        _QRCodeImg = [[UIImageView alloc]initWithFrame:CGRectZero];
        _QRCodeImg.image = [UIImage imageWithColor:RGBCOLOR(225, 249, 215) size:CGSizeMake(200, 200)];
        
    }
    return _QRCodeImg;
}

- (UIImageView *)QRCodeBackImg {
    if (!_QRCodeBackImg) {
        _QRCodeBackImg = [[UIImageView alloc]initWithFrame:CGRectZero];
        
        _QRCodeBackImg.image = [UIImage imageNamed:@"device_QRCodeEdge"];
    }
    return _QRCodeBackImg;
}

- (UILabel *)showTextL {
    if (!_showTextL) {
        _showTextL = [[UILabel alloc]initWithFrame:CGRectZero];
        _showTextL.font = [UIFont systemFontOfSize:16];
        _showTextL.textAlignment = NSTextAlignmentCenter;
        _showTextL.textColor = RGBCOLOR(25, 159, 24);
        _showTextL.text = @"选择家人角色\n生成二维码";
    }
    return _showTextL;
}

- (UILabel *)showTip {
    if (!_showTip) {
        _showTip = [[UILabel alloc]initWithFrame:CGRectZero];
        _showTip.font = [UIFont systemFontOfSize:16];
        _showTip.textAlignment = NSTextAlignmentCenter;
        _showTip.text = @"请对方使用网家家“扫一扫”绑定";
        
    }
    return _showTip;
}

- (UIView *)firstContentV {
    if (!_firstContentV) {
        _firstContentV = [[UIView alloc]initWithFrame:CGRectZero];
        UILabel *countL = [[UILabel alloc]initWithFrame:CGRectZero];
        [_firstContentV addSubview:countL];
        countL.text = @"1";
        countL.font = [UIFont systemFontOfSize:12];
        countL.backgroundColor = RGBCOLOR(25, 159, 24);
        countL.layer.masksToBounds = YES;
        countL.layer.cornerRadius = 7.5;
        countL.textColor = [UIColor whiteColor];
        countL.textAlignment = NSTextAlignmentCenter;
        countL.frame = CGRectMake(0, 0, 15, 15);
        
        UILabel *contentL = [[UILabel alloc]initWithFrame:CGRectZero];
        [_firstContentV addSubview:contentL];
        contentL.text = @"下载网家家 >";
        contentL.font = [UIFont systemFontOfSize:12];
        contentL.textAlignment = NSTextAlignmentLeft;
        contentL.frame = CGRectMake(20, 0, 80, 15);
        
        
    }
    return _firstContentV;
    
}

- (UIView *)secondContentV {
    if (!_secondContentV) {
        _secondContentV = [[UIView alloc]initWithFrame:CGRectZero];
        UILabel *countL = [[UILabel alloc]initWithFrame:CGRectZero];
        [_secondContentV addSubview:countL];
        countL.text = @"2";
        countL.font = [UIFont systemFontOfSize:12];
        countL.backgroundColor = RGBCOLOR(25, 159, 24);
        countL.layer.masksToBounds = YES;
        countL.layer.cornerRadius = 7.5;
        countL.textAlignment = NSTextAlignmentCenter;
        countL.textColor = [UIColor whiteColor];
        countL.frame = CGRectMake(0, 0, 15, 15);
        
        UILabel *contentL = [[UILabel alloc]initWithFrame:CGRectZero];
        [_secondContentV addSubview:contentL];
        contentL.text = @"注册/登录 >";
        contentL.font = [UIFont systemFontOfSize:12];
        contentL.textAlignment = NSTextAlignmentLeft;
        contentL.frame = CGRectMake(20, 0, 80, 15);
        
    }
    return _secondContentV;
    
}

- (UIView *)thirdContentV {
    if (!_thirdContentV) {
        _thirdContentV = [[UIView alloc]initWithFrame:CGRectZero];
        UILabel *countL = [[UILabel alloc]initWithFrame:CGRectZero];
        [_thirdContentV addSubview:countL];
        countL.text = @"3";
        countL.font = [UIFont systemFontOfSize:12];
        countL.backgroundColor = RGBCOLOR(25, 159, 24);
        countL.layer.masksToBounds = YES;
        countL.layer.cornerRadius = 7.5;
        countL.textColor = [UIColor whiteColor];
        countL.textAlignment = NSTextAlignmentCenter;
        countL.frame = CGRectMake(0, 0, 15, 15);
        
        
        UILabel *contentL = [[UILabel alloc]initWithFrame:CGRectZero];
        [_thirdContentV addSubview:contentL];
        contentL.text = @"扫码绑定";
        contentL.font = [UIFont systemFontOfSize:12];
        contentL.textAlignment = NSTextAlignmentLeft;
        contentL.frame = CGRectMake(20, 0, 80, 15);
    }
    return _thirdContentV;
    
}

- (UIButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.layer.masksToBounds = YES;
        _saveBtn.enabled = NO;
        _saveBtn.layer.cornerRadius = 22;
        [_saveBtn setTitle:@"生成二维码海报" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(saveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _saveBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _saveBtn.backgroundColor = RGBCOLOR(200, 200, 200);
    }
    return _saveBtn;
    
}





@end
