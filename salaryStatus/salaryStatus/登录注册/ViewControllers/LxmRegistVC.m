//
//  LxmRegistVC.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/26.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmRegistVC.h"
#import "LxmLoginVC.h"
#import "LxmBase64.h"
#import "LxmTabBarVC.h"
#import "LxmWebViewController.h"

@interface LxmRegistVC ()

@property (nonatomic, strong) UIView *headerView;//表头视图

@property (nonatomic, strong) LxmRegistView *phoneView;//手机号

@property (nonatomic, strong) LxmRegistView *passwordView;//密码

@property (nonatomic, strong) UIView *codeBgView;//验证码View背景

@property (nonatomic, strong) LxmRegistView *codeView;//验证码

@property (nonatomic, strong) UIButton *sendCodeBtn;//获取验证码

@property (nonatomic, strong) UIButton *registBtn;//注册

@property (nonatomic, strong) LxmAgreeButton *agreeButton;//协议

@property (nonatomic, strong) NSTimer *timer;//倒计时

@property (nonatomic, assign) int time;//倒计时时间

@end

@implementation LxmRegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"注册";
    [self initSubViews];
    [self setConstrains];
}
/**
 初始化子视图
 */
- (void)initSubViews {
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
    [rightButton addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightButton setTitle:@"登录" forState:UIControlStateNormal];
    [rightButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 300)];
    self.tableView.tableHeaderView = _headerView;
    
    [self.headerView addSubview:self.phoneView];
    [self.headerView addSubview:self.passwordView];
    [self.headerView addSubview:self.codeBgView];
    [self.codeBgView addSubview:self.codeView];
    [self.codeBgView addSubview:self.sendCodeBtn];
    [self.headerView addSubview:self.agreeButton];
    [self.headerView addSubview:self.registBtn];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = BGGrayColor;
    [_codeBgView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.codeBgView).offset(15);
        make.trailing.equalTo(self.codeBgView).offset(-15);
        make.bottom.equalTo(self.codeBgView);
        make.height.equalTo(@.5);
    }];
}

/**
 跳转登录页
 */
- (void)loginBtnClick {
    LxmLoginVC *vc = [[LxmLoginVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
    [self.codeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordView.mas_bottom);
        make.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@50);
    }];
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
    [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeView.mas_bottom);
        make.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@50);
    }];
    [self.registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.agreeButton.mas_bottom).offset(50);
        make.leading.equalTo(self.headerView).offset(15);
        make.trailing.equalTo(self.headerView).offset(-15);
        make.height.equalTo(@50);
    }];
    
    [self.codeView.rightTF mas_updateConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.codeView);
    }];
    [self.codeView layoutIfNeeded];
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

