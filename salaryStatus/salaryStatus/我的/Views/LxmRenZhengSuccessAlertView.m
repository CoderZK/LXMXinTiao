//
//  LxmRenZhengSuccessAlertView.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/9/4.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "LxmRenZhengSuccessAlertView.h"

@interface LxmRenZhengSuccessAlertView ()

@property (nonatomic,strong) UIView * contentView;

@property (nonatomic, strong) UIImageView *successimgView;//认证成功

@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) UIButton *backButton;//返回

@end

@implementation LxmRenZhengSuccessAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIButton * bgBtn = [[UIButton alloc] initWithFrame:self.bounds];
        [self addSubview:bgBtn];
        [self addSubview:self.contentView];
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

/**
 添加视图
 */
- (void)initSubViews {
    [self.contentView addSubview:self.successimgView];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.backButton];
}

/**
 设置约束
 */
- (void)setConstrains {
    [self.successimgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(30);
        make.centerX.equalTo(self.contentView);
        make.width.height.equalTo(@30);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.successimgView.mas_bottom).offset(10);
        make.centerX.equalTo(self);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel.mas_bottom).offset(25);
        make.centerX.equalTo(self);
        make.leading.trailing.equalTo(self.contentView);
        make.height.equalTo(@0.5);
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.bottom.trailing.equalTo(self.contentView);
        make.height.equalTo(@44);
    }];
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(40, 0, ScreenW - 80, 180)];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.center = CGPointMake(ScreenW*0.5, ScreenH*0.5);
    }
    return _contentView;
}

- (UIImageView *)successimgView {
    if (!_successimgView) {
        _successimgView = [UIImageView new];
    }
    return _successimgView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont boldSystemFontOfSize:15];
        _textLabel.textColor = CharacterDarkColor;
    }
    return _textLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = LineColor;
    }
    return _lineView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton new];
        [_backButton setTitle:@"返回" forState:UIControlStateNormal];
        [_backButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _backButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (void)setIsSuccess:(BOOL)isSuccess {
    _isSuccess = isSuccess;
    if (_isSuccess) {
        _textLabel.text = @"实名认证成功";
        _successimgView.image = [UIImage imageNamed:@"tongguo"];
    } else {
        _textLabel.text = @"实名认证失败";
        _successimgView.image = [UIImage imageNamed:@"weitongguo"];
    }
}

- (void)show {
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 1;
    _contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    WeakObj(self);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        selfWeak.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        selfWeak.contentView.transform = CGAffineTransformIdentity;
    } completion:nil];
    
}
- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)backClick {
    if (self.backBlock) {
        self.backBlock(self);
    }
}

@end
