//
//  LxmAccountDetailVC.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/31.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmAccountDetailVC.h"

@interface LxmAccountDetailVC ()

@property (nonatomic, assign) LxmAccountDetailVC_type type;

@property (nonatomic, strong) NSMutableArray <LxmAccountDetailModel *>*dataArray;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic,strong)NSMutableDictionary * dataDict;

@property (nonatomic,strong)NSArray * keyArr;

@end

@implementation LxmAccountDetailVC
- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(LxmAccountDetailVC_type)type {
    self = [super initWithTableViewStyle:style];
    if (self) {
        self.type = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type == LxmAccountDetailVC_type_qianbao) {
        self.navigationItem.title = @"工资钱包";
    } else if (self.type == LxmAccountDetailVC_type_kejie) {
        self.navigationItem.title = @"预借账户明细";
    } else {
        self.navigationItem.title = @"工资账户明细";
    }

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray array];
    self.page = 1;
    [self loadData];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self loadData];
    }];
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [self loadData];
    }];
}

- (void)loadData {
    NSString *str = @"";
    if (self.type == LxmAccountDetailVC_type_kejie) {
        str = user_preborrowAccountRecord;
    } else if (self.type == LxmAccountDetailVC_type_moneyAccount) {
        str = user_salaryAccountRecord;
    } else {//钱包
        str = user_moneyAccountDetail;
    }
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:str parameters:@{@"token" : SESSION_TOKEN,@"page" : @(self.page),@"pageSize":@10} returnClass:[LxmAccountDetailRootModel class] success:^(NSURLSessionDataTask *task, LxmAccountDetailRootModel  *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.intValue == 1) {
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:responseObject.result.list];
            [self handleDataArr:self.dataArray];
            [self.tableView reloadData];
        }else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)handleDataArr:(NSArray <LxmAccountDetailModel *> *)dataArr {
    NSMutableDictionary<NSString *, NSMutableArray<LxmAccountDetailModel *> *> *dict = [NSMutableDictionary dictionary];
    for (LxmAccountDetailModel *m in dataArr) {
        if (m.key) {
            NSMutableArray *subs = [dict objectForKey:m.key];
            if (!subs) {
                subs = [NSMutableArray array];
                [dict setObject:subs forKey:m.key];
            }
            [subs addObject:m];
        }
    }
    //分区用的key
    NSArray<NSString *> *keys = [[dict allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 longLongValue] > [obj2 longLongValue];
    }];
    self.dataDict = dict;
    self.keyArr = keys;
    NSLog(@"%@",self.keyArr);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.keyArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = [self.dataDict objectForKey:[self.keyArr objectAtIndex:section]];
    return arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmAccountDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmAccountDetailCell"];
    if (!cell) {
        cell = [[LxmAccountDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmAccountDetailCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *arr = [self.dataDict objectForKey:[self.keyArr objectAtIndex:
                                                indexPath.section]];
    LxmAccountDetailModel *model = arr[indexPath.row];
    if (self.type == LxmAccountDetailVC_type_qianbao) {
        cell.qianbaoModel = model;
    } else if (self.type == LxmAccountDetailVC_type_kejie) {
        cell.yujieModel = model;
    } else {
        cell.zhanghuModel = model;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = CharacterGrayColor;
        titleLabel.tag = 111;
        titleLabel.font = [UIFont systemFontOfSize:14];
        [headerView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(headerView).offset(15);
            make.centerY.equalTo(headerView);
        }];
    }
    NSArray *arr = [self.dataDict objectForKey:[self.keyArr objectAtIndex:section]];
    LxmAccountDetailModel *model = arr.firstObject;
    UILabel *titleLabel = (UILabel *)[headerView viewWithTag:111];
    titleLabel.text = model.sectionTitle;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

@end

@interface LxmAccountDetailCell ()

@property (nonatomic, strong) UIImageView *iconImgView;//图标

@property (nonatomic, strong) UILabel *nameLabel;//项目

@property (nonatomic, strong) UILabel *fukuanfangLabel;//付款方

@property (nonatomic, strong) UILabel *timeLabel;//时间

@property (nonatomic, strong) UILabel *moneyLabel;//钱数

@property (nonatomic, strong) UILabel *stateLabel;//到账状态

@end
@implementation LxmAccountDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        [self setConstrains];
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = BGGrayColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (void)setYujieModel:(LxmAccountDetailModel *)yujieModel {
    _yujieModel = yujieModel;
    _nameLabel.text = _yujieModel.remark;
    if (_yujieModel.type.intValue == 1 || _yujieModel.type.intValue == 4) {
         _moneyLabel.text = [NSString stringWithFormat:@"-%@",_yujieModel.money];
        _iconImgView.image = [UIImage imageNamed:@"tixian_2"];
        _stateLabel.hidden = NO;
        if (_yujieModel.cashStatus.intValue == 1) {
            _stateLabel.text = @"转账中";
        } else if (_yujieModel.cashStatus.intValue == 2) {
            _stateLabel.text = @"成功";
        } else if (_yujieModel.cashStatus.intValue == 3) {
            _stateLabel.text = @"失败";
        }
        _timeLabel.text = _yujieModel.createTime;
    } else {
         _moneyLabel.text = [NSString stringWithFormat:@"+%@",_yujieModel.money];
        _iconImgView.image = [UIImage imageNamed:@"tixian_1"];
        _stateLabel.hidden = YES;
        _timeLabel.text = _yujieModel.workTime;
    }
    
    self.fukuanfangLabel.hidden = YES;
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_centerY).offset(-5);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY).offset(5);
    }];
    [self layoutIfNeeded];
}

