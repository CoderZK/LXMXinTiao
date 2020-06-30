//
//  LxmVerifyPhoneVC.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/30.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmVerifyPhoneVC.h"

@interface LxmVerifyPhoneVC ()

@property (nonatomic, strong) UIView *headerView;//表头视图

@property (nonatomic, strong) UIView *topView;//

@property (nonatomic, strong) UILabel *label1;//接收验证码展示

@property (nonatomic, strong) UILabel *label2;;//绑定银行卡需要短信验证

@property (nonatomic, strong) LxmVerifyPhoneCodeView *codeView;//验证码

//@property (nonatomic, strong) UIButton *noCodeButton;//收不到验证码

@property (nonatomic, strong) UIButton *nextbutton;//下一步

@property (nonatomic, strong) NSTimer *timer;//倒计时

@property (nonatomic, assign) int time;//倒计时时间

@end

@implementation LxmVerifyPhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"验证手机号";
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self initSubViews];
    [self setConstrains];
    
    [self.timer invalidate];
    self.timer = nil;
    self.time = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
}

- (void)initSubViews {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 300)];
    self.tableView.tableHeaderView = _headerView;
    
    [self.headerView addSubview:self.topView];
    [self.topView addSubview:self.label1];
    [self.topView addSubview:self.label2];
    [self.headerView addSubview:self.codeView];
//    [self.headerView addSubview:self.noCodeButton];
    [self.headerView addSubview:self.nextbutton];
}

- (void)setConstrains {
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@150);
    }];
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topView.mas_centerY);
        make.centerX.equalTo(self.topView);
    }];
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_centerY);
        make.centerX.equalTo(self.topView);
    }];
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@50);
    }];
//    [self.noCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.codeView.mas_bottom);
//        make.trailing.equalTo(self.headerView).offset(-15);
//        make.height.equalTo(@50);
//    }];
    [self.nextbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.centerX.equalTo(self.headerView);
        make.width.equalTo(@(ScreenW - 60));
        make.height.equalTo(@50);
    }];
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
    }
    return _topView;
}

- (UILabel *)label1 {
    if (!_label1) {
        _label1 = [[UILabel alloc] init];
        _label1.text = [NSString stringWithFormat:@"接收验证码: %@", self.phone];
        _label1.textColor = CharacterDarkColor;
        _label1.font = [UIFont systemFontOfSize:15];
    }
    return _label1;
}

- (UILabel *)label2 {
    if (!_label2) {
        _label2 = [[UILabel alloc] init];
        _label2.text = @"绑定银行卡需要进行短信验证";
        _label2.textColor = CharacterGrayColor;
        _label2.font = [UIFont systemFontOfSize:10];
    }
    return _label2;
}

- (LxmVerifyPhoneCodeView *)codeView {
    if (!_codeView) {
        _codeView = [[LxmVerifyPhoneCodeView alloc] init];
        [_codeView.sendCodeButton addTarget:self action:@selector(sendCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeView;
}


//- (UIButton *)noCodeButton {
//    if (!_noCodeButton) {
//        _noCodeButton = [[UIButton alloc] init];
//        [_noCodeButton setTitle:@"收不到验证码" forState:UIControlStateNormal];
//        [_noCodeButton setTitleColor:MineColor forState:UIControlStateNormal];
//        _noCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
//        _noCodeButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
//        _noCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//        [_noCodeButton addTarget:self action:@selector(noCodeClick) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _noCodeButton;
//}

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
//类型  1员工注册 2员工修改登录密码 3员工修改提现密码4员工绑定银行卡验证码5中介注册6中介登录7中介绑定银行卡8中介提现验证码9员工忘记密码验证码10员工签署协议验证码
- (void)sendCodeClick:(UIButton *)btn {
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:self.phone forKey:@"phone"];
    [dict setObject:@4 forKey:@"type"];
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
    self.codeView.sendCodeButton.enabled = NO;
    [self.codeView.sendCodeButton setTitle:[NSString stringWithFormat:@"获取(%ds)",self.time--] forState:UIControlStateNormal];
    if (self.time < 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.codeView.sendCodeButton.enabled = YES;
        [self.codeView.sendCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

/**
 下一步
 */
- (void)nextClick {
    if (self.codeView.codeTF.text.length == 0 || [self.codeView.codeTF.text isEqualToString:@""] || [[self.codeView.codeTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码!"];
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = SESSION_TOKEN;
    dict[@"name"] = self.name;
    dict[@"cardNumber"] = self.cardNo;
    dict[@"type"] = @1;
    dict[@"bankId"] = self.bankId;
    dict[@"bank"] = self.bank;
    dict[@"reservePhone"] = self.phone;
    if (self.shiBieImageID) {
        dict[@"cardPic"] = self.shiBieImageID;
    }
    dict[@"verificationCode"] = self.codeView.codeTF.text;
    if (self.isHuanban) {
        dict[@"oldId"] = self.oldId;
    }
    
    NSString *str = self.isHuanban ? user_rebindBankCard : user_bindBankCard;
    
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:str parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] intValue] == 1) {
            if (self.isHuanban) {
                [SVProgressHUD showSuccessWithStatus:@"已换绑银行卡!"];
            }else {
                [SVProgressHUD showSuccessWithStatus:@"已绑定银行卡!"];
            }
            [LxmEventBus sendEvent:@"bangBankSuccess" data:nil];
        }else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}





/**
 收不到验证码
 */
- (void)noCodeClick {
    
}

@end


@interface LxmVerifyPhoneCodeView ()

@property (nonatomic, strong) UIView *lineView1;//线

@property (nonatomic, strong) UILabel *leftLabel;//验证码

@property (nonatomic, strong) UIView *lineView2;//线

@end

@implementation LxmVerifyPhoneCodeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.lineView1];
    [self addSubview:self.leftLabel];
    [self addSubview:self.codeTF];
    [self addSubview:self.sendCodeButton];
    [self addSubview:self.lineView2];
}

- (void)setConstrains {
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@0.5);
    }];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView1.mas_bottom);
        make.leading.equalTo(self).offset(15);
        make.width.equalTo(@80);
        make.centerY.equalTo(self);
    }];
    [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView1.mas_bottom);
        make.leading.equalTo(self.leftLabel.mas_trailing);
        make.trailing.equalTo(self.sendCodeButton.mas_leading);
        make.centerY.equalTo(self);
        make.height.equalTo(@49);
    }];
    [self.sendCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView1.mas_bottom);
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.width.equalTo(@100);
        make.height.equalTo(@49);
    }];
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@0.5);
    }];
}

- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = BGGrayColor;
    }
    return _lineView1;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.text = @"验证码";
        _leftLabel.textColor = CharacterDarkColor;
        _leftLabel.font = [UIFont systemFontOfSize:15];
    }
    return _leftLabel;
}

- (UITextField *)codeTF {
    if (!_codeTF) {
        _codeTF = [[UITextField alloc] init];
        _codeTF.placeholder = @"填写验证码";
        _codeTF.font = [UIFont systemFontOfSize:15];
        _codeTF.textColor = CharacterDarkColor;
    }
    return _codeTF;
}

- (UIButton *)sendCodeButton {
    if (!_sendCodeButton) {
        _sendCodeButton = [[UIButton alloc] init];
        [_sendCodeButton setTitleColor:CharacterLightGrayColor forState:UIControlStateNormal];
        [_sendCodeButton setTitle:@"重新发送 (45)" forState:UIControlStateNormal];
        _sendCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _sendCodeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _sendCodeButton;
}

- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = BGGrayColor;
    }
    return _lineView2;
}

@end
