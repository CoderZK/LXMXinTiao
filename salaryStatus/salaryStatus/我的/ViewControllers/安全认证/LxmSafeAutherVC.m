//
//  LxmSafeAutherVC.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/28.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmSafeAutherVC.h"
#import "LxmAddCardVC.h"

#import <AssetsLibrary/ALAssetsLibrary.h>
#import "MXPhotoPickerController.h"
#import "UIViewController+MXPhotoPicker.h"

#import <objc/runtime.h>
#import <AipOcrSdk/AipOcrSdk.h>

#import "LxmShiMingRenZhengNextVC.h"

@interface LxmSafeAutherView : UIView

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UITextField *rightTF;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation LxmSafeAutherView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self setConstains];
    }
    return self;
}

/**
 添加子视图
 */
- (void)initSubViews {
    [self addSubview:self.nameLabel];
    [self addSubview:self.rightTF];
    [self addSubview:self.lineView];
}

/**
 设置约束
 */
- (void)setConstains {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.equalTo(@80);
    }];
    [self.rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel.mas_trailing);
        make.trailing.equalTo(self).offset(-15);
        make.top.bottom.equalTo(self);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = CharacterDarkColor;
        _nameLabel.font = [UIFont systemFontOfSize:13];
    }
    return _nameLabel;
}

- (UITextField *)rightTF {
    if (!_rightTF) {
        _rightTF = [[UITextField alloc] init];
        _rightTF.textColor = CharacterDarkColor;
        _rightTF.textAlignment = NSTextAlignmentRight;
        _rightTF.font = [UIFont systemFontOfSize:13];
    }
    return _rightTF;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

@end


//测试
#import "LxmTianJiaBankVC.h"
@interface LxmSafeAutherVC ()

@property (nonatomic, strong) UIView *headerView;//表头视图

@property (nonatomic, strong) UIButton *zhengcardButton;//身份证正面按钮

@property (nonatomic, strong) UIImageView *zhengcardImgView;//身份证正面

@property (nonatomic, strong) UILabel *uploadZhengCardLabel;//上传身份证正面

@property (nonatomic, strong) UIButton *fancardButton;//身份证反面按钮

@property (nonatomic, strong) UIImageView *fancardImgView;//身份证反面

@property (nonatomic, strong) UIButton *fanZhengCardButton;//上传身份证反面

@property (nonatomic, strong) UILabel *uploadfanCardLabel;//上传身份证反面

@property (nonatomic, strong) UIView *bottomView;//底部视图

@property (nonatomic, strong) UIButton *nextbutton;//下一步

@property (nonatomic, strong) NSMutableDictionary *infoDict;//识别出的信息数组
@property (nonatomic, strong) NSMutableDictionary *infoDict1;//识别出的反面信息数组

@property (nonatomic, strong) NSString *zhengStr;//身份证正面id

@property (nonatomic, strong) NSString *fanStr;//身份证反面id

@property (nonatomic, strong) LxmSafeAutherView *nameView;

@property (nonatomic, strong) LxmSafeAutherView *cardView;

@end

@implementation LxmSafeAutherVC

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.shadowColor = MineColor.CGColor;
        _bottomView.layer.shadowOffset = CGSizeZero;
        _bottomView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _bottomView.layer.shadowRadius = 10;//阴影半径，默认3
    }
    return _bottomView;
}

- (UIButton *)nextbutton {
    if (!_nextbutton) {
        _nextbutton = [[UIButton alloc] init];
        [_nextbutton setBackgroundImage:[UIImage imageNamed:@"lightblue"] forState:UIControlStateNormal];
        [_nextbutton setTitle:@"提交" forState:UIControlStateNormal];
        [_nextbutton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _nextbutton.titleLabel.font = [UIFont systemFontOfSize:15];
        _nextbutton.layer.cornerRadius = 5;
        _nextbutton.layer.masksToBounds = YES;
        [_nextbutton addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextbutton;
}

- (NSMutableDictionary *)infoDict {
    if (!_infoDict) {
        _infoDict = [NSMutableDictionary dictionary];
    }
    return _infoDict;
}
- (NSMutableDictionary *)infoDict1 {
    if (!_infoDict1) {
        _infoDict1 = [NSMutableDictionary dictionary];
    }
    return _infoDict1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"安全认证";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[AipOcrService shardService] authWithAK:@"ySBAgMiBBUwvyUL33z6H0Ysf" andSK:@"1KFLxKuC0SH9c2gG0CwmdDgvljaBuxYz"];
    [self initSubViews];
    [self initFootView];
}

/**
 底部View
 */
- (void)initFootView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
    footerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = footerView;
    [footerView addSubview:self.nameView];
    [footerView addSubview:self.cardView];
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(footerView);
        make.height.equalTo(@50);
    }];
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameView.mas_bottom);
        make.leading.trailing.equalTo(footerView);
        make.height.equalTo(@50);
    }];
}

