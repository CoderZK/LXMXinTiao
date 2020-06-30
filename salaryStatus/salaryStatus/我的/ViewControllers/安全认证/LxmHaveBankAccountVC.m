//
//  LxmHaveBankAccountVC.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/9/4.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmHaveBankAccountVC.h"
#import "LxmRenZhengSuccessAlertView.h"
#import "LxmWebViewController.h"
#import "LxmShiMingRenZhengNextVC.h"

@interface LxmHaveBankAccountVC ()

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UILabel *cardnoLabel;//账户号

@property (nonatomic, strong) UIButton *agreeButton;//同意将该账户作为薪跳收款账户

@property (nonatomic, strong) LxmKaiHuInfoModel *chaxunModel;

@property (nonatomic, assign) BOOL isNoFirst;

@end

@implementation LxmHaveBankAccountVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isNoFirst && !LxmTool.ShareTool.userModel.bankAccount) {
        [self chaxunClick];
    }
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:self.view.bounds];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [UIImageView new];
    }
    return _iconImgView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.textColor = CharacterDarkColor;
        _textLabel.font = [UIFont systemFontOfSize:15];
    }
    return _textLabel;
}

- (UILabel *)cardnoLabel {
    if (!_cardnoLabel) {
        _cardnoLabel = [UILabel new];
        _cardnoLabel.textColor = CharacterDarkColor;
        _cardnoLabel.font = [UIFont systemFontOfSize:15];
    }
    return _cardnoLabel;
}

- (UIButton *)agreeButton {
    if (!_agreeButton) {
        _agreeButton = [[UIButton alloc] init];
        [_agreeButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_agreeButton setBackgroundImage:[UIImage imageNamed:@"lightblue"] forState:UIControlStateNormal];
        _agreeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _agreeButton.layer.cornerRadius = 5;
        _agreeButton.layer.masksToBounds = YES;
        [_agreeButton addTarget:self action:@selector(agree:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeButton;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"实名认证";
    self.isNoFirst = YES;
    self.tableView.tableHeaderView = self.headerView;
    [self initHeaderView];
    [self setHeadView];
    if (LxmTool.ShareTool.userModel.bankAccount) {
        _textLabel.text = @"查询到您在光大银行的账号";
        _iconImgView.image = [UIImage imageNamed:@"rzcg"];
        _cardnoLabel.text = LxmTool.ShareTool.userModel.bankAccount;
        [_agreeButton setTitle:@"已同意将该账户作为薪资收款账户" forState:UIControlStateNormal];
        _agreeButton.userInteractionEnabled = NO;
    } else {
        _agreeButton.userInteractionEnabled = YES;
        if (self.model.isOpen.intValue == 0) {
               _textLabel.text = @"经查询,您尚未在光光大银行开立";
               _cardnoLabel.text = @"薪资收款账户";
               _iconImgView.image = [UIImage imageNamed:@"rzsb"];
               [_agreeButton setTitle:@"去开户" forState:UIControlStateNormal];
           } else {
               _textLabel.text = @"查询到您在光大银行的账号";
               _iconImgView.image = [UIImage imageNamed:@"rzcg"];
               _cardnoLabel.text = self.model.electricAccount;
               [_agreeButton setTitle:@"同意将该账户作为薪资收款账户" forState:UIControlStateNormal];
           }
    }
}

/**
 初始化头视图
 */
- (void)initHeaderView {
    [self.headerView addSubview:self.iconImgView];
    [self.headerView addSubview:self.textLabel];
    [self.headerView addSubview:self.cardnoLabel];
    [self.headerView addSubview:self.agreeButton];
}

/**
 设置约束
 */
- (void)setHeadView {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.textLabel.mas_top).offset(-25);
        make.centerX.equalTo(self.headerView);
        make.width.height.equalTo(@100);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.cardnoLabel.mas_top).offset(-10);
        make.centerX.equalTo(self.headerView);
    }];
    [self.cardnoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.agreeButton.mas_top).offset(-20);
        make.centerX.equalTo(self.headerView);
    }];
    [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headerView.mas_centerY);
        make.centerX.equalTo(self.headerView);
        make.width.equalTo(@(ScreenW - 40));
        make.height.equalTo(@44);
    }];
}

