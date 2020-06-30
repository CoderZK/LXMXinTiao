//
//  LxmAddCardNextVCViewController.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/29.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmAddCardNextVC.h"
#import "LxmRegistVC.h"
#import "LxmSelectView.h"
#import "LxmSelectBankVC.h"
#import "LxmCardTypeVC.h"
#import "LxmVerifyPhoneVC.h"
#import "LxmResourceBannerModel.h"
#import "LxmWebViewController.h"

@interface LxmAddCardNextVC ()

@property (nonatomic, strong) UIView *headerView;//表头视图

@property (nonatomic, strong) UIView *topView;//

@property (nonatomic, strong) UILabel *selectTypeLabel;//请选择银行卡类型

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) LxmSelectView *bankView;//银行

//@property (nonatomic, strong) LxmSelectView *cardTypeView;//卡类型

@property (nonatomic, strong) LxmRegistView *phoneView;//手机号

@property (nonatomic, strong) LxmAgreeProtocolButton *agreeButton;//同意协议

@property (nonatomic, strong) UIButton *nextbutton;//下一步

@property (nonatomic, strong) NSMutableArray <LxmBankListModel *>*dataArr;

@property (nonatomic, strong) NSString *bankID;//选择的银行id 或者输入的Id

@property (nonatomic, strong) NSString *bankName;//银行名称

@end

@implementation LxmAddCardNextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择银行卡";
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self initSubViews];
    [self setConstrains];
    if (self.bankInfodDic && self.bankInfodDic[@"bank_name"]) {
        self.dataArr = [NSMutableArray array];
        [self loadBankListData:self.bankInfodDic[@"bank_name"]];
    }
}


- (void)loadBankListData:(NSString *)banckName {
    [LxmNetworking networkingPOST:app_findBankList parameters:nil returnClass:[LxmBankListRootModel class] success:^(NSURLSessionDataTask *task, LxmBankListRootModel *responseObject) {
        if (responseObject.key.intValue == 1) {
            [self.dataArr addObjectsFromArray:responseObject.result];
            for (LxmBankListModel *model in self.dataArr) {
                if ([model.name containsString:banckName]) {
                    self.bankID = model.id;
                    self.bankName = model.name;
                    return;
                }
            }
        }else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}



- (void)initSubViews {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 300)];
    self.tableView.tableHeaderView = _headerView;
    
    [self.headerView addSubview:self.topView];
    [self.topView addSubview:self.selectTypeLabel];
    [self.topView addSubview:self.lineView];
    
    [self.headerView addSubview:self.bankView];
//    [self.headerView addSubview:self.cardTypeView];
    [self.headerView addSubview:self.phoneView];
    [self.headerView addSubview:self.agreeButton];
    [self.headerView addSubview:self.nextbutton];
}

- (void)setConstrains {
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@40);
    }];
    [self.selectTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.topView).offset(15);
        make.centerY.equalTo(self.topView);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.topView).offset(15);
        make.trailing.equalTo(self.topView).offset(-15);
        make.bottom.equalTo(self.topView);
        make.height.equalTo(@0.5);
    }];
    [self.bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@50);
    }];
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankView.mas_bottom);
        make.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@50);
    }];
    [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneView.mas_bottom);
        make.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@50);
    }];
    [self.nextbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.agreeButton.mas_bottom).offset(10);
        make.leading.equalTo(self.headerView).offset(15);
        make.trailing.equalTo(self.headerView).offset(-15);
        make.height.equalTo(@50);
    }];
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
    }
    return _topView;
}
- (UILabel *)selectTypeLabel {
    if (!_selectTypeLabel) {
        _selectTypeLabel = [[UILabel alloc] init];
        _selectTypeLabel.textColor = CharacterDarkColor;
        _selectTypeLabel.text = @"请选择银行卡类型";
        _selectTypeLabel.font = [UIFont systemFontOfSize:15];
    }
    return _selectTypeLabel;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}
