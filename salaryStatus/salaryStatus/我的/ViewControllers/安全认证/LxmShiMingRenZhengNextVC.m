//
//  LxmShiMingRenZhengNextVC.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/9/4.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmShiMingRenZhengNextVC.h"
#import "LxmHaveBankAccountVC.h"

@interface LxmRenZhengView : UIView

@property (nonatomic, strong) UILabel *leftLabel;//左侧标题

@property (nonatomic, strong) UITextField *rightTF;//右侧输入

@property (nonatomic, strong) UIView *lineView;//线

@end

@implementation LxmRenZhengView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightTF];
        [self addSubview:self.lineView];
        [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
            make.width.equalTo(@80);
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

@interface LxmShiMingRenZhengNextVC ()

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) LxmRenZhengView *phoneView;//手机号

@property (nonatomic, strong) UIButton *codeBtn;//发送验证码

@property (nonatomic, strong) LxmRenZhengView *codeView;//验证码

@property (nonatomic, strong) UIButton *submitButton;//提交

@property (nonatomic, strong) NSTimer *timer;//倒计时

@property (nonatomic, assign) int time;//倒计时时间

@property (nonatomic, assign) BOOL isPop;

@end

@implementation LxmShiMingRenZhengNextVC

-(UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 320)];
    }
    return _headerView;
}

- (LxmRenZhengView *)phoneView {
    if (!_phoneView) {
        _phoneView = [[LxmRenZhengView alloc] init];
        _phoneView.leftLabel.text = @"手机号";
        _phoneView.rightTF.placeholder = @"请输入银行预留手机号";
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

- (LxmRenZhengView *)codeView {
    if (!_codeView) {
        _codeView = [[LxmRenZhengView alloc] init];
        _codeView.leftLabel.text = @"验证码";
        _codeView.rightTF.placeholder = @"请输入验证码";
    }
    return _codeView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"实名认证";
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self initHeaderView];
    self.isPop = YES;
}

- (void)initHeaderView {
    self.tableView.tableHeaderView = self.headerView;
    [self.headerView addSubview:self.phoneView];
    [self.headerView addSubview:self.codeBtn];
    [self.headerView addSubview:self.codeView];
    [self.headerView addSubview:self.submitButton];
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.equalTo(self.headerView);
        make.width.equalTo(@95);
        make.height.equalTo(@60);
    }];
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.headerView);
        make.trailing.equalTo(self.codeBtn.mas_leading);
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
    [dict setObject:@13 forKey:@"type"];
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
    NSString *code = self.codeView.rightTF.text;
    NSString *phone = self.phoneView.rightTF.text;
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
    dic[@"reservePhone"] = phone;
    dic[@"verificationCode"] = code;
    
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:user_submitBankFactorInfo parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1) {
            LxmKaiHuInfoModel *model = [LxmKaiHuInfoModel mj_objectWithKeyValues:responseObject[@"result"]];
            LxmHaveBankAccountVC *vc = [[LxmHaveBankAccountVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
            vc.dict = self.dict;
            vc.phone = phone;
            vc.code = code;
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}



@end