- (LxmAgreeButton *)agreeButton {
    if (!_agreeButton) {
        _agreeButton = [LxmAgreeButton new];
        [_agreeButton.selectButton addTarget:self action:@selector(agreeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_agreeButton.protocolButton addTarget:self action:@selector(seeProtocol) forControlEvents:UIControlEventTouchUpInside];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"我已阅读并同意" attributes:@{NSForegroundColorAttributeName: CharacterGrayColor}];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"《协议》" attributes:@{NSForegroundColorAttributeName:BlueColor}];
        [att appendAttributedString:str];
        _agreeButton.textLabel.attributedText = att;
    }
    return _agreeButton;
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
        [_sendCodeBtn addTarget:self action:@selector(getCodeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendCodeBtn;
}

- (UIButton *)registBtn {
    if (!_registBtn) {
        _registBtn = [[UIButton alloc] init];
        [_registBtn setBackgroundImage:[UIImage imageNamed:@"lightblue"] forState:UIControlStateNormal];
        [_registBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _registBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _registBtn.layer.cornerRadius = 5;
        _registBtn.layer.masksToBounds = YES;
        [_registBtn addTarget:self action:@selector(registClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registBtn;
}

- (void)agreeButtonClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.agreeButton.iconImgView.image = [UIImage imageNamed:btn.selected ? @"xuanzhong_y" : @"xuanzhong_n"];
}

/// 查看协议
- (void)seeProtocol {
    LxmWebViewController * vc = [[LxmWebViewController alloc] init];
    vc.navigationItem.title = @"协议";
    vc.hidesBottomBarWhenPushed = YES;
    vc.loadUrl = [NSURL URLWithString:@"https://app.salaryjumptech.com/docs/user_agreement.html"];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 "类型
 1员工注册
 2员工修改登录密码
 3员工修改提现密码
 4员工绑定银行卡验证码
 5中介注册
 6中介登录
 7中介绑定银行卡
 8中介提现验证码
 9员工忘记密码验证码
 10员工签署协议验证码
 11员工绑定光大银行账户
 12中介绑定光大银行账户"
 */
- (void)getCodeClick {
    
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
    [dict setObject:@1 forKey:@"type"];
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

/**
 注册
 */
- (void)registClick {
    if (self.phoneView.rightTF.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    } else if (self.passwordView.rightTF.text.length == 0 || [self.passwordView.rightTF.text isEqualToString:@""] || [[self.passwordView.rightTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"请输入密码!"];
        return;
    } else if ([self.passwordView.rightTF.text containsString:@" "]){
        [SVProgressHUD showErrorWithStatus:@"密码不能输入带有空格的字符串"];
        return;
    } else if (self.passwordView.rightTF.text.length < 6 || self.passwordView.rightTF.text.length > 15){
        [SVProgressHUD showErrorWithStatus:@"密码长度在6~15位"];
        return;
    } else if (self.codeView.rightTF.text.length < 1){
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    } else if (!self.agreeButton.selectButton.selected) {
        [SVProgressHUD showErrorWithStatus:@"请先同意协议"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.phoneView.rightTF.text forKey:@"phone"];
    [dict setObject:[self.passwordView.rightTF.text base64EncodedString] forKey:@"password"];
    [dict setObject:self.codeView.rightTF.text forKey:@"verificationCode"];
    [dict setObject:@1 forKey:@"type"];

    [SVProgressHUD show];
    [LxmNetworking networkingPOST:app_regsiter parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1) {
            [LxmTool ShareTool].isLogin = YES;
            [LxmTool ShareTool].session_token = responseObject[@"result"][@"token"];
            [self loadMyUserInfoWithOkBlock:nil];
            [UIApplication sharedApplication].delegate.window.rootViewController = [[LxmTabBarVC alloc] init];
            [[LxmTool ShareTool] uploadDeviceToken];
        } else {
            [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}



@end

@implementation LxmRegistView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.textColor = CharacterDarkColor;
        _leftLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_leftLabel];
        
        _rightTF = [[UITextField alloc] init];
        _rightTF.font = [UIFont systemFontOfSize:15];
        [self addSubview:_rightTF];
        
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
        [self addSubview:_lineView];
        
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.width.equalTo(@85);
            make.height.equalTo(@50);
        }];
        [self.rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-15);
            make.leading.equalTo(self.leftLabel.mas_trailing);
            make.centerY.equalTo(self);
            make.height.equalTo(@50);
        }];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.bottom.equalTo(self);
            make.height.equalTo(@.5);
        }];
    }
    return self;
}

@end


@interface LxmAgreeButton()

@end
@implementation LxmAgreeButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImgView];
        [self addSubview:self.textLabel];
        [self addSubview:self.selectButton];
        [self addSubview:self.protocolButton];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@15);
        }];
        
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.iconImgView.mas_trailing).offset(10);
            make.centerY.equalTo(self);
        }];
        [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self);
            make.bottom.top.equalTo(self);
            make.trailing.equalTo(self.textLabel.mas_leading);
            make.centerY.equalTo(self);
        }];
        [self.protocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.iconImgView.mas_trailing).offset(10);
            make.bottom.top.trailing.equalTo(self);
        }];
    }
    return self;
}


- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton new];
    }
    return _selectButton;
}

- (UIButton *)protocolButton {
    if (!_protocolButton) {
        _protocolButton = [UIButton new];
    }
    return _protocolButton;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"xuanzhong_n"];
    }
    return _iconImgView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:13];
    }
    return _textLabel;
}
@end
