//
//  LxmDateHeaderView.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/4/18.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmDateHeaderView.h"

@implementation LxmDateHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.leading.equalTo(self).offset(15);
        }];
    }return self;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = UIColor.whiteColor;
        _titleLab.font = [UIFont boldSystemFontOfSize:20];
    }return _titleLab;
}

@end
