//
//  LxmVerityHeTongAlertView.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/2/22.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmVerityHeTongAlertView.h"
@interface LxmVerityHeTongAlertView()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *titleLabel;//验证

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) UILabel *yanzhengmaLabel;//验证码

@property (nonatomic, strong) UITextField *codeTF;//输入验证码

@property (nonatomic, strong) LxmSureProtocolButton *protocolButton;//同意协议

@property (nonatomic, strong) UIButton *sendCodeButton;//发送验证码

@property (nonatomic, strong) UIButton *finishButton;//完成

@property (nonatomic, strong) UIButton *bgButton;//背景按钮

@property (nonatomic, strong) NSTimer *timer;//倒计时

@property (nonatomic, assign) int time;//倒计时时间

@end

@implementation LxmVerityHeTongAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.bgButton = [[UIButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.bgButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.bgButton];
        
        [self addSubview:self.contentView];
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

- (void)initSubViews {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.yanzhengmaLabel];
    [self.contentView addSubview:self.codeTF];
    [self.contentView addSubview:self.sendCodeButton];
    [self.contentView addSubview:self.protocolButton];
    [self.contentView addSubview:self.finishButton];
}

- (void)setConstrains {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.centerX.equalTo(self.contentView);
        make.height.equalTo(@20);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.leading.equalTo(self.contentView).offset(15);
        make.trailing.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@0.5);
    }];
    [self.yanzhengmaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(15);
        make.leading.equalTo(self.contentView).offset(15);
        make.width.equalTo(@60);
    }];
    [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.yanzhengmaLabel.mas_trailing).offset(15);
        make.top.equalTo(self.lineView.mas_bottom);
        make.width.equalTo(@(ScreenW - 130 - 60));
        make.height.equalTo(@50);
    }];
    [self.sendCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.lineView.mas_bottom);
        make.width.equalTo(@100);
        make.height.equalTo(@50);
    }];
    [self.protocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sendCodeButton.mas_bottom);
        make.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(@50);
    }];
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-15);
        make.leading.equalTo(self.contentView).offset(20);
        make.trailing.equalTo(self.contentView).offset(-20);
        make.height.equalTo(@44);
    }];
}

/**
 初始化子视图
 */
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 260, self.bounds.size.width, 260)];
        _contentView.backgroundColor = UIColor.whiteColor;
    }
    return _contentView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.text = @"验证";
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UILabel *)yanzhengmaLabel {
    if (!_yanzhengmaLabel) {
        _yanzhengmaLabel = [[UILabel alloc] init];
        _yanzhengmaLabel.textColor = CharacterDarkColor;
        _yanzhengmaLabel.font = [UIFont systemFontOfSize:14];
        _yanzhengmaLabel.text = @"验证码";
    }
    return _yanzhengmaLabel;
}

- (UITextField *)codeTF {
    if (!_codeTF) {
        _codeTF = [[UITextField alloc] init];
        _codeTF.textColor = CharacterDarkColor;
        _codeTF.font = [UIFont systemFontOfSize:14];
        _codeTF.keyboardType = UIKeyboardTypeNumberPad;
        _codeTF.placeholder = @"请输入验证码";
    }
    return _codeTF;
}

