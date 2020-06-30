//
//  LxmSelectView.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/29.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmSelectView.h"


@interface LxmSelectView ()

@property (nonatomic, strong) UIImageView *accImgView;//右侧箭头

@property (nonatomic, strong) UIView *lineView;//线

@end

@implementation LxmSelectView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.leftLabel];
    [self addSubview:self.rightLabel];
    [self addSubview:self.accImgView];
    [self addSubview:self.lineView];
}

- (void)setConstrains {
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.equalTo(@80);
    }];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.leftLabel.mas_trailing);
        make.centerY.equalTo(self);
        make.trailing.equalTo(self.accImgView.mas_leading);
    }];
    [self.accImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@15);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.textColor = CharacterDarkColor;
        _leftLabel.font = [UIFont systemFontOfSize:15];
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textColor = CharacterDarkColor;
        _rightLabel.font = [UIFont systemFontOfSize:15];
    }
    return _rightLabel;
}

- (UIImageView *)accImgView {
    if (!_accImgView) {
        _accImgView = [[UIImageView alloc] init];
        _accImgView.image = [UIImage imageNamed:@"xiayiye"];
    }
    return _accImgView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

@end


@interface LxmAgreeProtocolButton ()

@property (nonatomic, strong) UILabel *agreeLabel;//同意

@end

@implementation LxmAgreeProtocolButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.iconImgView];
    [self addSubview:self.agreeLabel];
    [self addSubview:self.protocolButton];
}

- (void)setConstrains {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@16);
    }];
    [self.agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(10);
        make.centerY.equalTo(self);
        make.width.equalTo(@30);
    }];
    [self.protocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.agreeLabel.mas_trailing);
        make.centerY.trailing.height.equalTo(self);
    }];
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
        _agreeLabel.textColor = CharacterLightGrayColor;
        _agreeLabel.text = @"同意";
        _agreeLabel.font = [UIFont systemFontOfSize:13];
    }
    return _agreeLabel;
}

- (UIButton *)protocolButton {
    if (!_protocolButton) {
        _protocolButton = [[UIButton alloc] init];
        _protocolButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_protocolButton setTitle:@"《同意协议》" forState:UIControlStateNormal];
        [_protocolButton setTitleColor:MineColor forState:UIControlStateNormal];
        _protocolButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _protocolButton;
}

@end