- (LxmSelectView *)bankView {
    if (!_bankView) {
        _bankView = [[LxmSelectView alloc] init];
        _bankView.leftLabel.text = @"银行";
        if (self.bankInfodDic && self.bankInfodDic[@"bank_name"]) {
            _bankView.rightLabel.text = self.bankInfodDic[@"bank_name"];
        }else {
            _bankView.rightLabel.text = @"请选择";
            [_bankView addTarget:self action:@selector(bankClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return _bankView;
}

- (LxmRegistView *)phoneView {
    if (!_phoneView) {
        _phoneView = [[LxmRegistView alloc] init];
        _phoneView.leftLabel.text = @"手机号";
        _phoneView.rightTF.placeholder = @"请输入银行预留手机号";
        _phoneView.rightTF.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _phoneView;
}

- (LxmAgreeProtocolButton *)agreeButton {
    if (!_agreeButton) {
        _agreeButton = [[LxmAgreeProtocolButton alloc] init];
        [_agreeButton addTarget:self action:@selector(agreeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_agreeButton.protocolButton addTarget:self action:@selector(protocolButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeButton;
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

/**
 选择银行
 */
- (void)bankClick {
    LxmSelectBankVC *vc = [[LxmSelectBankVC alloc] init];
    WeakObj(self);
    vc.LxmSelectBankBlock = ^(LxmBankListModel *model) {
        selfWeak.bankView.rightLabel.text = model.name;
        selfWeak.bankID = model.id;
        selfWeak.bankName = model.name;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 选择卡类型
 */
- (void)seclctCardTypeClick {
//    LxmCardTypeVC *vc = [[LxmCardTypeVC alloc] init];
//    WeakObj(self);
//    vc.LxmSelectCareTypeBlock = ^(LxmSelcetBankModel *model) {
//        selfWeak.cardTypeView.rightLabel.text = model.bank;
//    };
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)agreeButtonClick:(LxmAgreeProtocolButton *)button {
    button.selected = !button.selected;
    button.iconImgView.image = [UIImage imageNamed:button.selected ? @"gouxuan_1" : @"gouxuan_n"];
}

/**
 同意协议
 */
- (void)protocolButtonClick {
    [LxmNetworking networkingPOST:app_getBaseInfo parameters:@{@"type" : @3} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"key"] intValue] == 1) {
            NSString * str = responseObject[@"result"][@"content"];
            if ([str isKindOfClass:[NSNull class]]||[str isEqualToString:@""]) {
                str = @"";
            }else{
                str = str;
            }
            LxmWebViewController * vc = [[LxmWebViewController alloc] init];
            vc.navigationItem.title = @"同意协议";
            [vc loadHtmlStr:str withBaseUrl:Base_URL];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

/**
 下一步
 */
- (void)nextClick {
    if (!self.agreeButton.selected) {
        [SVProgressHUD showErrorWithStatus:@"请先同意协议"];
        return;
    }
    if (!self.bankID || [self.bankID isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"不支持对应的银行卡类型的绑定!"];
        return;
    }
    if (self.phoneView.rightTF.text.length == 0 || [self.phoneView.rightTF.text isEqualToString:@""] || [[self.phoneView.rightTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入银行预留手机号!"];
        return;
    }
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:self.phoneView.rightTF.text forKey:@"phone"];
    [dict setObject:@4 forKey:@"type"];
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:app_sendVerificationCode parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1) {
            [SVProgressHUD showErrorWithStatus:@"验证码已发送!"];
            LxmVerifyPhoneVC *vc = [[LxmVerifyPhoneVC alloc] init];
            vc.isHuanban = self.isHuanban;
            vc.oldId = self.oldId;
            vc.phone = self.phoneView.rightTF.text;
            vc.name = self.name;
            vc.bankId = self.bankID;
            vc.cardNo = self.cardNo;
            vc.bank = self.bankName;
            vc.shiBieImageID = self.shiBieImageID;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

@end

