//
//  LxmMineVC.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/25.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmMineVC.h"
#import "LxmUserInfoVC.h"
#import "LxmSafeAutherVC.h"
#import "LxmBankCradVC.h"
#import "LxmSettingVC.h"
#import "LxmWebViewController.h"
#import "LxmHaveBankAccountVC.h"

@interface LxmMineVC ()

@end

@implementation LxmMineVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadMyUserInfoWithOkBlock:^{
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.title = @"我的";
    WeakObj(self);
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [selfWeak loadMyUserInfoWithOkBlock:^{
            [selfWeak endRefrish];
            [self.tableView reloadData];
        }];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        LxmMineHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmMineHeaderCell"];
        if (!cell) {
            cell = [[LxmMineHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmMineHeaderCell"];
        }
        cell.model = [LxmTool ShareTool].userModel;
        return cell;
    }
    LxmMineOtherCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmMineOtherCell"];
    if (!cell) {
        cell = [[LxmMineOtherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmMineOtherCell"];
    }
    if (indexPath.row == 1) {
        cell.iconImgView.image = [UIImage imageNamed:@"aqrz"];
        cell.titleLabel.text = @"安全认证";
        cell.detaillabel.hidden = NO;
        switch ([LxmTool ShareTool].userModel.authStatus.intValue) {
            case 1:
                 cell.detaillabel.text = @"未提交认证";
                break;
            case 2:
                 cell.detaillabel.text = @"提交审核中";
                break;
            case 3:
                 cell.selectionStyle = UITableViewCellSelectionStyleNone;
                 cell.detaillabel.text = @"已认证";
                break;
            case 4:
                 cell.detaillabel.text = @"审核驳回";
                break;
            default:
                 cell.detaillabel.text = @"";
                break;
        }
       
    } else if (indexPath.row == 2) {
        cell.iconImgView.image = [UIImage imageNamed:@"yhk"];
        cell.titleLabel.text = @"银行卡";
        cell.detaillabel.hidden = YES;
    } else if (indexPath.row == 3) {
        cell.iconImgView.image = [UIImage imageNamed:@"yhk"];
        cell.titleLabel.text = @"银行卡";
        cell.detaillabel.hidden = YES;
    } else if (indexPath.row == 4) {
        cell.iconImgView.image = [UIImage imageNamed:@"bzzx"];
        cell.titleLabel.text = @"帮助中心";
        cell.detaillabel.hidden = YES;
    } else {
        cell.iconImgView.image = [UIImage imageNamed:@"sz"];
        cell.titleLabel.text = @"设置";
        cell.detaillabel.hidden = YES;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 120;
    } else if (indexPath.row == 3) {
        return 0.01;
    } else {
        return 50;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        LxmUserInfoVC *vc = [[LxmUserInfoVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (indexPath.row == 1) {
        switch ([LxmTool ShareTool].userModel.authStatus.intValue) {
            case 1: {
                LxmSafeAutherVC *vc = [[LxmSafeAutherVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                return;
            case 2:
                [SVProgressHUD showErrorWithStatus:@"提交审核中"];
                return;
            case 3: {//已认证 测试 更改了
                LxmHaveBankAccountVC *vc = [[LxmHaveBankAccountVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                return;
            case 4: {
                LxmSafeAutherVC *vc = [[LxmSafeAutherVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
                return;
            default:
                break;
        }
       
    } else if (indexPath.row == 2) {
        [SVProgressHUD show];
        [LxmNetworking networkingPOST:user_getBankH5 parameters:@{@"token" : SESSION_TOKEN} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject[@"key"] intValue] == 1) {
                NSString * str = responseObject[@"result"][@"htmlContent"];
                if ([str isKindOfClass:[NSNull class]]||[str isEqualToString:@""]) {
                    str = @"";
                }else{
                    str = str;
                }
                
                NSString *version = [UIDevice currentDevice].systemVersion;
                NSString *url = @"";
                if (version.doubleValue >= 9.0) {
                    // 针对 9.0 以上的iOS系统进行处理
                    url = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                } else {
                    // 针对 9.0 以下的iOS系统进行处理
                    url = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                }
                
                
                LxmWebViewController * vc = [[LxmWebViewController alloc] init];
                vc.navigationItem.title = @"银行卡";
                vc.hidesBottomBarWhenPushed = YES;
                vc.loadUrl = [NSURL URLWithString:url];
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                [UIAlertController showAlertWithmessage:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];
        }];
       
    } else if (indexPath.row == 3) {
        LxmBankCradVC *vc = [[LxmBankCradVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 4) {
        
        LxmWebViewController * vc = [[LxmWebViewController alloc] init];
        vc.navigationItem.title = @"帮助中心";
        vc.hidesBottomBarWhenPushed = YES;
        vc.loadUrl = [NSURL URLWithString:@"https://app.salaryjumptech.com/appweb/HelpCenter.html"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        LxmSettingVC *vc = [[LxmSettingVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end

/**
 用户头像cell
 */
@interface LxmMineHeaderCell()

@property (nonatomic, strong) UILabel *nameLabel;//用户名

@property (nonatomic, strong) UILabel *idlabel;//用户id

@property (nonatomic, strong) UIImageView *renzhengStatusView;//认证状态

@property (nonatomic, strong) UIImageView *headerImgView;//用户头像

@end

@implementation LxmMineHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        [self setConstrains];
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = BGGrayColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.bottom.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}
- (void)setModel:(LxmUserInfoModel *)model {
    _model = model;
    self.nameLabel.text = _model.nickname ? _model.nickname : @"";
    //认证审核状态1未提交认证2提交审核中 3审核成功 4审核驳回
    self.renzhengStatusView.image = [UIImage imageNamed:_model.authStatus.intValue == 3 ? @"renzheng_y" : @"renzheng_n"];
    self.idlabel.text = [NSString stringWithFormat:@"id: %@", _model.rndId ? _model.rndId : @""];
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:_model.avatar]] placeholderImage:[UIImage imageNamed:@"moren"]];
}

/**
 初始化子视图
 */
- (void)initSubViews {
    [self addSubview:self.nameLabel];
    [self addSubview:self.renzhengStatusView];
    [self addSubview:self.idlabel];
    [self addSubview:self.headerImgView];
}

/**
 给子视图添加约束
 */
- (void)setConstrains {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.bottom.equalTo(self.mas_centerY);
        make.width.lessThanOrEqualTo(@(ScreenW - 32 - 30 - 70 -10));
    }];
    [self.renzhengStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.leading.equalTo(self.nameLabel.mas_trailing).offset(5);
        make.width.equalTo(@32);
        make.height.equalTo(@16);
    }];
    [self.idlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.leading.equalTo(self).offset(15);
        make.trailing.lessThanOrEqualTo(self).offset(-85);
    }];
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.trailing.equalTo(self).offset(-16);
        make.width.height.equalTo(@70);
    }];
    
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = CharacterDarkColor;
        _nameLabel.font = [UIFont boldSystemFontOfSize:18];
        _nameLabel.text = @"用户名";
    }
    return _nameLabel;
}

- (UIImageView *)renzhengStatusView {
    if (!_renzhengStatusView) {
        _renzhengStatusView = [[UIImageView alloc] init];
        _renzhengStatusView.image = [UIImage imageNamed:@"renzheng_n"];
    }
    return _renzhengStatusView;
}

- (UILabel *)idlabel {
    if (!_idlabel) {
        _idlabel = [[UILabel alloc] init];
        _idlabel.textColor = CharacterLightGrayColor;
        _idlabel.font = [UIFont systemFontOfSize:13];
        _idlabel.text = @"id: 85745641531536413654";
    }
    return _idlabel;
}
- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.layer.cornerRadius = 35;
        _headerImgView.layer.masksToBounds = YES;
        _headerImgView.image = [UIImage imageNamed:@"touxiang"];
    }
    return _headerImgView;
}

@end


/**
 我的界面其他样式cell
 */
@interface LxmMineOtherCell ()

@property (nonatomic, strong) UIImageView *accimgView;//箭头

@end

@implementation LxmMineOtherCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        [self initSubViews];
        [self setConstrains];
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = BGGrayColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(15);
            make.trailing.equalTo(self).offset(-15);
            make.bottom.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

/**
 添加子视图
 */
- (void)initSubViews {
    [self addSubview:self.iconImgView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.detaillabel];
    [self addSubview:self.accimgView];
}

/**
 设置约束
 */
- (void)setConstrains {
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@25);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImgView.mas_trailing).offset(10);
        make.centerY.equalTo(self);
    }];
    [self.detaillabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.accimgView.mas_leading).offset(-10);
        make.centerY.equalTo(self);
    }];
    [self.accimgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@10);
    }];
}

/**
 懒加载子视图
 */
- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = CharacterDarkColor;
    }
    return _titleLabel;
}

- (UILabel *)detaillabel {
    if (!_detaillabel) {
        _detaillabel = [[UILabel alloc] init];
        _detaillabel.textColor = CharacterLightGrayColor;
        _detaillabel.font = [UIFont systemFontOfSize:15];
    }
    return _detaillabel;
}
- (UIImageView *)accimgView {
    if (!_accimgView) {
        _accimgView = [[UIImageView alloc] init];
        _accimgView.image = [UIImage imageNamed:@"xiayiye"];
    }
    return _accimgView;
}

@end
