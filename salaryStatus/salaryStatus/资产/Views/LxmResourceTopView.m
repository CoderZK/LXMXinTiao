//
//  LxmResourceTopView.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/25.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmResourceTopView.h"

@interface LxmResourceTopView ()

@property (nonatomic, strong) NSMutableArray <UILabel *>*labs;

@end

@implementation LxmResourceTopView

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr {
    self = [super initWithFrame:frame];
    if (self) {
        self.labs = [NSMutableArray array];
        CGFloat w = floor(ScreenW / titleArr.count);
        for (int i = 0; i< titleArr.count; i++) {
            UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(w*i, 0, w, self.bounds.size.height)];
            titlelabel.text = titleArr[i];
            titlelabel.textAlignment = NSTextAlignmentCenter;
            titlelabel.numberOfLines = 2;
            titlelabel.textColor = CharacterGrayColor;
            titlelabel.font = [UIFont systemFontOfSize:13];
            [self addSubview:titlelabel];
            [self.labs addObject:titlelabel];
        }
    }
    return self;
}

- (void)setOrderType:(NSInteger)orderType {
    _orderType = orderType;
}

- (void)setTitleArr:(NSArray *)titleArr {
    _titleArr = titleArr;
    for (int i = 0; i < _titleArr.count; i++) {
        UILabel *titleLabel = _labs[i];
        titleLabel.textColor = CharacterDarkColor;
        titleLabel.text = _titleArr[i];
    }
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    for (int i = 0; i < _dataArr.count; i++) {
        UILabel *titleLabel = _labs[i];
        titleLabel.textColor = i == 2 ? MineColor : CharacterDarkColor;
        if (_orderType == 1) {
            titleLabel.text = _dataArr[i];
        }else {
            if (i == 1) {
                titleLabel.text = @"-";
            }else {
                titleLabel.text = _dataArr[i];
            }
        }
        
    }
}

@end