- (UIButton *)sendCodeButton {
    if (!_sendCodeButton) {
        _sendCodeButton = [[UIButton alloc] init];
        [_sendCodeButton setTitleColor:MineColor forState:UIControlStateNormal];
        _sendCodeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sendCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _sendCodeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_sendCodeButton addTarget:self action:@selector(getcodeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendCodeButton;
}
  
- (LxmSureProtocolButton *)protocolButton {
    if (!_protocolButton ) {
        _protocolButton = [[LxmSureProtocolButton alloc] init];
        [_protocolButton addTarget:self action:@selector(argreeClick:) forControlEvents:UIControlEventTouchUpInside];
        [_protocolButton.underlineButton addTarget:self action:@selector(seeProtocolClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _protocolButton;
}
//同意
- (void)argreeClick:(LxmSureProtocolButton *)btn {
    btn.selected = !btn.selected;
     self.protocolButton.iconImgView.image = [UIImage imageNamed:btn.selected ? @"gouxuan_1" : @"gouxuan_n"];
}
//查看协议
- (void)seeProtocolClick {
    if (self.seeProtocolBlock) {
        self.seeProtocolBlock();
    }
}

- (void)getcodeClick:(UIButton *)btn {
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:[LxmTool ShareTool].userModel.phone forKey:@"phone"];
    [dict setObject:@10 forKey:@"type"];
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:app_sendVerificationCode parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1) {
            [SVProgressHUD showErrorWithStatus:@"验证码已发送!"];
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
    self.sendCodeButton.enabled = NO;
    [self.sendCodeButton setTitle:[NSString stringWithFormat:@"获取(%ds)",self.time--] forState:UIControlStateNormal];
    if (self.time < 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.sendCodeButton.enabled = YES;
        [self.sendCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}


- (void)finishClick {
    if (self.protocolButton.selected) {
        if (self.codeTF.text.length == 0 || [self.codeTF.text isEqualToString:@""] || [[self.codeTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
            [SVProgressHUD showErrorWithStatus:@"请先输入验证码!"];
            return;
        }
        [self endEditing:YES];
        if (self.finishProtocolBlock) {
            self.finishProtocolBlock(self.codeTF.text);
        }
    }else {
        [SVProgressHUD showErrorWithStatus:@"请先同意协议!"];
    }
}

- (UIButton *)finishButton {
    if (!_finishButton) {
        _finishButton = [[UIButton alloc] init];
        [_finishButton setBackgroundImage:[UIImage imageNamed:@"lightblue"] forState:UIControlStateNormal];
        [_finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [_finishButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _finishButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _finishButton.layer.cornerRadius = 5;
        _finishButton.layer.masksToBounds = YES;
        [_finishButton addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishButton;
}



- (void)show {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [[UIApplication sharedApplication].delegate.window addSubview:self];
   
    _contentView.frame = CGRectMake(0, ScreenH, ScreenW, 260);
    WeakObj(self);
    [UIView animateWithDuration:0.4 animations:^{
        selfWeak.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.contentView.frame = CGRectMake(0, ScreenH - 260, ScreenW, 260);
    }];
}

- (void)dismiss {
    WeakObj(self);
    [self.codeTF resignFirstResponder];
    self.bgButton.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, ScreenH, ScreenW, 260);
    } completion:^(BOOL finished) {
        [selfWeak removeFromSuperview];
        self.bgButton.userInteractionEnabled = YES;
    }];
}

-(void)keyboardWillShow:(NSNotification *)noti {
    CGRect keyboardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardFrame.origin.y;
    CGFloat space = 0;
    _contentView.frame =  CGRectMake(0, height - space - 260, ScreenW, 260);
}
-(void)keyboardWillHide:(NSNotification *)noti {
    self.contentView.frame = CGRectMake(0, ScreenH - 260, ScreenW, 260);
}

- (void)closeView {
    [self dismiss];
}

@end


@interface LxmSureProtocolButton()

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) UILabel *agreeLabel;//同意

@property (nonatomic, strong) UILabel *underlineLabel;//协议

@end
@implementation LxmSureProtocolButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.lineView];
    [self addSubview:self.iconImgView];
    [self addSubview:self.agreeLabel];
    [self addSubview:self.underlineLabel];
    [self addSubview:self.underlineButton];
}

- (void)setConstrains {
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@0.5);
    }];
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@18);
    }];
    [self.agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(10);
        make.centerY.equalTo(self);
        make.width.equalTo(@30);
    }];
    [self.underlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.agreeLabel.mas_trailing).offset(2);
        make.bottom.equalTo(self.agreeLabel);
    }];
    [self.underlineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.agreeLabel.mas_trailing).offset(2);
        make.bottom.trailing.height.equalTo(self);
    }];
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"gouxuan_n"];
    }
    return _iconImgView;
}

- (UILabel *)agreeLabel {
    if (!_agreeLabel) {
        _agreeLabel = [[UILabel alloc] init];
        _agreeLabel.textColor = CharacterDarkColor;
        _agreeLabel.font = [UIFont systemFontOfSize:14];
        _agreeLabel.text = @"同意";
    }
    return _agreeLabel;
}

- (UILabel *)underlineLabel {
    if (!_underlineLabel) {
        _underlineLabel = [[UILabel alloc] init];
        _underlineLabel.textColor = MineColor;
        _underlineLabel.font = [UIFont systemFontOfSize:14];
        _underlineLabel.text = @"《协议》";
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"《协议》"
                                                                                    attributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone)}];
        [attrStr setAttributes:@{NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle)}
                         range:NSMakeRange(0, _underlineLabel.text.length)];
        _underlineLabel.attributedText = attrStr;
    }
    return _underlineLabel;
}

- (UIButton *)underlineButton {
    if (!_underlineButton) {
        _underlineButton = [[UIButton alloc] init];
        _underlineButton.backgroundColor = [UIColor clearColor];
    }
    return _underlineButton;
}

@end
