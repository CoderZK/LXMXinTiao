//
//  LxmSettingPasswordVC.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/28.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmSettingPasswordVC.h"
#import "LxmRegistVC.h"
#import "LxmBase64.h"
#import "LxmLoginVC.h"
#import "LxmTabBarVC.h"

@interface LxmSettingPasswordVC ()

@property (nonatomic, strong) UIView *headerView;//表头视图

@property (nonatomic, strong) LxmRegistView *phoneView;//手机号

@property (nonatomic, strong) LxmRegistView *passwordView;//密码

@property (nonatomic, strong) LxmRegistView *surePasswordView;//确认密码

@property (nonatomic, strong) UIView *codeBgView;//验证码View背景

@property (nonatomic, strong) LxmRegistView *codeView;//验证码

@property (nonatomic, strong) UIButton *sendCodeBtn;//获取验证码

@property (nonatomic, strong) UIButton *sureButton;//确认按钮

@property (nonatomic, assign) LxmSettingPasswordVC_type type;//页面类型

@property (nonatomic, strong) NSTimer *timer;//倒计时

@property (nonatomic, assign) int time;//倒计时时间

@end

@implementation LxmSettingPasswordVC

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(LxmSettingPasswordVC_type)type {
    self = [super initWithTableViewStyle:style];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == LxmSettingPasswordVC_type_forget) {
        self.navigationItem.title = @"设置登录密码";
    }else if (self.type == LxmSettingPasswordVC_type_login) {
        self.navigationItem.title = @"修改登录密码";
    }else {
        self.navigationItem.title = self.isSetTiXian ?  @"设置提现密码" : @"修改提现密码";
    }
    [self initSubViews];
    [self setConstrains];
}

/**
 初始化子视图
 */
- (void)initSubViews {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 260)];
    self.tableView.tableHeaderView = _headerView;
    
    if (self.type == LxmSettingPasswordVC_type_login  || self.type == LxmSettingPasswordVC_type_tixian) {
        [self.headerView addSubview:self.surePasswordView];
    }else if (self.type == LxmSettingPasswordVC_type_forget) {
        [self.headerView addSubview:self.phoneView];
    }
    
    [self.headerView addSubview:self.passwordView];
    [self.headerView addSubview:self.codeBgView];
    [self.codeBgView addSubview:self.codeView];
    [self.codeBgView addSubview:self.sendCodeBtn];
    [self.headerView addSubview:self.sureButton];
}

/**
 设置约束
 */
- (void)setConstrains {
    if (self.type == LxmSettingPasswordVC_type_login || self.type == LxmSettingPasswordVC_type_tixian) {
        [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self.headerView);
            make.height.equalTo(@50);
        }];
        [self.surePasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.passwordView.mas_bottom);
            make.leading.trailing.equalTo(self.passwordView);
            make.height.equalTo(@50);
        }];
        [self.codeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.surePasswordView.mas_bottom);
            make.leading.trailing.equalTo(self.headerView);
            make.height.equalTo(@50);
        }];
    }else if (self.type == LxmSettingPasswordVC_type_forget) {
        [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self.headerView);
            make.height.equalTo(@50);
        }];
        [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.phoneView.mas_bottom);
            make.leading.trailing.equalTo(self.phoneView);
            make.height.equalTo(@50);
        }];
        [self.codeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.passwordView.mas_bottom);
            make.leading.trailing.equalTo(self.headerView);
            make.height.equalTo(@50);
        }];
    }
    
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.codeBgView);
        make.trailing.equalTo(self.sendCodeBtn.mas_leading);
        make.height.equalTo(@50);
    }];
    [self.sendCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.codeBgView).offset(-15);
        make.top.equalTo(self.codeBgView);
        make.width.equalTo(@120);
        make.height.equalTo(@50);
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeView.mas_bottom).offset(50);
        make.leading.equalTo(self.headerView).offset(15);
        make.trailing.equalTo(self.headerView).offset(-15);
        make.height.equalTo(@50);
    }];
}

