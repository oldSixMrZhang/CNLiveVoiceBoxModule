//
//  CNBoxCodeCardInviteController.m
//  CNLiveNetAdd
//
//  Created by 梁星国 on 2019/10/14.
//  Copyright © 2019 cnlive. All rights reserved.
//

#import "CNBoxCodeCardInviteController.h"

@interface CNBoxCodeCardInviteController ()

@property (strong, nonatomic) UIView *shareContentV;
@property (strong, nonatomic) UIImageView *QRShareImgV;
@property (strong, nonatomic) UIImageView *userImgV;
@property (strong, nonatomic) UILabel *userNameL;
@property (strong, nonatomic) UILabel *roleTipL;
@property (strong, nonatomic) UIImageView *qrCodeImgV;
/*** 二维码背景图 ***/
@property (strong, nonatomic)UIImageView *QRCodeBackImg;

/*** 提示 ***/
@property (strong, nonatomic) UIView * firstContentV;
@property (strong, nonatomic) UIView * secondContentV;
@property (strong, nonatomic) UIView * thirdContentV;

@property (strong, nonatomic) UILabel *qrCodeTipL;

@property (strong, nonatomic) UILabel *saveTipL;


@property (strong, nonatomic) UIButton *shareFamilyBtn;


@end

@implementation CNBoxCodeCardInviteController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setupUI];
    [self layoutUI];
    
    self.qrCodeImgV.image = self.QRImage;
    
}

- (void)setupUI {
    [self.view addSubview:self.shareContentV];
    [self.shareContentV addSubview:self.QRShareImgV];
    [self.shareContentV addSubview:self.userImgV];
    [self.shareContentV addSubview:self.userNameL];
    [self.shareContentV addSubview:self.roleTipL];
    [self.shareContentV addSubview:self.QRCodeBackImg];
    [self.shareContentV addSubview:self.qrCodeImgV];
    [self.shareContentV addSubview:self.firstContentV];
    [self.shareContentV addSubview:self.secondContentV];
    [self.shareContentV addSubview:self.thirdContentV];
    [self.shareContentV addSubview:self.qrCodeTipL];
    [self.shareContentV addSubview:self.roleTipL];
    [self.shareContentV addSubview:self.saveTipL];
    
    [self.view addSubview:self.shareFamilyBtn];
    
}

- (void)layoutUI {
    
    self.shareContentV.frame = CGRectMake(20, 13 + kNavigationBarHeight, KScreenWidth - 40, KScreenHeight  - 13 - 60 - kNavigationBarHeight);
    self.QRShareImgV.frame = CGRectMake(0, 0, self.shareContentV.width, self.shareContentV.height);
    
    self.userImgV.frame = CGRectMake(76, 20, 37, 37);
    self.userNameL.frame = CGRectMake(self.userImgV.right + 10, self.userImgV.centerY - 8, self.shareContentV.width - 133, 16);
    self.roleTipL.frame = CGRectMake(0, self.userImgV.bottom + 16, self.shareContentV.width, 24);
    self.QRCodeBackImg.frame = CGRectMake((self.shareContentV.width - 170)/2, self.roleTipL.bottom + 16, 170, 170);
    self.qrCodeImgV.frame = CGRectMake((self.shareContentV.width - 166)/2, self.roleTipL.bottom + 18, 166, 166);
    self.secondContentV.frame = CGRectMake((self.shareContentV.width - 75)/2, self.qrCodeImgV.bottom +18, 90, 15);
    self.firstContentV.frame = CGRectMake(self.secondContentV.left - 100, self.qrCodeImgV.bottom +18, 100, 15);
    self.thirdContentV.frame = CGRectMake(self.secondContentV.right , self.qrCodeImgV.bottom +18, 100, 15);
    self.qrCodeTipL.frame = CGRectMake(10, self.secondContentV.bottom + 15, self.shareContentV.width - 20, 16);
    self.saveTipL.frame = CGRectMake(10, self.shareContentV.height - 25, self.shareContentV.width - 20, 16);
    
    self.shareFamilyBtn.frame = CGRectMake((KScreenWidth - 119)/2, KScreenHeight  - 45, 119, 30);
    
}

#pragma mark - 实现
- (void)shareFamilyBtnAction:(UIButton *)btn {
    
    UIImage *image = [self drawView:self.shareContentV];
    NSArray *imageArray = @[@"sport_china_download"].copy;
    NSArray *titleArray = @[@"保存"].copy;
    __weak typeof(self) weakSelf = self;
    [CNLiveShareManager showShareViewWithParamForShareTitle:nil ShareUrl:nil ShareDesc:nil ShareImage:image ScreenFull:NO HiddenWjj:NO HiddenQQ:NO HiddenWB:NO HiddenWechat:NO HiddenSafari:YES TopImage:imageArray TopTitles:titleArray PlatformType:CNLiveSharePlatformTypeAll TouchActionBlock:^(NSString *title) {
           
        [QMUITips showLoadingInView:weakSelf.view];
        [weakSelf writeLocationWithImage:image];
        [QMUITips hideAllTipsInView:weakSelf.view];
        [QMUITips showInfo:@"下载成功" inView:weakSelf.view hideAfterDelay:0.5];
           
    } CompleterBlock:^(CNLiveShareResultType resultType, CNLiveSharePlatformType platformType, NSString *typtString) {
           
           
           
    }];
    
}

