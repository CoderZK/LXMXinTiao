//
//  LxmUploadAlertView.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/29.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmUploadAlertView.h"

@interface LxmUploadAlertView()

@property (nonatomic,strong) UIView * contentView;

@property (nonatomic, strong) UILabel *textLabel;//文字

@property (nonatomic, strong) UIView *lineView;//线条

@property (nonatomic, strong) UIButton *sureButton;//确定

@property (nonatomic, strong) NSString *textStr;//文字

@property (nonatomic, assign) CGFloat textHeight;//文字高度

@end

@implementation LxmUploadAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.textStr = @"你的姓名、身份证、银行卡有效期、手机号中可能有信息不正确, 如你已更换了新卡, 可能是有效期更新了, 请解绑后重新绑定.";
        self.textHeight = [self.textStr getSizeWithMaxSize:CGSizeMake(ScreenW - 90, 999) withBoldFontSize:13].height;
        
        
        UIButton * bgBtn = [[UIButton alloc] initWithFrame:self.bounds];
        [bgBtn addTarget:self action:@selector(bgBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.textLabel];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.sureButton];
        [self setConstrains];
    }
    return self;
}

- (void)setConstrains {
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(20);
        make.leading.equalTo(self.contentView).offset(15);
        make.trailing.equalTo(self.contentView).offset(-15);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel.mas_bottom).offset(10);
        make.leading.equalTo(self.contentView).offset(15);
        make.trailing.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@.5);
    }];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.contentView);
        make.height.equalTo(@50);
    }];
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(30, 0, ScreenW - 60, 20 + self.textHeight + 10 + 50)];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.center = CGPointMake(ScreenW*0.5, ScreenH*0.5);
    }
    return _contentView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.numberOfLines = 0;
        _textLabel.textColor = CharacterDarkColor;
        _textLabel.text = self.textStr;
        _textLabel.font = [UIFont systemFontOfSize:13];
    }
    return _textLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] init];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:MineColor forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
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

- (void)sureButtonClick {
    [self dismiss];
}

- (void)bgBtnClick{
    [self dismiss];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}

@end