- (LxmSafeAutherView *)nameView {
    if (!_nameView) {
        _nameView = [[LxmSafeAutherView alloc] init];
        _nameView.nameLabel.text = @"姓名";
        _nameView.rightTF.placeholder = @"请输入姓名";
    }
    return _nameView;
}

- (LxmSafeAutherView *)cardView {
    if (!_cardView) {
        _cardView = [[LxmSafeAutherView alloc] init];
        _cardView.nameLabel.text = @"身份证号";
        _cardView.rightTF.placeholder = @"请输入身份证号";
    }
    return _cardView;
}

/**
 初始化
 */
- (void)initSubViews {
    [self.view addSubview:self.bottomView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self.view);
        make.height.equalTo(@100);
    }];
    
    [self.bottomView addSubview:self.nextbutton];
    [self.nextbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bottomView);
        make.width.equalTo(@(ScreenW - 60));
        make.height.equalTo(@50);
    }];
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 450)];
    self.tableView.tableHeaderView = _headerView;
    
    [self.headerView addSubview:self.zhengcardButton];
    [self.zhengcardButton addSubview:self.zhengcardImgView];
    [self.zhengcardButton addSubview:self.uploadZhengCardLabel];
    [self.zhengcardButton bringSubviewToFront:self.uploadZhengCardLabel];
    
    [self.headerView addSubview:self.fancardButton];
    [self.fancardButton addSubview:self.fancardImgView];
    [self.fancardButton addSubview:self.uploadfanCardLabel];
    [self.fancardButton bringSubviewToFront:self.uploadfanCardLabel];
    
    [self setConstrains];
    
}


/**
 设置约束
 */
- (void)setConstrains {
    [self.zhengcardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.headerView).offset(15);
        make.trailing.equalTo(self.headerView).offset(-15);
        make.height.equalTo(@200);
    }];
    [self.zhengcardImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.zhengcardButton);
        make.bottom.equalTo(self.zhengcardButton.mas_bottom).offset(-50);
        make.width.equalTo(@(ScreenW - 30));
    }];
    [self.uploadZhengCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.zhengcardButton);
        make.height.equalTo(@50);
    }];
    
    [self.fancardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zhengcardButton.mas_bottom).offset(15);
        make.leading.equalTo(self.headerView).offset(15);
        make.trailing.equalTo(self.headerView).offset(-15);
        make.height.equalTo(@200);
    }];
    [self.fancardImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.fancardButton);
        make.bottom.equalTo(self.fancardButton.mas_bottom).offset(-50);
        make.width.equalTo(@(ScreenW - 30));
    }];
    [self.uploadfanCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.fancardButton);
        make.height.equalTo(@50);
    }];
}

/**
 初始化子视图
 */
- (UIButton *)zhengcardButton {
    if (!_zhengcardButton) {
        _zhengcardButton = [[UIButton alloc] init];
        [_zhengcardButton addTarget:self action:@selector(uploadClick:) forControlEvents:UIControlEventTouchUpInside];
        [_zhengcardButton setBackgroundImage:[UIImage imageNamed:@"card_zheng"] forState:UIControlStateNormal];
    }
    return _zhengcardButton;
}

- (UIImageView *)zhengcardImgView {
    if (!_zhengcardImgView) {
        _zhengcardImgView = [[UIImageView alloc] init];
        _zhengcardImgView.hidden = YES;
    }
    return _zhengcardImgView;
}

- (UILabel *)uploadZhengCardLabel {
    if (!_uploadZhengCardLabel) {
        _uploadZhengCardLabel = [[UILabel alloc] init];
        _uploadZhengCardLabel.backgroundColor = CharacterLightGrayColor;
        _uploadZhengCardLabel.textAlignment = NSTextAlignmentCenter;
        _uploadZhengCardLabel.textColor = UIColor.whiteColor;
        _uploadZhengCardLabel.text = @"上传身份证正面照";
        _uploadZhengCardLabel.hidden = YES;
    }
    return _uploadZhengCardLabel;
}