#pragma mark - 私有方法
- (UIImage *)drawView:(UIView *)view {
    CGSize size = view.frame.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(size, YES, scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)writeLocationWithImage:(UIImage *)image {
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //1,保存图片到系统相册
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (!success) return ;
        NSLog(@"保存成功");
        
    }];
    
}



#pragma mark - 属性

- (UIView *)shareContentV {
    if (!_shareContentV) {
        _shareContentV = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _shareContentV;
}

- (UIImageView *)QRCodeBackImg {
    if (!_QRCodeBackImg) {
        _QRCodeBackImg = [[UIImageView alloc]initWithFrame:CGRectZero];
        
        _QRCodeBackImg.image = [UIImage imageNamed:@"device_QRCodeEdge"];
    }
    return _QRCodeBackImg;
}

- (UIImageView *)QRShareImgV {
    if (!_QRShareImgV) {
        _QRShareImgV = [[UIImageView alloc]initWithFrame:CGRectZero];
        _QRShareImgV.image = [UIImage imageNamed:@"device_box_QRCodeImg"];
        
    }
    return _QRShareImgV;
}

- (UIImageView *)userImgV {
    if (!_userImgV) {
        _userImgV = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_userImgV sd_setImageWithURL:[NSURL URLWithString:CNUserShareModel.faceUrl] placeholderImage:kDefaultUserIcon];
    }
    return _userImgV;
}

- (UILabel *)userNameL {
    if (!_userNameL) {
        _userNameL = [[UILabel alloc] initWithFrame:CGRectZero];
        NSString *string  = [NSString stringWithFormat:@"%@ %@",CNUserShareModel.nickname,@"邀请你"];

        NSMutableAttributedString *attri =  [[NSMutableAttributedString alloc] initWithString:string];
        // 修改富文本中的不同文字的样式
        [attri addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(40, 40, 40) range:[string rangeOfString:CNUserShareModel.nickname]];
        [attri addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(255, 255, 255) range:[string rangeOfString:@"邀请你"]];
        _userNameL.attributedText = attri;
        _userNameL.font = [UIFont systemFontOfSize:15];
        
        
    }
    return _userNameL;
}

- (UILabel *)roleTipL {
    if (!_roleTipL) {
        _roleTipL = [[UILabel alloc] initWithFrame:CGRectZero];
        _roleTipL.textColor = [UIColor whiteColor];
        _roleTipL.font = [UIFont boldSystemFontOfSize:24];
        _roleTipL.textAlignment = NSTextAlignmentCenter;
        _roleTipL.text = @"扫码和他(她)绑定亲情关系";
    }
    return _roleTipL;
}

- (UIImageView *)qrCodeImgV {
    if (!_qrCodeImgV) {
        _qrCodeImgV = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    return _qrCodeImgV;
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

- (UILabel *)qrCodeTipL {
    if (!_qrCodeTipL) {
        _qrCodeTipL = [[UILabel alloc]initWithFrame:CGRectZero];
        _qrCodeTipL.text = @"已安装网家家，请直接登录扫码";
        _qrCodeTipL.font = [UIFont systemFontOfSize:15];
        _qrCodeTipL.textAlignment = NSTextAlignmentCenter;
    }
    return _qrCodeTipL;
}

- (UILabel *)saveTipL {
    if (!_saveTipL) {
        _saveTipL = [[UILabel alloc]initWithFrame:CGRectZero];
        _saveTipL.font = [UIFont systemFontOfSize:15];
        _saveTipL.textAlignment = NSTextAlignmentCenter;
        _saveTipL.text = @"- 保存图片用网家家扫码 -";
    }
    return _saveTipL;
}

- (UIButton *)shareFamilyBtn {
    if (!_shareFamilyBtn) {
        _shareFamilyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareFamilyBtn.layer.masksToBounds = YES;
        _shareFamilyBtn.layer.cornerRadius = 15;
        [_shareFamilyBtn setTitle:@"分享给家人" forState:UIControlStateNormal];
        [_shareFamilyBtn setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
        _shareFamilyBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_shareFamilyBtn addTarget:self action:@selector(shareFamilyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _shareFamilyBtn.backgroundColor = RGBCOLOR(35, 212, 30);
    }
    return _shareFamilyBtn;
    
}



@end
