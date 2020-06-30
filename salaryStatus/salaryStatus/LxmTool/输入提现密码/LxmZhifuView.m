//
//  LxmZhifuView.m
//  GatherEasyBuys
//
//  Created by 李晓满 on 2018/12/25.
//  Copyright © 2018年 DaLiu. All rights reserved.
//

#import "LxmZhifuView.h"
#import "WCLPassWordView.h"

@interface LxmZhifuView()<WCLPassWordViewDelegate>

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *backButton;//取消支付按钮

@property (nonatomic, strong) UILabel *textLabel;//请输入余额支付密码


@property (nonatomic, strong) UIView *lineView;

//@property (nonatomic, strong) UIButton *forgetButton;//忘记密码或重置密码

@property (nonatomic, strong) WCLPassWordView *passwordView;

@end

@implementation LxmZhifuView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.passwordView];
        [self.contentView addSubview:self.backButton];
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.lineView];
//        [self.contentView addSubview:self.forgetButton];
        [self setConstrains];
    }
    return self;
}

- (void)setConstrains {
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.contentView).offset(15);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backButton);
        make.centerX.equalTo(self.contentView);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backButton.mas_bottom).offset(15);
        make.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
//    [self.forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.contentView);
//        make.top.equalTo(self.passwordView.mas_bottom);
//        make.height.equalTo(@40);
//    }];
}

/**
 初始化子视图
 */
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 200)];
        _contentView.backgroundColor = UIColor.whiteColor;
    }
    return _contentView;
}

- (WCLPassWordView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[WCLPassWordView alloc] initWithFrame:CGRectMake(15, 80, ScreenW - 30, 70)];
        _passwordView.backgroundColor = [UIColor whiteColor];
        _passwordView.delegate = self;
    }
    return _passwordView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

/**
 *  监听输入的完成时
 */
- (void)passWordCompleteInput:(WCLPassWordView *)passWord {
    //钱包支付验证密码
    if (self.getPassword) {
        self.getPassword(passWord.textStore);
    }
}

//- (void)forgetButtonClick {
//    [self dismiss];
//    if (self.forgetPasswordBlock) {
//        self.forgetPasswordBlock();
//    }
//}



- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"back_1"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = CharacterDarkColor;
        _textLabel.text = @"请输入提现密码";
        _textLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _textLabel;
}

//- (UIButton *)forgetButton {
//    if (!_forgetButton) {
//        _forgetButton = [[UIButton alloc] init];
//        [_forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
//        [_forgetButton setTitleColor:[[UIColor blueColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
//        _forgetButton.titleLabel.font = [UIFont systemFontOfSize:14];
//        [_forgetButton addTarget:self action:@selector(forgetButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _forgetButton;
//}

- (void)backButtonClick {
    [self dismiss];
}

- (void)show {
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
//    WeakObj(self);
//    [UIView animateWithDuration:0.4 animations:^{
//        selfWeak.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
//        CGRect rect = selfWeak.contentView.frame;
//        rect.origin.y = selfWeak.bounds.size.height - selfWeak.contentView.bounds.size.height;
//        selfWeak.contentView.frame = rect;
//        [selfWeak layoutIfNeeded];
//    }];
}

- (void)dismiss {
//    WeakObj(self);
//    [UIView animateWithDuration:0.225 animations:^{
//        selfWeak.backgroundColor = [UIColor clearColor];
//        CGRect rect = selfWeak.contentView.frame;
//        rect.origin.y = selfWeak.bounds.size.height;
//        selfWeak.contentView.frame = rect;
//    } completion:^(BOOL finished) {
//        [selfWeak removeFromSuperview];
//    }];
    [self removeFromSuperview];
}

-(void)keyboardWillShow:(NSNotification *)noti
{
    CGRect keyboardFrame = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardFrame.origin.y;
    CGFloat space = 0;
    _contentView.frame =  CGRectMake(0, height - space - 200, ScreenW, 200);
}
-(void)keyboardWillHide:(NSNotification *)noti
{
    [self dismiss];
}


@end
