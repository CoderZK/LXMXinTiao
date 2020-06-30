//
//  LxmBankCradVC.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/30.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmBankCradVC.h"
#import "LxmResourceBannerModel.h"
#import "LxmAddCardVC.h"
#import "LxmSafeAutherVC.h"

@interface LxmBankCradVC ()

@property (nonatomic, strong) LxmBankCardFooterView *footerView;//表尾

@property (nonatomic, strong) LxmBankListModel *bankModel;//银行卡

@end

@implementation LxmBankCradVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"银行卡";
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self initTableFootView];
    [self loadBankData];
    WeakObj(self);
    [LxmEventBus registerEvent:@"bangBankSuccess" block:^(id data) {
        [selfWeak.navigationController popToViewController:self animated:YES];
        [selfWeak loadBankData];
    }];
}

/**
 获取银行卡
 */
- (void)loadBankData {
    [LxmNetworking networkingPOST:user_getBankCard parameters:@{@"token" : SESSION_TOKEN, @"type" : @1} returnClass:[LxmBankListRoot1Model class] success:^(NSURLSessionDataTask *task, LxmBankListRoot1Model *responseObject) {
        if (responseObject.key.intValue == 1) {
            self.bankModel = responseObject.result;
            self.footerView.hidden = self.bankModel;
            [self.tableView reloadData];
        }else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)initTableFootView {
    self.footerView = [[LxmBankCardFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 80)];
    [self.footerView addTarget:self action:@selector(footViewClick) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = self.footerView;
}

/**
 添加银行卡
 */
- (void)footViewClick {
    if ([LxmTool ShareTool].userModel.authStatus.intValue == 3) {
        LxmAddCardVC *vc = [[LxmAddCardVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmAddCardVC_type_add];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([LxmTool ShareTool].userModel.authStatus.intValue == 1){//去认证
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"您还未进行实名认证,请先进行实名认证!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            LxmSafeAutherVC *vc = [[LxmSafeAutherVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"暂不认证" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [alertController addAction:action1];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if ([LxmTool ShareTool].userModel.authStatus.intValue == 2) {
        [SVProgressHUD showErrorWithStatus:@"实名认证审核中,暂不能进行添加银行卡操作!"];
    }else if ([LxmTool ShareTool].userModel.authStatus.intValue == 4) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"实名认证失败,请先进行实名认证!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            LxmSafeAutherVC *vc = [[LxmSafeAutherVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"暂不认证" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [alertController addAction:action1];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bankModel ? 1 : 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.bankModel) {
        LxmBankCradCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmBankCradCell"];
        if (!cell) {
            cell = [[LxmBankCradCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmBankCradCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.bankListModel = self.bankModel;
        cell.cellRow = indexPath.row;
        return cell;
    }
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.bankModel) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"您已经有一张银行卡,确定要换绑这张银行卡吗!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            LxmAddCardVC *vc = [[LxmAddCardVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmAddCardVC_type_huanbang];
            vc.oldId = self.bankModel.id;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"暂不换绑" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [alertController addAction:action1];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.bankModel ? 90 : 0;
}

@end

@interface LxmBankCradCell ()

@property (nonatomic, strong) UIView *bgView;//背景

@property (nonatomic, strong) UILabel *detailLabel;//银行卡描述

@property (nonatomic, strong) UIImageView *setMorenImgView;//设置默认图 图片

@property (nonatomic, strong) UILabel *morenLabel;//设置默认卡

@end
@implementation LxmBankCradCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        [self setConstrains];
        
    }
    return self;
}

- (void)setBankModel:(LxmSalaryBankInfoModel *)bankModel {
    _bankModel = bankModel;
    _detailLabel.text = [NSString stringWithFormat:@"%@ %@",_bankModel.bank, _bankModel.cardNumber];
}
- (void)setBankListModel:(LxmBankListModel *)bankListModel {
    _bankListModel = bankListModel;
    _detailLabel.text = [NSString stringWithFormat:@"%@ %@",_bankListModel.bank, _bankListModel.cardNumber];
}

- (void)initSubViews {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.detailLabel];
    [self.bgView addSubview:self.setMorenImgView];
    [self.bgView addSubview:self.morenLabel];
}

- (void)setConstrains {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@75);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bgView).offset(15);
        make.centerY.equalTo(self.bgView);
    }];
    [self.setMorenImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_centerY).offset(-2.5);
        make.trailing.equalTo(self.bgView).offset(-30);
        make.width.height.equalTo(@18);
    }];
    [self.morenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_centerY).offset(2.5);
        make.centerX.equalTo(self.setMorenImgView);
    }];
    
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.layer.cornerRadius = 8;
        _bgView.layer.masksToBounds = YES;
        _bgView.backgroundColor =  self.bgView.backgroundColor = [UIColor colorWithRed:0/255.0 green:203/255.0 blue:237/255.0 alpha:1];
    }
    return _bgView;
}
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = UIColor.whiteColor;
        _detailLabel.text = @"华夏银行 **** **** **** 9980";
        _detailLabel.font = [UIFont systemFontOfSize:13];
    }
    return _detailLabel;
}
- (UIImageView *)setMorenImgView {
    if (!_setMorenImgView) {
        _setMorenImgView = [[UIImageView alloc] init];
        _setMorenImgView.image = [UIImage imageNamed:@"dui_y"];
        _setMorenImgView.backgroundColor = [UIColor whiteColor];
        _setMorenImgView.layer.cornerRadius = 9;
        _setMorenImgView.layer.masksToBounds = YES;
        _setMorenImgView.hidden = YES;
    }
    return _setMorenImgView;
}
- (UILabel *)morenLabel {
    if (!_morenLabel) {
        _morenLabel = [[UILabel alloc] init];
        _morenLabel.textColor = UIColor.whiteColor;
        _morenLabel.font = [UIFont systemFontOfSize:12];
        _morenLabel.text = @"默认卡";
        _morenLabel.hidden = YES;
    }
    return _morenLabel;
}