- (UIButton *)fancardButton {
    if (!_fancardButton) {
        _fancardButton = [[UIButton alloc] init];
        [_fancardButton addTarget:self action:@selector(uploadClick:) forControlEvents:UIControlEventTouchUpInside];
        [_fancardButton setBackgroundImage:[UIImage imageNamed:@"card_fan"] forState:UIControlStateNormal];
    }
    return _fancardButton;
}

- (UIImageView *)fancardImgView {
    if (!_fancardImgView) {
        _fancardImgView = [[UIImageView alloc] init];
        _fancardImgView.hidden = YES;
    }
    return _fancardImgView;
}

- (UILabel *)uploadfanCardLabel {
    if (!_uploadfanCardLabel) {
        _uploadfanCardLabel = [[UILabel alloc] init];
        _uploadfanCardLabel.backgroundColor = CharacterLightGrayColor;
        _uploadfanCardLabel.textAlignment = NSTextAlignmentCenter;
        _uploadfanCardLabel.textColor = UIColor.whiteColor;
        _uploadfanCardLabel.text = @"上传身份证反面照";
        _uploadfanCardLabel.hidden = YES;
    }
    return _uploadfanCardLabel;
}

#pragma --mark 事件

/**
 上传图片
 */
- (void)uploadClick:(UIButton *)button {
    
    if (button == self.zhengcardButton) {
        UIAlertController * actionController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction * a1 = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showMXPhotoCameraAndNeedToEdit:YES completion:^(UIImage *image, UIImage *originImage, CGRect cutRect) {
                if (image) {
                    [self uploadHeadImage:image originImage:originImage type:@1];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"图片获取失败"];
                }
            }];
        }];
        
        UIAlertAction * a2 = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showMXPhotoPickerControllerAndNeedToEdit:YES completion:^(UIImage *image, UIImage *originImage, CGRect cutRect) {
                if (image) {
                    [self uploadHeadImage:image originImage:originImage type:@1];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"图片获取失败"];
                }
            }];
        }];
        UIAlertAction * a3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [actionController addAction:a1];
        [actionController addAction:a2];
        [actionController addAction:a3];
        [self presentViewController:actionController animated:YES completion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [actionController viewDidLayoutSubviews];
            });
        }];
    } else {
        UIAlertController * actionController1 = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * a1 = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showMXPhotoCameraAndNeedToEdit:YES completion:^(UIImage *image, UIImage *originImage, CGRect cutRect) {
                if (image) {
                    [self uploadHeadImage:image originImage:originImage type:@2];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"图片获取失败"];
                }
            }];
        }];
        
        UIAlertAction * a2 = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showMXPhotoPickerControllerAndNeedToEdit:YES completion:^(UIImage *image, UIImage *originImage, CGRect cutRect) {
                if (image) {
                    [self uploadHeadImage:image originImage:originImage type:@2];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"图片获取失败"];
                }
            }];
        }];
        UIAlertAction * a3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [actionController1 addAction:a1];
        [actionController1 addAction:a2];
        [actionController1 addAction:a3];
        [self presentViewController:actionController1 animated:YES completion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [actionController1 viewDidLayoutSubviews];
            });
        }];
    }
}
//上传身份证正反面 type 1 正面 2 反面
- (void)uploadHeadImage:(UIImage *)image originImage:(UIImage *)originImage type:(NSNumber *)type{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain", @"text/html",@"text/json",@"text/javascript",@"text/x-chdr", nil];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    [manager POST: Base_upload_img_URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (image) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.5) name:@"file" fileName:@"test.jpg" mimeType:@"image/jpeg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        WeakObj(self);
        if (type.intValue == 1) {
            selfWeak.zhengcardImgView.hidden = NO;
            selfWeak.zhengcardImgView.image = image;
            NSArray *arr = responseObject[@"result"][@"fileIdList"];
            self.zhengStr = arr.firstObject;
            [selfWeak shiBieCardZheng:originImage];
        } else {
            selfWeak.fancardImgView.hidden = NO;
            selfWeak.fancardImgView.image = image;
            [selfWeak shiBieCardFan:originImage];
            NSArray *arr = responseObject[@"result"][@"fileIdList"];
            self.fanStr = arr.firstObject;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)shiBieCardFan:(UIImage *)image {
    WeakObj(self);
    [SVProgressHUD showWithStatus:@"身份证反面正在识别....."];
    [[AipOcrService shardService] detectIdCardBackFromImage:image withOptions:nil successHandler:^(id result) {
        [SVProgressHUD dismiss];
        NSMutableString *message = [NSMutableString string];
        if(result[@"words_result"]){
            [self.infoDict1 removeAllObjects];
            if([result[@"words_result"] isKindOfClass:[NSDictionary class]]){
                [result[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@: %@\n", key, obj[@"words"]];
                        if ([key isEqualToString:@"失效日期"]) {
                            [self.infoDict1 setObject:obj[@"words"] forKey:@"validDate"];
                        }
                    }else{
                        [message appendFormat:@"%@: %@\n", key, obj];
                        if ([key isEqualToString:@"失效日期"]) {
                            [self.infoDict1 setObject:obj forKey:@"validDate"];
                        }
                    }
                    
                }];
            }else if([result[@"words_result"] isKindOfClass:[NSArray class]]){
                for(NSDictionary *obj in result[@"words_result"]){
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@\n", obj[@"words"]];
                    }else{
                        [message appendFormat:@"%@\n", obj];
                    }
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    [self.tableView reloadData];
                });
            }
        }else{
            [SVProgressHUD dismiss];
            [message appendFormat:@"%@", result];
        }
    } failHandler:^(NSError *err) {
        [SVProgressHUD dismiss];
        NSLog(@"%@", err);
        NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[err code], [err localizedDescription]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            UIAlertController *alertShow = [UIAlertController alertControllerWithTitle:@"识别失败" message:msg preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * caa = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [alertShow dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertShow addAction:caa];
            [selfWeak presentViewController:alertShow animated:YES completion:nil];
        }];
    }];
}


