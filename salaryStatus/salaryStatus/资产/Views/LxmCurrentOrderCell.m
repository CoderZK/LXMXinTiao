//
//  LxmCurrentOrderCell.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/25.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmCurrentOrderCell.h"
#import "LxmResourceTopView.h"

@interface LxmCurrentOrderCell ()

@property (nonatomic, strong) UIImageView *noneDataImgView;//没有数据时的图片

@property (nonatomic, strong) UILabel *noneDataLabel;//没有数据时的文字

@property (nonatomic, strong) LxmResourceTopView * topView;

@property (nonatomic, strong) LxmResourceTopView * bottomView;

@property (nonatomic, strong) NSArray * titleArr;

@property (nonatomic, assign) NSInteger section;

@end

@implementation LxmCurrentOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier section:(NSInteger)section {
    self.section = section;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.titleArr = section == 0 ? @[@"岗位", @"累计工时(h)", @"报酬(￥)", @"状态"] : @[@"工作次数", @"累计工时(h)", @"时薪(￥)", @"等级"];
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    self.bottomView.dataArr = _dataArr;
}

- (void)setCurrentDataModel:(LxmAssetCurrentOrderDataModel *)currentDataModel {
    _currentDataModel = currentDataModel;
    if (_currentDataModel) {
        self.noneDataImgView.hidden = YES;
        self.noneDataLabel.hidden = YES;
        self.topView.hidden = NO;
        self.bottomView.hidden = NO;
        if (_currentDataModel.orderType.intValue == 1) {
            //短期工
            self.topView.orderType = 1;
            self.bottomView.orderType = 1;
            self.titleArr = self.section == 0 ? @[@"岗位", @"累计工时(h)", @"时薪(￥)", @"状态"] : @[@"工作次数", @"累计工时(h)", @"时薪(￥)", @"等级"];
            self.topView.titleArr = self.titleArr;
        }else {
            //日结型
            self.topView.orderType = 2;
            self.bottomView.orderType = 2;
            self.titleArr = self.section == 0 ? @[@"岗位", @"累计工时(h)", @"报酬(￥)", @"状态"] : @[@"工作次数", @"累计工时(h)", @"时薪(￥)", @"等级"];
            self.topView.titleArr = self.titleArr;
        }
    }else {
        self.noneDataImgView.hidden = NO;
        self.noneDataLabel.hidden = NO;
        self.topView.hidden = YES;
        self.bottomView.hidden = YES;
    }
}

- (void)setOrderType:(NSInteger)orderType {
    _orderType = orderType;
    self.bottomView.orderType = _orderType;
}


- (void)setWorkProgressArr:(NSMutableArray<LxmAssetWorkSubProcessDataModel *> *)workProgressArr {
    _workProgressArr = workProgressArr;
    if (_workProgressArr.count == 0) {
        self.noneDataImgView.hidden = NO;
        self.noneDataLabel.hidden = NO;
        self.topView.hidden = YES;
        self.bottomView.hidden = YES;
    }else {
        self.noneDataImgView.hidden = YES;
        self.noneDataLabel.hidden = YES;
        self.topView.hidden = NO;
        self.bottomView.hidden = NO;
    }
}

/**
 初始化子视图
 */
- (void)initSubViews {
    //没有数据时的显示
    [self addSubview:self.noneDataImgView];
    [self addSubview:self.noneDataLabel];
    //有数据时的显示
    [self addSubview:self.topView];
    [self addSubview:self.bottomView];
}

/**
 设置约束
 */
- (void)setConstrains {
    //没有数据时
    [self.noneDataImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.centerX.equalTo(self);
        make.width.height.equalTo(@80);
    }];
    [self.noneDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.noneDataImgView.mas_bottom);
        make.centerX.equalTo(self);
        make.height.equalTo(@20);
    }];
    //有数据时
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.equalTo(@50);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.leading.trailing.equalTo(self);
        make.height.equalTo(@50);
    }];
}

/**
 没有数据时的字视图初始化 没有数据时  要求cell高度为150
 */
- (UIImageView *)noneDataImgView {
    if (!_noneDataImgView) {
        _noneDataImgView = [[UIImageView alloc] init];
        _noneDataImgView.image = [UIImage imageNamed:@"none"];
        _noneDataImgView.hidden = YES;
    }
    return _noneDataImgView;
}

- (UILabel *)noneDataLabel {
    if (!_noneDataLabel) {
        _noneDataLabel = [[UILabel alloc] init];
        _noneDataLabel.font = [UIFont systemFontOfSize:15];
        _noneDataLabel.textColor = CharacterLightGrayColor;
        _noneDataLabel.text = @"赶紧去接单吧";
        _noneDataLabel.hidden = YES;
    }
    return _noneDataLabel;
}

/**
 有数据时
 */
- (LxmResourceTopView *)topView {
    if (!_topView) {
        _topView = [[LxmResourceTopView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50) titleArr:self.titleArr];
        _topView.backgroundColor = BGGrayColor;
    }
    return _topView;
}

- (LxmResourceTopView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[LxmResourceTopView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50) titleArr:self.titleArr];
    }
    return _bottomView;
}

@end
