//
//  LxmResourceHeaderView.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/25.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmResourceHeaderView.h"

@interface LxmResourceHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;//标题

@end

@implementation LxmResourceHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

- (void)setSection:(NSInteger)section {
    _section = section;
    self.titleLabel.text = _section == 0 ? @"当前订单" : @"薪跳历程";
}

- (void)setSection1:(NSInteger)section1 {
    _section1 = section1;
    self.titleLabel.text = @"薪跳历程";
}

@end
