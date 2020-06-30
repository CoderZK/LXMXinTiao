//
//  LxmAddCardVC.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/29.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmAddCardVC.h"
#import "LxmRegistVC.h"
#import "LxmUploadAlertView.h"
#import "LxmAddCardNextVC.h"

#import <AssetsLibrary/ALAssetsLibrary.h>
#import "MXPhotoPickerController.h"
#import "UIViewController+MXPhotoPicker.h"

#import <objc/runtime.h>
#import <AipOcrSdk/AipOcrSdk.h>

@interface LxmAddCardVC ()

@property (nonatomic, strong) UIView *headerView;//表头

@property (nonatomic, strong) LxmRegistView *nameView;//持卡人

@property (nonatomic, strong) LxmRegistView *cardNo;//卡号

@property (nonatomic, strong) UIButton *paizhaoButton;//拍照

@property (nonatomic, strong) UIButton *nextbutton;//下一步

@property (nonatomic, strong) NSString *cardStr;//银行卡号

@property (nonatomic, strong)  NSMutableDictionary *bankInfodDic;//银行卡类型

@property (nonatomic, strong)  UIImage *shiBieImage;//Ocr识别的银行卡

@property (nonatomic, strong)  NSString *shiBieImageID;//Ocr识别的银行卡

@property (nonatomic, assign) LxmAddCardVC_type type;

@end

@implementation LxmAddCardVC {
    // 默认的识别成功的回调
    void (^_successHandler)(id);
    // 默认的识别失败的回调
    void (^_failHandler)(NSError *);
}

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(LxmAddCardVC_type)type {
    self = [super initWithTableViewStyle:style];
    if (self) {
        self.type = type;
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.bankInfodDic = [NSMutableDictionary dictionary];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[AipOcrService shardService] authWithAK:@"ySBAgMiBBUwvyUL33z6H0Ysf" andSK:@"1KFLxKuC0SH9c2gG0CwmdDgvljaBuxYz"];
    self.navigationItem.title = self.type == LxmAddCardVC_type_add ? @"添加银行卡" : @"换绑银行卡";
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self initSubViews];
    [self setConstrains];
    
    [self configCallback];
}



/**
 添加子视图
 */
- (void)initSubViews {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 200)];
    self.tableView.tableHeaderView = _headerView;
    
    [self.headerView addSubview:self.nameView];
    [self.headerView addSubview:self.cardNo];
    [self.headerView addSubview:self.paizhaoButton];
    [self.headerView addSubview:self.nextbutton];
}

/**
 设置约束
 */
- (void)setConstrains {
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@50);
    }];
    [self.cardNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameView.mas_bottom);
        make.leading.equalTo(self.headerView);
        make.trailing.equalTo(self.paizhaoButton.mas_leading);
        make.height.equalTo(@50);
    }];
    [self.paizhaoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameView.mas_bottom);
        make.trailing.equalTo(self.headerView);
        make.width.equalTo(@65);
        make.height.equalTo(@50);
    }];
    
    [self.nextbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardNo.mas_bottom).offset(30);
        make.leading.equalTo(self.headerView).offset(20);
        make.trailing.equalTo(self.headerView).offset(-20);
        make.height.equalTo(@50);
    }];
}

/**
 懒加载子视图
 */
- (LxmRegistView *)nameView {
    if (!_nameView) {
        _nameView = [[LxmRegistView alloc] init];
        _nameView.leftLabel.text = @"持卡人";
        _nameView.rightTF.placeholder = @"请输入持卡人姓名";
    }
    return _nameView;
}