- (void)setCellRow:(NSInteger)cellRow {
    _cellRow = cellRow;
    NSInteger i = _cellRow%3;
    switch (i) {
        case 0:
            self.bgView.backgroundColor = [UIColor colorWithRed:0/255.0 green:203/255.0 blue:237/255.0 alpha:1];
            break;
        case 1:
            self.bgView.backgroundColor = [UIColor colorWithRed:252/255.0 green:181/255.0 blue:94/255.0 alpha:1];
            break;
        case 2:
            self.bgView.backgroundColor = [UIColor colorWithRed:253/255.0 green:103/255.0 blue:94/255.0 alpha:1];
            break;
        default:
            break;
    }
}

@end


/**
 表尾视图
 */
@interface LxmBankCardFooterView ()

@property (nonatomic, strong) UIView *lineView1;

@property (nonatomic, strong) UILabel *addLabel;//+

@property (nonatomic, strong) UILabel *addTextLabel;//添加银行卡

@property (nonatomic, strong) UIView *lineView2;

@end
@implementation LxmBankCardFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.lineView1];
    [self addSubview:self.addLabel];
    [self addSubview:self.addTextLabel];
    [self addSubview:self.lineView2];
    
}

- (void)setConstrains {
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@0.5);
    }];
    [self.addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@30);
    }];
    [self.addTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.addLabel.mas_trailing);
        make.centerY.equalTo(self);
    }];
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.bottom.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@0.5);
    }];
}

- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = BGGrayColor;
    }
    return _lineView1;
}

- (UILabel *)addLabel {
    if (!_addLabel) {
        _addLabel = [[UILabel alloc] init];
        _addLabel.text = @"+";
        _addLabel.textColor = CharacterDarkColor;
        _addLabel.font = [UIFont systemFontOfSize:18];
    }
    return _addLabel;
}

- (UILabel *)addTextLabel {
    if (!_addTextLabel) {
        _addTextLabel = [[UILabel alloc] init];
        _addTextLabel.textColor = CharacterDarkColor;
        _addTextLabel.text = @"添加银行卡";
        _addTextLabel.font = [UIFont systemFontOfSize:15];
    }
    return _addTextLabel;
}

- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = BGGrayColor;
    }
    return _lineView2;
}

@end
