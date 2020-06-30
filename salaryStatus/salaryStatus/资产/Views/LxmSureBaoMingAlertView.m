//
//  LxmSureBaoMingAlertView.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/2/1.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmSureBaoMingAlertView.h"

@interface LxmSureBaoMingAlertView()

@property (nonatomic,strong) UIView * contentView;

@property (nonatomic,strong) UILabel * label;

@property (nonatomic,strong) UILabel * label1;

@property (nonatomic, strong) UIView *lineView;//线条

@property (nonatomic, strong) UIView *lineView1;//线条1

@property (nonatomic, strong) UIButton *cancelButton;//取消

@property (nonatomic, strong) UIButton *sureButton;//确定

@end

@implementation LxmSureBaoMingAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.label];
    [self.contentView addSubview:self.label1];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.lineView1];
    [self.contentView addSubview:self.cancelButton];
    [self.contentView addSubview:self.sureButton];
}

- (void)setConstrains {
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(25);
        make.centerX.equalTo(self.contentView);
    }];
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label.mas_bottom).offset(20);
        make.centerX.equalTo(self.contentView);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-50);
        make.leading.equalTo(self.contentView).offset(15);
        make.trailing.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@0.5);
    }];
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.centerX.equalTo(self.contentView);
        make.width.equalTo(@0.5);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.trailing.equalTo(self.lineView1.mas_leading);
        make.leading.bottom.equalTo(self.contentView);
    }];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.leading.equalTo(self.lineView1.mas_trailing);
        make.trailing.bottom.equalTo(self.contentView);
    }];
    
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(30, 0, ScreenW - 60, 165)];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.center = CGPointMake(ScreenW*0.5, ScreenH*0.5);
    }
    return _contentView;
}


- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textColor = CharacterDarkColor;
        _label.font = [UIFont systemFontOfSize:15];
        _label.text = @"是否确认报名入职本工作?";
    }
    return _label;
}

- (UILabel *)label1 {
    if (!_label1) {
        _label1 = [[UILabel alloc] init];
        _label1.numberOfLines = 0;
        _label1.textColor = CharacterLightGrayColor;
        _label1.font = [UIFont systemFontOfSize:12];
        _label1.text = @"报名成功之后将会由用人单位进行审核";
    }
    return _label1;
}


- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}
- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = BGGrayColor;
    }
    return _lineView1;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:CharacterDarkColor forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
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


- (void)cancelButtonClick {
     [self dismiss];
}

- (void)sureButtonClick {
     [self dismiss];
    if (self.sureBaoMingClick) {
        self.sureBaoMingClick();
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

- (void)bgBtnClick{
    [self dismiss];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}

@end