- (LxmRegistView *)cardNo {
    if (!_cardNo) {
        _cardNo = [[LxmRegistView alloc] init];
        _cardNo.leftLabel.text = @"卡号";
        _cardNo.rightTF.placeholder = @"请输入储蓄卡卡号";
        _cardNo.rightTF.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _cardNo;
}

- (UIButton *)paizhaoButton {
    if (!_paizhaoButton) {
        _paizhaoButton = [[UIButton alloc] init];
        [_paizhaoButton setImage:[UIImage imageNamed:@"ico_paizhao"] forState:UIControlStateNormal];
        [_paizhaoButton addTarget:self action:@selector(paiZhaoClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _paizhaoButton;
}

- (UIButton *)nextbutton {
    if (!_nextbutton) {
        _nextbutton = [[UIButton alloc] init];
        [_nextbutton setBackgroundImage:[UIImage imageNamed:@"lightblue"] forState:UIControlStateNormal];
        [_nextbutton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextbutton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _nextbutton.titleLabel.font = [UIFont systemFontOfSize:15];
        _nextbutton.layer.cornerRadius = 5;
        _nextbutton.layer.masksToBounds = YES;
        [_nextbutton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextbutton;
}

- (void)nextClick {
    if (self.shiBieImage) {
         [self uploadImage:self.shiBieImage];
    }
    
    if (self.nameView.rightTF.text.length == 0 && [[self.nameView.rightTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入持卡人姓名!"];
        return;
    }
    if (self.cardNo.rightTF.text.length == 0 && [[self.cardNo.rightTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入或拍照上传银行卡号!"];
        return;
    }
    NSString *cardType = nil;
    if (self.bankInfodDic) {
        cardType = self.bankInfodDic[@"bank_card_type"];
    }
    if (![self.nameView.rightTF.text isEqualToString:[LxmTool ShareTool].userModel.name] || (cardType && cardType.intValue != 1)) {
        //银行卡 姓名 有效期等 不正确的话 就弹出此弹窗
        LxmUploadAlertView *alertView = [[LxmUploadAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [alertView show];
        return;
    }
    LxmAddCardNextVC *vc = [[LxmAddCardNextVC alloc] init];
    if (self.shiBieImageID) {
        vc.shiBieImageID = self.shiBieImageID;
    }
    vc.oldId = self.oldId;
    vc.isHuanban = self.type == LxmAddCardVC_type_huanbang;
    vc.name = self.nameView.rightTF.text;
    vc.cardNo = self.cardNo.rightTF.text;
    vc.bankInfodDic = self.bankInfodDic;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)uploadImage:(UIImage *)image {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain", @"text/html",@"text/json",@"text/javascript",@"text/x-chdr", nil];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    [manager POST: @"http://192.168.1.105:80/xintiao/uploadFile.do" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (image) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.5) name:@"file" fileName:@"test.jpg" mimeType:@"image/jpeg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *arr = responseObject[@"result"][@"fileIdList"];
        self.shiBieImageID = arr.firstObject;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}


- (void)paiZhaoClick {
    
    [self showMXPhotoCameraAndNeedToEdit:YES completion:^(UIImage *image, UIImage *originImage, CGRect cutRect) {
        if (originImage) {
            self.shiBieImage = originImage;
            [self shibieBanrkCard:originImage];
        }else {
            [SVProgressHUD showErrorWithStatus:@"图片不存在!"];
        }
    }];
}

- (void)shibieBanrkCard:(UIImage *)image {
    [[AipOcrService shardService] detectBankCardFromImage:image
                                           successHandler:_successHandler
                                              failHandler:_failHandler];
}

- (void)configCallback {
    WeakObj(self);
    // 这是默认的识别成功的回调
    _successHandler = ^(id result){
        NSLog(@"%@", result);
        NSMutableString *message = [NSMutableString string];
        if(result[@"words_result"]){
            if([result[@"words_result"] isKindOfClass:[NSDictionary class]]){
                [result[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@: %@\n", key, obj[@"words"]];
                        [selfWeak.bankInfodDic removeAllObjects];
                        selfWeak.bankInfodDic[@"bank_card_number"] = obj[@"words"][@"bank_card_number"];
                        selfWeak.bankInfodDic[@"valid_date"] = obj[@"words"][@"valid_date"];
                        selfWeak.bankInfodDic[@"bank_card_type"] = obj[@"words"][@"bank_card_type"];
                        selfWeak.bankInfodDic[@"bank_name"] = obj[@"words"][@"bank_name"];
                        NSString *cardType = selfWeak.bankInfodDic[@"bank_card_type"];
                        if (cardType.intValue == 1) {
                            if ([selfWeak.bankInfodDic[@"bank_name"] isEqualToString:@"华夏银行"]) {
                                [UIAlertController showAlertWithmessage:@"暂不能绑定华夏银行的银行卡!"];
                                [selfWeak.bankInfodDic removeAllObjects];
                            } else {
                                selfWeak.cardStr = [NSString stringWithFormat:@"%@", selfWeak.bankInfodDic[@"bank_card_number"]];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    selfWeak.cardNo.rightTF.text = selfWeak.cardStr;
                                });
                            }
                            [selfWeak uploadImage:selfWeak.shiBieImage];
                        }else {
                            [UIAlertController showAlertWithmessage:@"只能绑定储蓄卡!"];
                            [selfWeak.bankInfodDic removeAllObjects];
                            selfWeak.shiBieImage = nil;
                        }
                        
                    }else{
                        [message appendFormat:@"%@: %@\n", key, obj];
                    }
                    
                }];
            }else if([result[@"words_result"] isKindOfClass:[NSArray class]]){
                for(NSDictionary *obj in result[@"words_result"]){
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@\n", obj[@"words"]];
                        [selfWeak.bankInfodDic removeAllObjects];
                        selfWeak.bankInfodDic[@"bank_card_number"] = obj[@"words"][@"bank_card_number"];
                        selfWeak.bankInfodDic[@"valid_date"] = obj[@"words"][@"valid_date"];
                        selfWeak.bankInfodDic[@"bank_card_type"] = obj[@"words"][@"bank_card_type"];
                        selfWeak.bankInfodDic[@"bank_name"] = obj[@"words"][@"bank_name"];
                        NSString *cardType = selfWeak.bankInfodDic[@"bank_card_type"];
                        if (cardType.intValue == 1) {
                            if ([selfWeak.bankInfodDic[@"bank_name"] isEqualToString:@"华夏银行"]) {
                                 [UIAlertController showAlertWithmessage:@"暂不能绑定华夏银行的银行卡!"];
                                [selfWeak.bankInfodDic removeAllObjects];
                            } else {
                                selfWeak.cardStr = [NSString stringWithFormat:@"%@", selfWeak.bankInfodDic[@"bank_card_number"]];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    selfWeak.cardNo.rightTF.text = selfWeak.cardStr;
                                });
                            }
                            [selfWeak uploadImage:self.shiBieImage];
                        }else {
                            [UIAlertController showAlertWithmessage:@"只能绑定储蓄卡!"];
                            [selfWeak.bankInfodDic removeAllObjects];
                            selfWeak.shiBieImage = nil;
                        }
                        
                    }else{
                        [message appendFormat:@"%@\n", obj];
                    }
                    
                }
            }
            
        }else{
            [message appendFormat:@"%@", result];
            [selfWeak.bankInfodDic removeAllObjects];
            
            NSDictionary *resultDict = result[@"result"];
            selfWeak.bankInfodDic[@"bank_card_number"] = resultDict[@"bank_card_number"];
            selfWeak.bankInfodDic[@"valid_date"] = resultDict[@"valid_date"];
            selfWeak.bankInfodDic[@"bank_card_type"] = resultDict[@"bank_card_type"];
            selfWeak.bankInfodDic[@"bank_name"] = resultDict[@"bank_name"];
            NSString *cardType = selfWeak.bankInfodDic[@"bank_card_type"];
            if (cardType.intValue == 1) {
                if ([selfWeak.bankInfodDic[@"bank_name"] isEqualToString:@"华夏银行"]) {
                    [UIAlertController showAlertWithmessage:@"暂不能绑定华夏银行的银行卡!"];
                    [selfWeak.bankInfodDic removeAllObjects];
                } else {
                    selfWeak.cardStr = [NSString stringWithFormat:@"%@", selfWeak.bankInfodDic[@"bank_card_number"]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                         selfWeak.cardNo.rightTF.text = selfWeak.cardStr;
                    });
                }
                [selfWeak uploadImage:self.shiBieImage];
            }else {
                [UIAlertController showAlertWithmessage:@"只能绑定储蓄卡!"];
                [selfWeak.bankInfodDic removeAllObjects];
                selfWeak.shiBieImage = nil;
            }
        }
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:selfWeak cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alertView show];
//        }];
    };
    
    _failHandler = ^(NSError *error){
        NSLog(@"%@", error);
        NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[error code], [error localizedDescription]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[[UIAlertView alloc] initWithTitle:@"识别失败" message:msg delegate:selfWeak cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }];
    };
}



@end
