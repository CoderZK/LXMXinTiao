//
//  LxmLoginVC.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/26.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmLoginVC.h"
#import "LxmRegistVC.h"
#import "LxmTabBarVC.h"
#import "LxmBase64.h"
#import "LxmSettingPasswordVC.h"

@interface LxmLoginVC ()

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) LxmRegistView *phoneView;

@property (nonatomic, strong) LxmRegistView *passwordView;

@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) UIButton *forgetPasswordButton;//忘记密码

@end

@implementation LxmLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"登录";
    [self initSubViews];
    [self setConstrains];
}
/**
 初始化子视图
 */
- (void)initSubViews {
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
    [rightButton addTarget:self action:@selector(registBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightButton setTitle:@"注册" forState:UIControlStateNormal];
    [rightButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 250)];
    self.tableView.tableHeaderView = _headerView;
    
    [self.headerView addSubview:self.phoneView];
    [self.headerView addSubview:self.passwordView];
    [self.headerView addSubview:self.forgetPasswordButton];
    [self.headerView addSubview:self.loginButton];
}
/**
 给子视图添加约束
 */
- (void)setConstrains {
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@50);
    }];
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneView.mas_bottom);
        make.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@50);
    }];
    [self.forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordView.mas_bottom);
        make.leading.equalTo(self.headerView);
        make.trailing.equalTo(self.headerView).offset(-15);
        make.height.equalTo(@50);
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.forgetPasswordButton.mas_bottom).offset(50);
        make.leading.equalTo(self.headerView).offset(15);
        make.trailing.equalTo(self.headerView).offset(-15);
        make.height.equalTo(@50);
    }];
}

/**
 懒加载子视图
 */
- (LxmRegistView *)phoneView {
    if (!_phoneView) {
        _phoneView = [[LxmRegistView alloc] init];
        _phoneView.leftLabel.text = @"手机号码";
        _phoneView.rightTF.placeholder = @"请输入手机号码";
        _phoneView.rightTF.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _phoneView;
}
- (LxmRegistView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[LxmRegistView alloc] init];
        _passwordView.leftLabel.text = @"密码";
        _passwordView.rightTF.placeholder = @"请输入密码";
        _passwordView.rightTF.secureTextEntry = YES;
    }
    return _passwordView;
}

- (UIButton *)forgetPasswordButton {
    if (!_forgetPasswordButton) {
        _forgetPasswordButton = [[UIButton alloc] init];
        [_forgetPasswordButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_forgetPasswordButton setTitleColor:MineColor forState:UIControlStateNormal];
        _forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _forgetPasswordButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_forgetPasswordButton addTarget:self action:@selector(forgetPassworkClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPasswordButton;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] init];
        [_loginButton setBackgroundImage:[UIImage imageNamed:@"lightblue"] forState:UIControlStateNormal];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _loginButton.layer.cornerRadius = 5;
        _loginButton.layer.masksToBounds = YES;
        [_loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}


- (void)registBtnClick {
    LxmRegistVC *vc = [[LxmRegistVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loginClick {
    [self.tableView.tableHeaderView endEditing:YES];
    if (self.phoneView.rightTF.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    } else if (self.passwordView.rightTF.text.length < 6 || self.passwordView.rightTF.text.length > 15){
        [SVProgressHUD showErrorWithStatus:@"密码长度在6~15位"];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.phoneView.rightTF.text forKey:@"phone"];
    [dict setObject:[self.passwordView.rightTF.text base64EncodedString] forKey:@"password"];
    [dict setObject:@1 forKey:@"type"];//类型 1员工登录 2中介登录
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:app_login parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1) {
            [LxmTool ShareTool].isLogin = YES;
            [LxmTool ShareTool].session_token = responseObject[@"result"][@"token"];
            [UIApplication sharedApplication].delegate.window.rootViewController = [[LxmTabBarVC alloc] init];
            [self loadMyUserInfoWithOkBlock:nil];
            [LxmTool ShareTool].pushToken = [LxmTool ShareTool].deviceToken;
            [[LxmTool ShareTool] uploadDeviceToken];
        } else if ([responseObject[@"key"] integerValue] == 10001) {
            [SVProgressHUD showErrorWithStatus:@"您还没有注册,请先注册!"];
        } else {
            [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)forgetPassworkClick {
    LxmSettingPasswordVC *vc = [[LxmSettingPasswordVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmSettingPasswordVC_type_forget];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