/**
 懒加载子视图
 */
- (LxmRegistView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[LxmRegistView alloc] init];
        _passwordView.leftLabel.text = @"新密码";
        _passwordView.rightTF.placeholder = @"请输入新密码";
        _passwordView.rightTF.secureTextEntry = YES;
    }
    return _passwordView;
}
- (LxmRegistView *)surePasswordView {
    if (!_surePasswordView) {
        _surePasswordView = [[LxmRegistView alloc] init];
        _surePasswordView.leftLabel.text = @"确认密码";
        _surePasswordView.rightTF.placeholder = @"再次输入新密码";
        _surePasswordView.rightTF.secureTextEntry = YES;
    }
    return _surePasswordView;
}

- (LxmRegistView *)phoneView {
    if (!_phoneView) {
        _phoneView = [[LxmRegistView alloc] init];
        _phoneView.leftLabel.text = @"手机号";
        _phoneView.rightTF.placeholder = @"请输入手机号";
    }
    return _phoneView;
}

- (UIView *)codeBgView {
    if (!_codeBgView) {
        _codeBgView = [[UIView alloc] init];
        _codeBgView.backgroundColor = [UIColor whiteColor];
    }
    return _codeBgView;
}

- (LxmRegistView *)codeView {
    if (!_codeView) {
        _codeView = [[LxmRegistView alloc] init];
        _codeView.lineView.hidden = YES;
        _codeView.leftLabel.text = @"验证码";
        _codeView.rightTF.placeholder = @"请输入验证码";
    }
    return _codeView;
}
- (UIButton *)sendCodeBtn {
    if (!_sendCodeBtn) {
        _sendCodeBtn = [[UIButton alloc] init];
        [_sendCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_sendCodeBtn setTitleColor:MineColor forState:UIControlStateNormal];
        _sendCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sendCodeBtn setBackgroundImage:[UIImage imageNamed:@"white"] forState:UIControlStateNormal];
        _sendCodeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_sendCodeBtn addTarget:self action:@selector(sendCodeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendCodeBtn;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] init];
        [_sureButton setBackgroundImage:[UIImage imageNamed:@"lightblue"] forState:UIControlStateNormal];
        [_sureButton setTitle:@"确认" forState:UIControlStateNormal];
        [_sureButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _sureButton.layer.cornerRadius = 5;
        _sureButton.layer.masksToBounds = YES;
        [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}
//设置密码
- (void)sureButtonClick {
    [self.tableView endEditing:YES];
    NSString *str = @"";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.type == LxmSettingPasswordVC_type_login || self.type == LxmSettingPasswordVC_type_forget) {
        if (self.type == LxmSettingPasswordVC_type_forget) {
            str = app_forgetPassword;
            if (self.phoneView.rightTF.text.length != 11) {
                [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
                return;
            } else if (self.passwordView.rightTF.text.length < 6 || self.passwordView.rightTF.text.length > 15){
                [SVProgressHUD showErrorWithStatus:@"密码长度在6~15位"];
                return;
            } else if (self.codeView.rightTF.text.length < 1){
                [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
                return;
            }
            [dict setObject:self.phoneView.rightTF.text forKey:@"phone"];
            [dict setObject:[self.passwordView.rightTF.text base64EncodedString] forKey:@"password"];
            [dict setObject:self.codeView.rightTF.text forKey:@"verificationCode"];
        } else {
            str = user_editLoginPassword;
            if (self.passwordView.rightTF.text.length < 6 || self.passwordView.rightTF.text.length > 15){
                [SVProgressHUD showErrorWithStatus:@"密码长度在6~15位"];
                return;
            }
            if (self.surePasswordView.rightTF.text.length < 6 || self.surePasswordView.rightTF.text.length > 15){
                [SVProgressHUD showErrorWithStatus:@"确认密码长度在6~15位"];
                return;
            }
            if (self.passwordView.rightTF.text.length != self.surePasswordView.rightTF.text.length) {
                 [SVProgressHUD showErrorWithStatus:@"两次输入的密码长度不一致!"];
                return;
            }
            if (![self.passwordView.rightTF.text isEqualToString:self.surePasswordView.rightTF.text]) {
                [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致!"];
                return;
            }
            if (self.codeView.rightTF.text.length < 1){
                [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
                return;
            }
            [dict setObject:SESSION_TOKEN forKey:@"token"];
            [dict setObject:[self.passwordView.rightTF.text base64EncodedString] forKey:@"password"];
            [dict setObject:self.codeView.rightTF.text forKey:@"verificationCode"];
        }
    }else {
        str = user_editCashPassword;
        if (self.passwordView.rightTF.text.length < 6 || self.passwordView.rightTF.text.length > 15){
            [SVProgressHUD showErrorWithStatus:@"密码长度在6~15位"];
            return;
        }
        if (self.surePasswordView.rightTF.text.length < 6 || self.surePasswordView.rightTF.text.length > 15){
            [SVProgressHUD showErrorWithStatus:@"确认密码长度在6~15位"];
            return;
        }
        if (self.passwordView.rightTF.text.length != self.surePasswordView.rightTF.text.length) {
            [SVProgressHUD showErrorWithStatus:@"两次输入的密码长度不一致!"];
            return;
        }
        if (![self.passwordView.rightTF.text isEqualToString:self.surePasswordView.rightTF.text]) {
            [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致!"];
            return;
        }
        if (self.codeView.rightTF.text.length < 1){
            [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
            return;
        }
        [dict setObject:SESSION_TOKEN forKey:@"token"];
        [dict setObject:[self.passwordView.rightTF.text base64EncodedString] forKey:@"password"];
        [dict setObject:self.codeView.rightTF.text forKey:@"verificationCode"];
    }
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:str parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"密码设置成功!"];
            if (self.type == LxmSettingPasswordVC_type_forget) {
                [LxmTool ShareTool].isLogin = YES;
                [LxmTool ShareTool].session_token = responseObject[@"result"][@"token"];
                [UIApplication sharedApplication].delegate.window.rootViewController = [[LxmTabBarVC alloc] init];
                [self loadMyUserInfoWithOkBlock:nil];
            }else if (self.type == LxmSettingPasswordVC_type_login){//修改登录密码
                [UIApplication sharedApplication].delegate.window.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:[[LxmLoginVC alloc] init]];
            }else {
               
                [self loadMyUserInfoWithOkBlock:nil];
                //修改提现密码
                if (self.isSetTiXian) {
                    [LxmEventBus sendEvent:@"tixianPasswordSetSuccess" data:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                    [SVProgressHUD showSuccessWithStatus:@"提现密码设置已设置!"];
                }else {
                     [SVProgressHUD showSuccessWithStatus:@"提现密码已修改!"];
                }
            }
        }else {
            [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}

- (void)sendCodeClick {
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    if (self.type == LxmSettingPasswordVC_type_forget) {
        if (self.phoneView.rightTF.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
            return;
        }
        if (self.phoneView.rightTF.text.length!= 11) {
            [SVProgressHUD showErrorWithStatus:@"请输入11位的手机号"];
            return;
        }
        [dict setObject:self.phoneView.rightTF.text forKey:@"phone"];
        [dict setObject:@2 forKey:@"type"];
    }else if (self.type == LxmSettingPasswordVC_type_login) {
        [dict setObject:[LxmTool ShareTool].userModel.phone forKey:@"phone"];
        [dict setObject:@2 forKey:@"type"];
    }else {
        [dict setObject:[LxmTool ShareTool].userModel.phone forKey:@"phone"];
        [dict setObject:@3 forKey:@"type"];
    }
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
    self.sendCodeBtn.enabled = NO;
    [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"获取(%ds)",self.time--] forState:UIControlStateNormal];
    if (self.time < 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.sendCodeBtn.enabled = YES;
        [self.sendCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

@end
