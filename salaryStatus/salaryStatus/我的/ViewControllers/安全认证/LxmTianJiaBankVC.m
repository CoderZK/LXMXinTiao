//
//  LxmTianJiaBankVC.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/7/8.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmTianJiaBankVC.h"
#import "LxmWebViewController.h"

@interface LxmTianJiaBankButton : UIControl

@property (nonatomic, strong) UILabel *leftLabel;

@end

@implementation LxmTianJiaBankButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftLabel];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = [UIFont systemFontOfSize:14];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"没有光大银行账户，" attributes:@{NSForegroundColorAttributeName:CharacterGrayColor}];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"去注册" attributes:@{NSForegroundColorAttributeName:MineColor,NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
        [attStr appendAttributedString:str];
        _leftLabel.attributedText = attStr;
    }
    return _leftLabel;
}

@end


@interface LxmTianJiaBankView : UIView

@property (nonatomic, strong) UILabel *leftLabel;//左侧标题

@property (nonatomic, strong) UITextField *rightTF;//右侧输入

@property (nonatomic, strong) UIView *lineView;//线

@end

@implementation LxmTianJiaBankView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightTF];
        [self addSubview:self.lineView];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.width.equalTo(@120);
        }];
        [self.rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.leftLabel.mas_trailing);
            make.trailing.equalTo(self).offset(-15);
            make.top.bottom.equalTo(self);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.bottom.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = [UIFont systemFontOfSize:14];
        _leftLabel.textColor = CharacterDarkColor;
    }
    return _leftLabel;
}

- (UITextField *)rightTF {
    if (!_rightTF) {
        _rightTF = [[UITextField alloc] init];
        _rightTF.font = [UIFont systemFontOfSize:14];
        _rightTF.textColor = CharacterDarkColor;
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


@interface LxmTianJiaBankVC ()

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) LxmTianJiaBankView *accountView;//账户

@property (nonatomic, strong) LxmTianJiaBankView *phoneView;//手机号

@property (nonatomic, strong) UIButton *codeBtn;//发送验证码

@property (nonatomic, strong) LxmTianJiaBankView *codeView;//验证码

@property (nonatomic, strong) UIButton *submitButton;//提交

@property (nonatomic, strong) LxmTianJiaBankButton *zhuceButton;//没有账户 去注册

@property (nonatomic, strong) NSTimer *timer;//倒计时

@property (nonatomic, assign) int time;//倒计时时间

@end

@implementation LxmTianJiaBankVC

-(UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 320)];
    }
    return _headerView;
}
- (LxmTianJiaBankView *)accountView {
    if (!_accountView) {
        _accountView = [[LxmTianJiaBankView alloc] init];
        _accountView.leftLabel.text = @"光大银行账户";
        _accountView.rightTF.placeholder = @"请输入";
        _accountView.rightTF.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _accountView;
}

- (LxmTianJiaBankView *)phoneView {
    if (!_phoneView) {
        _phoneView = [[LxmTianJiaBankView alloc] init];
        _phoneView.leftLabel.text = @"银行预留手机号";
        _phoneView.rightTF.placeholder = @"请输入";
    }
    return _phoneView;
}

- (UIButton *)codeBtn {
    if (!_codeBtn) {
        _codeBtn = [[UIButton alloc] init];
        _codeBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
        [_codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_codeBtn setTitleColor:MineColor forState:UIControlStateNormal];
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _codeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_codeBtn addTarget:self action:@selector(sendCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeBtn;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [[UIButton alloc] init];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_submitButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_submitButton setBackgroundImage:[UIImage imageNamed:@"lightblue"] forState:UIControlStateNormal];
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _submitButton.layer.cornerRadius = 5;
        _submitButton.layer.masksToBounds = YES;
        [_submitButton addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

- (LxmTianJiaBankView *)codeView {
    if (!_codeView) {
        _codeView = [[LxmTianJiaBankView alloc] init];
        _codeView.leftLabel.text = @"验证码";
        _codeView.rightTF.placeholder = @"请输入";
    }
    return _codeView;
}

- (LxmTianJiaBankButton *)zhuceButton {
    if (!_zhuceButton) {
        _zhuceButton = [[LxmTianJiaBankButton alloc] init];
        [_zhuceButton addTarget:self action:@selector(zhuceAccount) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zhuceButton;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    //新加的添加银行卡界面
    self.navigationItem.title = @"添加银行卡";
    [self initHeaderView];
}

- (void)initHeaderView {
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView addSubview:self.accountView];
    [self.headerView addSubview:self.phoneView];
    [self.headerView addSubview:self.codeBtn];
    [self.headerView addSubview:self.codeView];
    [self.headerView addSubview:self.submitButton];
    [self.headerView addSubview:self.zhuceButton];
    [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@60);
    }];
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountView.mas_bottom);
        make.trailing.equalTo(self.headerView);
        make.width.equalTo(@95);
        make.height.equalTo(@60);
    }];
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountView.mas_bottom);
        make.trailing.equalTo(self.codeBtn.mas_leading);
        make.leading.equalTo(self.headerView);
        make.height.equalTo(@60);
    }];
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneView.mas_bottom);
        make.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@60);
    }];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeView.mas_bottom).offset(30);
        make.leading.equalTo(self.codeView).offset(20);
        make.trailing.equalTo(self.codeView).offset(-20);
        make.height.equalTo(@50);
    }];
    [self.zhuceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.submitButton.mas_bottom);
        make.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@50);
    }];
}