- (void)setZhanghuModel:(LxmAccountDetailModel *)zhanghuModel {
    _zhanghuModel = zhanghuModel;
    _nameLabel.text = _zhanghuModel.remark;
    if (_zhanghuModel.type.integerValue == 2 || _zhanghuModel.type.integerValue == 4) {
        _iconImgView.image = [UIImage imageNamed:@"tixian_1"];
        _moneyLabel.text = [NSString stringWithFormat:@"+%@",_zhanghuModel.money];
        if (_zhanghuModel.type.integerValue == 4) {
            self.timeLabel.text = _zhanghuModel.createTime;
        } else {
            self.timeLabel.text = _zhanghuModel.workTime;
        }
    } else {//5 6
        _iconImgView.image = [UIImage imageNamed:@"tixian_2"];
        _moneyLabel.text = [NSString stringWithFormat:@"-%@",_zhanghuModel.money];
    }
    if (_zhanghuModel.type.integerValue == 6) {
        _stateLabel.hidden = NO;
        if (_zhanghuModel.cashStatus.intValue == 1) {
            _stateLabel.text = @"转账中";
        } else if (_zhanghuModel.cashStatus.intValue == 2) {
            _stateLabel.text = @"成功";
        } else if (_zhanghuModel.cashStatus.intValue == 3) {
            _stateLabel.text = @"失败";
        }
    } else {
        _stateLabel.hidden = YES;
    }
    
    self.fukuanfangLabel.hidden = YES;
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_centerY).offset(-5);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY).offset(5);
    }];
    [self layoutIfNeeded];
}

- (void)setQianbaoModel:(LxmAccountDetailModel *)qianbaoModel {
    _qianbaoModel = qianbaoModel;
    
    _nameLabel.text = _qianbaoModel.remark;
    _moneyLabel.text = [NSString stringWithFormat:@"+%@",_qianbaoModel.amount];
    if (_qianbaoModel.status.intValue == 1) {
        _stateLabel.text = @"转账中";
        _iconImgView.image = [UIImage imageNamed:@"tixian_2"];
    } else if (_qianbaoModel.status.intValue == 2) {
        _stateLabel.text = @"成功";
        _iconImgView.image = [UIImage imageNamed:@"tixian_2"];
    } else if (_qianbaoModel.status.intValue == 3) {
        _stateLabel.text = @"失败";
        _iconImgView.image = [UIImage imageNamed:@"tixian_1"];
        
    }
    _fukuanfangLabel.text = _qianbaoModel.sendCompany;
    _timeLabel.text = _qianbaoModel.createTime;
}

/**
 初始化子视图
 */
- (void)initSubViews {
    [self addSubview:self.iconImgView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.fukuanfangLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.stateLabel];
}

/**
 添加约束
 */
- (void)setConstrains {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@50);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(10);
        make.bottom.equalTo(self.fukuanfangLabel.mas_top).offset(-5);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self.nameLabel);
    }];
    [self.fukuanfangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(10);
        make.centerY.equalTo(self.iconImgView);
    }];
    [self.timeLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(10);
        make.top.equalTo(self.fukuanfangLabel.mas_bottom).offset(5);
    }];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(5);
        make.trailing.equalTo(self).offset(-15);
    }];
}

/**
 懒加载子视图
 */
- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.layer.cornerRadius = 25;
        _iconImgView.layer.masksToBounds = YES;
        _iconImgView.image = [UIImage imageNamed:@"tixian_2"];
    }
    return _iconImgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont boldSystemFontOfSize:15];
        _nameLabel.textColor = CharacterDarkColor;
        _nameLabel.text = @"提现";
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = CharacterLightGrayColor;
        _timeLabel.text = @"2018-10-23 10:22";
    }
    return _timeLabel;
}

- (UILabel *)fukuanfangLabel {
    if (!_fukuanfangLabel) {
        _fukuanfangLabel = [[UILabel alloc] init];
        _fukuanfangLabel.font = [UIFont systemFontOfSize:12];
        _fukuanfangLabel.textColor = CharacterLightGrayColor;
    }
    return _fukuanfangLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.font = [UIFont boldSystemFontOfSize:18];
        _moneyLabel.textColor = CharacterDarkColor;
        _moneyLabel.text = @"-100";
    }
    return _moneyLabel;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = [UIFont systemFontOfSize:12];
        _stateLabel.textColor = UIColor.redColor;
    }
    return _stateLabel;
}

@end
