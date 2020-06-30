
//
//  LxmSelectBankVC.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/30.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmSelectBankVC.h"
#import "LxmResourceBannerModel.h"


@interface LxmSelectBankVC ()

@property (nonatomic, strong) NSMutableArray <LxmBankListModel *>*dataArr;

@end

@implementation LxmSelectBankVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择银行";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataArr = [NSMutableArray array];
    
    [self loadBankListData];
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [self loadBankListData];
    }];
}

- (void)loadBankListData {
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:app_findBankList parameters:nil returnClass:[LxmBankListRootModel class] success:^(NSURLSessionDataTask *task, LxmBankListRootModel *responseObject) {
        [self endRefrish];
        if (responseObject.key.intValue == 1) {
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:responseObject.result];
            [self.tableView reloadData];
        }else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefrish];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmSelectBankCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSelectBankCell"];
    if (!cell) {
        cell = [[LxmSelectBankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSelectBankCell"];
    }
    LxmBankListModel *m = self.dataArr[indexPath.row];
    cell.model = m;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    for (LxmBankListModel *m in self.dataArr) {
        m.isSelect = NO;
    }
    LxmBankListModel *m = self.dataArr[indexPath.row];
    m.isSelect = !m.isSelect;
    if (self.LxmSelectBankBlock) {
        self.LxmSelectBankBlock(m);
    }
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

@end

@interface LxmSelectBankCell ()

@property (nonatomic, strong) UILabel *leftLabel;//银行

@property (nonatomic, strong) UIImageView *accimgView;//对号

@property (nonatomic, strong) UIView *lineView;//线

@end

@implementation LxmSelectBankCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.leftLabel];
    [self addSubview:self.accimgView];
    [self addSubview:self.lineView];
}

- (void)setConstrains {
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    [self.accimgView mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (UIImageView *)accimgView {
    if (!_accimgView) {
        _accimgView = [[UIImageView alloc] init];
        _accimgView.image = [UIImage imageNamed:@"dui_y"];
    }
    return _accimgView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = BGGrayColor;
    }
    return _lineView;
}

- (void)setModel:(LxmBankListModel *)model {
    _model = model;
    self.leftLabel.text = _model.name;
    self.accimgView.hidden = !_model.isSelect;
}

@end