- (void)shiBieCardZheng:(UIImage *)image {
    WeakObj(self);
    [SVProgressHUD showWithStatus:@"身份证正面正在识别....."];
    [[AipOcrService shardService] detectIdCardFrontFromImage:image withOptions:nil successHandler:^(id result) {
        [SVProgressHUD dismiss];
        NSMutableString *message = [NSMutableString string];
        if(result[@"words_result"]){
            [self.infoDict removeAllObjects];
            if([result[@"words_result"] isKindOfClass:[NSDictionary class]]){
                [result[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@: %@\n", key, obj[@"words"]];
                        if ([key isEqualToString:@"姓名"]) {
                            [self.infoDict setObject:obj[@"words"] forKey:@"name"];
                        }
                        if ([key isEqualToString:@"公民身份号码"]) {
                            [self.infoDict setObject:obj[@"words"] forKey:@"idCode"];
                        }
                        if ([key isEqualToString:@"出生"]) {
                            [self.infoDict setObject:obj[@"words"] forKey:@"birthdate"];
                        }
                        if ([key isEqualToString:@"住址"]) {
                            [self.infoDict setObject:obj[@"words"] forKey:@"address"];
                        }
                        if ([key isEqualToString:@"性别"]) {
                            [self.infoDict setObject:obj[@"words"] forKey:@"gender"];
                        }
                    }else{
                        [message appendFormat:@"%@: %@\n", key, obj];
                        if ([key isEqualToString:@"姓名"]) {
                            [self.infoDict setObject:obj forKey:@"name"];
                        }
                        if ([key isEqualToString:@"公民身份号码"]) {
                            [self.infoDict setObject:obj forKey:@"idCode"];
                        }
                        if ([key isEqualToString:@"出生"]) {
                            [self.infoDict setObject:obj forKey:@"birthdate"];
                        }
                        if ([key isEqualToString:@"住址"]) {
                            [self.infoDict setObject:obj forKey:@"address"];
                        }
                        if ([key isEqualToString:@"性别"]) {
                            [self.infoDict setObject:obj forKey:@"gender"];
                        }
                    }
                    
                }];
            }else if([result[@"words_result"] isKindOfClass:[NSArray class]]){
                for(NSDictionary *obj in result[@"words_result"]){
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@\n", obj[@"words"]];
                    }else{
                        [message appendFormat:@"%@\n", obj];
                    }
                    
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                self.nameView.rightTF.text = [NSString stringWithFormat:@"%@", self.infoDict[@"name"] ? self.infoDict[@"name"] : @""];
                self.cardView.rightTF.text = [NSString stringWithFormat:@"%@",self.infoDict[@"idCode"] ? self.infoDict[@"idCode"] : @""];
            });
            
        }else{
            [message appendFormat:@"%@", result];
        }
        
    } failHandler:^(NSError *err) {
        [SVProgressHUD dismiss];
        NSLog(@"%@", err);
        NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[err code], [err localizedDescription]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            UIAlertController *alertShow = [UIAlertController alertControllerWithTitle:@"识别失败" message:msg preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * caa = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [alertShow dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertShow addAction:caa];
            [selfWeak presentViewController:alertShow animated:YES completion:nil];
        }];
    }];
    
}