/**
 发送验证码
 */
- (void)sendCodeButton:(UIButton *)btn {
    if (self.phoneView.rightTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    if (self.phoneView.rightTF.text.length!= 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入11位的手机号"];
        return;
    }
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:self.phoneView.rightTF.text forKey:@"phone"];
    [dict setObject:@11 forKey:@"type"];
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:app_sendVerificationCode parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1) {
            [self.timer invalidate];
            self.timer = nil;
            self.time = 60;
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        } else {
            [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

/**
 定时器 验证码
 */
- (void)onTimer {
    self.codeBtn.enabled = NO;
    [self.codeBtn setTitle:[NSString stringWithFormat:@"获取(%ds)",self.time--] forState:UIControlStateNormal];
    if (self.time < 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.codeBtn.enabled = YES;
        [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

/**
 提交
 */
- (void)submit:(UIButton *)btn {
    [self.tableView endEditing:YES];
    NSString *acc = self.accountView.rightTF.text;
    NSString *code = self.codeView.rightTF.text;
    NSString *phone = self.phoneView.rightTF.text;
    if (acc.length == 0 || [acc isEqualToString:@""] || [[acc stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入光大银行账户!"];
        return;
    }
    if (phone.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
    if (phone.length!= 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入11位的手机号"];
        return;
    }
    if (code.length == 0 || [code isEqualToString:@""] || [[code stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码!"];
        return;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:self.dict];
    dic[@"accountNumber"] = acc;
    dic[@"reservePhone"] = phone;
    dic[@"verificationCode"] = code;
    
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:user_bindGuangDaAccount parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"已绑定!"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

/**
 没有光大银行账户 去注册
 */
- (void)zhuceAccount {
    NSString *str = @"https://open.cebbank.com/externalres/#/app/EarnestLogin?ChannelType=Control&Data=VXNlcklkPWtqd3hoY3kmQ2hhbm5lbElkPWtqd3hoY3kmTWFyaz0xJlJpc2VUaW1lPTIwMTkwNDI5MTQ1NTIwJlNpZ25hdHVyZT05QjIxMzkzMDYzQkVFMkMzQjU0NTMwNjI3ODJBNTA1QQ==";
    LxmWebViewController *webVC = [[LxmWebViewController alloc] init];
    webVC.navigationItem.title = @"注册账户";
    webVC.loadUrl = [NSURL URLWithString:str];
    [self.navigationController pushViewController:webVC animated:YES];
}


@end