/**
 同意将该账户作为薪跳收款账户
 */
- (void)agree:(UIButton *)btn {
    
    void(^openBlock)(LxmKaiHuInfoModel *m) = ^(LxmKaiHuInfoModel *m){
        LxmWebViewController *webVC = [[LxmWebViewController alloc] init];
        webVC.navigationItem.title = @"注册账户";
        NSString *version = [UIDevice currentDevice].systemVersion;
        NSString *url = @"";
        if (version.doubleValue >= 9.0) {
            // 针对 9.0 以上的iOS系统进行处理
            url = [self.model.htmlContent stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        } else {
            // 针对 9.0 以下的iOS系统进行处理
            url = [m.htmlContent stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        webVC.loadUrl = [NSURL URLWithString:url];
        [self.navigationController pushViewController:webVC animated:YES];
    };
    
    if (!self.chaxunModel) {
        if (self.model.isOpen.intValue == 0) {//去开户
            openBlock(self.model);
        } else {//同意将该账户作为薪资收款账户
            [self bandZhangHu];
        }
    } else {
        if (self.chaxunModel.isOpen.intValue == 0) {//去开户
            openBlock(self.chaxunModel);
        } else {//同意将该账户作为薪资收款账户
            [self bandZhangHu];
        }
    }
    
}

/**
 绑定账户
 */
- (void)bandZhangHu {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:self.dict];
    dic[@"electricAccount"] = self.model.electricAccount;
    [SVProgressHUD show];
    self.agreeButton.userInteractionEnabled = NO;
     WeakObj(self);
    [LxmNetworking networkingPOST:user_bindElectricAccount parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self.agreeButton.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1) {
            LxmRenZhengSuccessAlertView *alertView = [[LxmRenZhengSuccessAlertView alloc] initWithFrame:UIScreen.mainScreen.bounds];
            alertView.isSuccess = YES;
            alertView.backBlock = ^(LxmRenZhengSuccessAlertView *view) {
                [view dismiss];
                [selfWeak.navigationController popToRootViewControllerAnimated:YES];
            };
            [alertView show];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.agreeButton.userInteractionEnabled = YES;
        [SVProgressHUD dismiss];
    }];
}

/**
 开户返回就查询
 */
- (void)chaxunClick {
    [self.tableView endEditing:YES];
    NSString *phone = self.phone;
    if (phone.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    if (phone.length!= 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入11位的手机号"];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = SESSION_TOKEN;
    dic[@"name"] = self.dict[@"name"];
    dic[@"idCode"] = self.dict[@"idCode"];
    dic[@"reservePhone"] = phone;
    [SVProgressHUD show];
    WeakObj(self);
    [LxmNetworking networkingPOST:user_queryElectricAccount parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1) {
            LxmKaiHuInfoModel *model = [LxmKaiHuInfoModel mj_objectWithKeyValues:responseObject[@"result"]];
            selfWeak.chaxunModel = model;
            if (model.isOpen.intValue == 0) {
                selfWeak.textLabel.text = @"经查询,您尚未在光光大银行开立";
                selfWeak.cardnoLabel.text = @"薪资收款账户";
                selfWeak.iconImgView.image = [UIImage imageNamed:@"rzsb"];
                [selfWeak.agreeButton setTitle:@"去开户" forState:UIControlStateNormal];
            } else if (model.isOpen.intValue == 1) {
                selfWeak.textLabel.text = @"查询到您在光大银行的账号";
                selfWeak.iconImgView.image = [UIImage imageNamed:@"rzcg"];
                selfWeak.cardnoLabel.text = model.electricAccount;
                [selfWeak.agreeButton setTitle:@"同意将该账户作为薪资收款账户" forState:UIControlStateNormal];
            }
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

@end