/**
 下一步
 */
- (void)nextClick:(UIButton *)btn {
    [SVProgressHUD dismiss];
    if (!self.zhengStr) {
        [SVProgressHUD showErrorWithStatus:@"请上传身份证正面!"];
        return;
    }
    if (!self.fanStr) {
        [SVProgressHUD showErrorWithStatus:@"请上传身份证反面!"];
        return;
    }
    if (self.infoDict.allKeys == 0) {
        [SVProgressHUD showErrorWithStatus:@"身份证正面识别失败,请重新上传!"];
        return;
    }
    if (self.infoDict1.allKeys == 0) {
        [SVProgressHUD showErrorWithStatus:@"身份证反面识别失败,请重新上传!"];
        return;
    }
    for (NSString *key in self.infoDict.allKeys) {
        NSString *str = self.infoDict[key];
        if (str == nil ||[str isEqualToString:@""] ) {
            [SVProgressHUD showErrorWithStatus:@"身份证正面识别失败,请重新上传!"];
            return;
        }
    }
    for (NSString *key in self.infoDict1.allKeys) {
        NSString *str = self.infoDict1[key];
        if (str == nil ||[str isEqualToString:@""] ) {
            [SVProgressHUD showErrorWithStatus:@"身份证反面识别失败,请重新上传!"];
            return;
        }
    }
    NSString *birthdate = [self retFormatterDate:self.infoDict[@"birthdate"]];
    NSString *validDate = [self retFormatterDate:self.infoDict1[@"validDate"]];
    if ([birthdate isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请身份证正面正在识别,请稍后..."];
        return;
    }
    if ([validDate isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请身份证反面正在识别,请稍后..."];
        return;
    }
    NSLog(@"正:%@---反:%@",self.zhengStr,self.fanStr);
    if (self.nameView.rightTF.text.length == 0 || [self.nameView.rightTF.text isEqual:@""] || [[self.nameView.rightTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入您的姓名!"];
        return;
    }
    
    if (self.cardView.rightTF.text.length == 0 || [self.cardView.rightTF.text isEqual:@""] || [[self.cardView.rightTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入您的银行卡号!"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"sfz_zheng_pic"] = self.zhengStr;
    dict[@"sfz_fan_pic"] = self.fanStr;
    dict[@"name"] = self.nameView.rightTF.text;
    dict[@"idCode"] = self.cardView.rightTF.text;
    dict[@"address"] = self.infoDict[@"address"];
    dict[@"gender"] = self.infoDict[@"gender"];
    dict[@"birthdate"] = birthdate;
    dict[@"validDate"] = validDate;

    NSLog(@"%@", dict);
    
    
    //查询是否开户
    
    LxmShiMingRenZhengNextVC *vc = [[LxmShiMingRenZhengNextVC alloc] init];
    vc.dict = dict;
    [self.navigationController pushViewController:vc animated:YES];
    
//    LxmTianJiaBankVC *vc = [[LxmTianJiaBankVC alloc] init];
//    vc.dict = dict;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (NSString *)retFormatterDate:(NSString *)dateStr {
    NSMutableArray *arr = [NSMutableArray array];
    if (dateStr.length >= 4) {
        [arr addObject:[dateStr substringToIndex:4]];
    }
    if (dateStr.length >= 6) {
        [arr addObject:[dateStr substringWithRange:NSMakeRange(4,2)]];
    }
    if (dateStr.length >= 8) {
        [arr addObject:[dateStr substringWithRange:NSMakeRange(6,2)]];
    }
    NSLog(@"%@",arr);
    NSString *formatterStr = [arr componentsJoinedByString:@"-"];
    return  formatterStr;
}

@end
