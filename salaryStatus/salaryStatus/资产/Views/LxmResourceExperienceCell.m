//
//  LxmResourceExperienceCell.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/26.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmResourceExperienceCell.h"
@interface LxmResourceExperienceCell()

@property (nonatomic, strong) NSMutableArray <UILabel *>*labs;

@property (nonatomic, assign) NSInteger row1;

@end

@implementation LxmResourceExperienceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier row:(NSInteger)row {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.row1 = row;
        self.labs = [NSMutableArray array];
        CGFloat w = floor(ScreenW / 5);
        for (int i = 0; i< 5; i++) {
            UILabel *titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(w*i, 0, w, 50)];
            titlelabel.textAlignment = NSTextAlignmentCenter;
            titlelabel.numberOfLines = 2;
            titlelabel.font = [UIFont systemFontOfSize:13];
            [self addSubview:titlelabel];
            [self.labs addObject:titlelabel];
        }
    }
    return self;
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    for (int i = 0; i < _dataArr.count; i++) {
        UILabel *titleLabel = _labs[i];
        if (self.row1 == 1) {
            titleLabel.textColor = CharacterGrayColor;
        } else {
            if (i == 2) {
                titleLabel.textColor = MineColor;
            } else {
                titleLabel.textColor = CharacterDarkColor;
            }
        }
        titleLabel.text = _dataArr[i];
    }
}



@end
