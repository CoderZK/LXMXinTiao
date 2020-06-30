//
//  LxmKeJieVC.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/30.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmKeJieVC.h"
#import "LxmAccountDetailVC.h"
#import "LxmZhifuView.h"
#import "LxmBankCradVC.h"
#import "LxmAddCardVC.h"
#import "LxmSafeAutherVC.h"
#import "LxmSettingPasswordVC.h"
#import "LxmBase64.h"
#import "LxmRegistVC.h"
#import "LxmWebViewController.h"

@interface LxmKeJieVC ()

@property (nonatomic, strong) UIView *headerView;//表头视图

@property (nonatomic, strong) UIView *bgAccountView;//可预支账户背景

@property (nonatomic, strong) UIView *kejieAccountView;//可预支账户

@property (nonatomic, strong) UILabel *moneyLabel;//可预支账户钱数

@property (nonatomic, strong) UILabel *textLabel;//可预支账户文字

@property (nonatomic, strong) UIView *footerView;//表尾视图

@property (nonatomic, strong) UIButton *tixianButton;//提现

@property (nonatomic, assign) LxmKeJieVC_type type;

@property (nonatomic, strong) LxmZhifuView *tixianView;//提现弹窗

@property (nonatomic, strong) LxmSalaryInfoModel *salaryInfoModel;//工资账户信息

@property (nonatomic, strong) UITextField *moneyTF;//输入钱数

@property (nonatomic, strong) LxmAgreeButton *agreeButton;//协议

@end

@implementation LxmKeJieVC

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(LxmKeJieVC_type)type {
    self = [super initWithTableViewStyle:style];
    if (self) {
        self.type = type;
    }
    return self;
}

- (LxmAgreeButton *)agreeButton {
    if (!_agreeButton) {
        _agreeButton = [LxmAgreeButton new];
        [_agreeButton.selectButton addTarget:self action:@selector(agreeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_agreeButton.protocolButton addTarget:self action:@selector(seeProtocol) forControlEvents:UIControlEventTouchUpInside];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"提取即代表你同意" attributes:@{NSForegroundColorAttributeName: CharacterGrayColor}];
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"《使用协议》" attributes:@{NSForegroundColorAttributeName:BlueColor}];
        [att appendAttributedString:str];
        _agreeButton.textLabel.attributedText = att;
    }
    return _agreeButton;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.type == LxmKeJieVC_type_kejie ? @"可预支额度" : @"工资账户";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tixianView = [[LxmZhifuView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    WeakObj(self);
    self.tixianView.getPassword = ^(NSString *password) {
        [selfWeak tixian:password];
    };
    [self initHeaderView];
    [self initFooterView];
    [self setHeaderConstrains];
    
    self.type == LxmKeJieVC_type_kejie ? [self loadPreborrowPageInfo] : [self loadSalaryPageInfo];
    self.textLabel.text = self.type == LxmKeJieVC_type_kejie ? @"可预支额度" : @"工资账户";
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        self.type == LxmKeJieVC_type_kejie ? [self loadPreborrowPageInfo] : [self loadSalaryPageInfo];
    }];
    [LxmEventBus registerEvent:@"bangBankSuccess" block:^(id data) {
        [selfWeak.navigationController popToViewController:self animated:YES];
        self.type == LxmKeJieVC_type_kejie ? [self loadPreborrowPageInfo] : [self loadSalaryPageInfo];
    }];
    [LxmEventBus registerEvent:@"tixianPasswordSetSuccess" block:^(id data) {
        [self.tixianView show];
    }];
}
//提现
- (void)tixian:(NSString *)password {
    NSString *str = self.type == LxmKeJieVC_type_kejie ? user_preborrowAccountCash : user_salaryAccountCash;
    NSDictionary *dict = @{
                                  @"token" : SESSION_TOKEN,
                                  @"cashPassword" : [password base64EncodedString],
                                  @"cashMoney" : self.moneyTF.text
                                  };
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:str parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] intValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"提现成功"];
            [self.tixianView dismiss];
            self.type == LxmKeJieVC_type_kejie ? [self loadPreborrowPageInfo] : [self loadSalaryPageInfo];
            [LxmEventBus sendEvent:@"tixianSuccess" data:nil];
        }else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


- (void)agreeButtonClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.agreeButton.iconImgView.image = [UIImage imageNamed:btn.selected ? @"xuanzhong_y" : @"xuanzhong_n"];
}

/// 查看协议
- (void)seeProtocol {
    LxmWebViewController * vc = [[LxmWebViewController alloc] init];
    vc.navigationItem.title = @"协议";
    vc.hidesBottomBarWhenPushed = YES;
    vc.loadUrl = [NSURL URLWithString:@"https://app.salaryjumptech.com/appweb/useProtocol.html"];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 获取工资账户数据
 */
- (void)loadSalaryPageInfo {
    [LxmNetworking networkingPOST:user_salaryPageInfo parameters:@{@"token" : SESSION_TOKEN} returnClass:[LxmSalaryInfoRootModel class] success:^(NSURLSessionDataTask *task, LxmSalaryInfoRootModel *responseObject) {
        [self endRefrish];
        if (responseObject.key.intValue == 1) {
            self.salaryInfoModel = responseObject.result;
            self.salaryInfoModel.type = 2;
            NSAttributedString *yuanAtt = [[NSAttributedString alloc] initWithString:@"￥" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]}];
            NSAttributedString *moneyAtt = [[NSAttributedString alloc] initWithString:self.salaryInfoModel.salaryBorrowAccount ? self.salaryInfoModel.salaryBorrowAccount : @"0" attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:30]}];
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:yuanAtt];
            [att appendAttributedString:moneyAtt];
            self.moneyLabel.attributedText = att;
            [self.tableView reloadData];
        }else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefrish];
    }];
}
/**
 获取可预支账户数据
 */
- (void)loadPreborrowPageInfo {
    [LxmNetworking networkingPOST:user_preborrowPageInfo parameters:@{@"token" : SESSION_TOKEN} returnClass:[LxmSalaryInfoRootModel class] success:^(NSURLSessionDataTask *task, LxmSalaryInfoRootModel *responseObject) {
        [self endRefrish];
        if (responseObject.key.intValue == 1) {
            self.salaryInfoModel = responseObject.result;
            self.salaryInfoModel.type = 1;
            NSAttributedString *yuanAtt = [[NSAttributedString alloc] initWithString:@"￥" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]}];
            NSAttributedString *moneyAtt = [[NSAttributedString alloc] initWithString:self.salaryInfoModel.preBorrowAccount ? self.salaryInfoModel.preBorrowAccount : @"0" attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:30]}];
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:yuanAtt];
            [att appendAttributedString:moneyAtt];
            self.moneyLabel.attributedText = att;
            [self.tableView reloadData];
        }else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefrish];
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (!self.salaryInfoModel.bankInfo) {
            LxmNoBankCardCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmNoBankCardCell"];
            if (!cell) {
                cell = [[LxmNoBankCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmNoBankCardCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            LxmBankCradCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmBankCradCell"];
            if (!cell) {
                cell = [[LxmBankCradCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmBankCradCell"];
            }
            cell.bankModel = self.salaryInfoModel.bankInfo;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
       
    } else {
        LxmPutinMoenyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmPutinMoenyCell"];
        if (!cell) {
            cell = [[LxmPutinMoenyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmPutinMoenyCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.salaryInfoModel = self.salaryInfoModel;
        self.moneyTF = cell.moneyTF;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (!self.salaryInfoModel.bankInfo) {
            [self loadMyUserInfoWithOkBlock:^{
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
            }];
            
            
        }else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"您已经有一张银行卡,确定要换绑这张银行卡吗!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                LxmAddCardVC *vc = [[LxmAddCardVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmAddCardVC_type_huanbang];
                vc.oldId = self.salaryInfoModel.bankInfo.id;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"暂不换绑" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:action];
            [alertController addAction:action1];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textColor = CharacterDarkColor;
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        titleLabel.tag = 111;
        [headerView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(headerView).offset(15);
            make.centerY.equalTo(headerView);
        }];
    }
    headerView.layer.masksToBounds = YES;
    headerView.contentView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [headerView viewWithTag:111];
    if (self.type == LxmKeJieVC_type_kejie) {
        titleLabel.text = section == 0 ? @"到账银行卡" : @"预支金额";
    } else {
        titleLabel.text = section == 0 ? @"到账银行卡" : @"提现金额";
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
//        return ((ScreenW - 30)*75/345) + 30;
        return 0.01;
    }
    return 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0.01 : 40;
}


- (void)initHeaderView {
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    [rightButton addTarget:self action:@selector(accountDetailBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightButton setTitle:@"账户明细" forState:UIControlStateNormal];
    [rightButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, ScreenW - 30, 160)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.headerView;
    
    [self.headerView addSubview:self.bgAccountView];
    [self.headerView addSubview:self.kejieAccountView];
    [self.kejieAccountView addSubview:self.moneyLabel];
    [self.kejieAccountView addSubview:self.textLabel];
}

-(void)initFooterView {
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 120)];
    self.tableView.tableFooterView = _footerView;
    [self.footerView addSubview:self.agreeButton];
    [self.footerView addSubview:self.tixianButton];
    
    [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self.footerView);
        make.width.equalTo(@(ScreenW - 10));
        make.height.equalTo(@44);
    }];
    [self.tixianButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.agreeButton.mas_bottom);
        make.centerX.equalTo(self.footerView);
        make.width.equalTo(@(ScreenW - 40));
        make.height.equalTo(@44);
    }];
    
}

/**
 设置头视图约束
 */
- (void)setHeaderConstrains {
    [self.bgAccountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).offset(30);
        make.leading.equalTo(self.headerView).offset(20);
        make.trailing.equalTo(self.headerView).offset(-20);
        make.height.equalTo(@100);
    }];
    [self.kejieAccountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).offset(25);
        make.leading.equalTo(self.headerView).offset(15);
        make.trailing.equalTo(self.headerView).offset(-15);
        make.height.equalTo(@110);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.kejieAccountView);
        make.bottom.equalTo(self.bgAccountView.mas_centerY);
    }];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.moneyLabel);
    }];
}

- (UIView *)bgAccountView {
    if (!_bgAccountView) {
        _bgAccountView = [[UIView alloc] init];
        _bgAccountView.backgroundColor = [UIColor whiteColor];
        _bgAccountView.layer.shadowColor = MineColor.CGColor;
        _bgAccountView.layer.shadowOffset = CGSizeZero;
        _bgAccountView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _bgAccountView.layer.shadowRadius = 10;//阴影半径，默认3
    }
    return _bgAccountView;
}

- (UIView *)kejieAccountView {
    if (!_kejieAccountView) {
        _kejieAccountView = [[UIView alloc] init];
        _kejieAccountView.backgroundColor = [UIColor whiteColor];
        _kejieAccountView.layer.cornerRadius = 10;
        _kejieAccountView.layer.masksToBounds = YES;
    }
    return _kejieAccountView;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = BlueColor;
    }
    return _moneyLabel;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:15];
        _textLabel.textColor = BlueColor;
        _textLabel.text = @"可预支额度";
    }
    return _textLabel;
}

- (UIButton *)tixianButton {
    if (!_tixianButton) {
        _tixianButton = [[UIButton alloc] init];
        [_tixianButton setBackgroundImage:[UIImage imageNamed:@"lightblue"] forState:UIControlStateNormal];
        if (self.type == LxmKeJieVC_type_kejie) {
            [_tixianButton setTitle:@"提取至光大银行账户" forState:UIControlStateNormal];
        } else {
           [_tixianButton setTitle:@"提现" forState:UIControlStateNormal];
        }
        
        [_tixianButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _tixianButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _tixianButton.layer.cornerRadius = 5;
        _tixianButton.layer.masksToBounds = YES;
        [_tixianButton addTarget:self action:@selector(tixianClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tixianButton;
}

/**
 提现
 */
- (void)tixianClick {
    if (self.type == LxmKeJieVC_type_kejie) {//可预支账户提现
        if (self.moneyTF.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入预支金额!"];
            return;
        } else if (self.moneyTF.text.length > 0 && self.moneyTF.text.floatValue == 0) {
            [SVProgressHUD showErrorWithStatus:@"输入金额不正确!"];
            return;
        } else if (self.moneyTF.text.length > 0 && self.moneyTF.text.floatValue > self.salaryInfoModel.preBorrowAccount.floatValue) {
            [SVProgressHUD showErrorWithStatus:@"预支金额不得大于可预支额度总金额!"];
            return;
        } else if (!self.agreeButton.selectButton.selected) {
            [SVProgressHUD showErrorWithStatus:@"请先同意协议"];
            return;
        }
    }else {//工资账户提现
        if (self.moneyTF.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入提现金额!"];
            return;
        }else if (self.moneyTF.text.length > 0 && self.moneyTF.text.floatValue == 0) {
            [SVProgressHUD showErrorWithStatus:@"输入金额不正确!"];
            return;
        }else if (self.moneyTF.text.length > 0 && self.moneyTF.text.floatValue > self.salaryInfoModel.salaryBorrowAccount.floatValue) {
            [SVProgressHUD showErrorWithStatus:@"提现金额不得大于工资账户总金额!"];
            return;
        } else if (!self.agreeButton.selectButton.selected) {
            [SVProgressHUD showErrorWithStatus:@"请先同意协议"];
            return;
        }
    }
    if ([LxmTool ShareTool].userModel.isSetCashPwd.intValue == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"您还未设置提现密码,确定要前往设置吗!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            LxmSettingPasswordVC *vc = [[LxmSettingPasswordVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmSettingPasswordVC_type_tixian];
            vc.isSetTiXian = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"暂不设置" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [alertController addAction:action1];
        [self presentViewController:alertController animated:YES completion:nil];
    }else {
        [self.tixianView show];
    }
}

/**
 账户明细
 */
- (void)accountDetailBtnClick {
    LxmAccountDetailVC_type type = self.type == LxmKeJieVC_type_kejie ? LxmAccountDetailVC_type_kejie : LxmAccountDetailVC_type_moneyAccount;
    LxmAccountDetailVC *vc = [[LxmAccountDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:type];
    [self.navigationController pushViewController:vc animated:YES];
}


@end


/**
 添加银行卡
 */
@interface LxmNoBankCardCell ()

@property (nonatomic, strong) UIImageView *bgImgView;//线条背景

@property (nonatomic, strong) UILabel *addLabel;//+

@property (nonatomic, strong) UILabel *addTextLabel;//添加银行卡

@end
@implementation LxmNoBankCardCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}
- (void)initSubViews {
    [self addSubview:self.bgImgView];
    [self addSubview:self.addLabel];
    [self addSubview:self.addTextLabel];
}

- (void)setConstrains {
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(15);
        make.trailing.bottom.equalTo(self).offset(-15);
    }];
    [self.addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgImgView);
        make.trailing.equalTo(self.addTextLabel.mas_leading);
        make.width.height.equalTo(@30);
    }];
    [self.addTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgImgView);
        make.centerX.equalTo(self).offset(15);
    }];
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.image = [UIImage imageNamed:@"bg_xuxian"];
    }
    return _bgImgView;
}

- (UILabel *)addLabel {
    if (!_addLabel) {
        _addLabel = [[UILabel alloc] init];
        _addLabel.text = @"+";
        _addLabel.textColor = CharacterGrayColor;
        _addLabel.font = [UIFont systemFontOfSize:18];
    }
    return _addLabel;
}

- (UILabel *)addTextLabel {
    if (!_addTextLabel) {
        _addTextLabel = [[UILabel alloc] init];
        _addTextLabel.textColor = CharacterGrayColor;
        _addTextLabel.text = @"添加银行卡";
        _addTextLabel.font = [UIFont systemFontOfSize:15];
    }
    return _addTextLabel;
}

@end

/**
 输入提现金额
 */
@interface LxmPutinMoenyCell ()

@property (nonatomic, strong) UIView *topView;//

@property (nonatomic, strong) UILabel *yuanLabel;//￥

@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) UIButton *allButton;//全部提现背景

@property (nonatomic, strong) UILabel *detailLabel;//本次提现描述

@property (nonatomic, strong) UILabel *alllabel;//全部提现标签

@end

@implementation LxmPutinMoenyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

- (void)setSalaryInfoModel:(LxmSalaryInfoModel *)salaryInfoModel {
    _salaryInfoModel = salaryInfoModel;
    if (_salaryInfoModel.type == 1) {
        self.detailLabel.text = [NSString stringWithFormat:@"本次可预支￥%.2f,",_salaryInfoModel.cashQuota.floatValue];
        self.alllabel.text = @"全部预支";
    } else {
        self.detailLabel.text = [NSString stringWithFormat:@"本次可提现￥%.2f,",_salaryInfoModel.cashQuota.floatValue];
        self.alllabel.text = @"全部提现";
    }
}

- (void)allButtonClick:(UIButton *)allBtn {
    self.moneyTF.text = [NSString stringWithFormat:@"%.2f",_salaryInfoModel.cashQuota.floatValue];
}

- (void)initSubViews {
    
    [self addSubview:self.topView];
    [self.topView addSubview:self.yuanLabel];
    [self.topView addSubview:self.moneyTF];
    [self.topView addSubview:self.lineView];
    
    [self addSubview:self.allButton];
    [self.allButton addSubview:self.detailLabel];
    [self.allButton addSubview:self.alllabel];
}

- (void)setConstrains {
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.leading.trailing.equalTo(self);
        make.height.equalTo(@45);
    }];
    [self.yuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    [self.moneyTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.yuanLabel.mas_trailing);
        make.trailing.equalTo(self.topView).offset(-15);
        make.centerY.equalTo(self.yuanLabel);
        make.height.equalTo(@45);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.topView).offset(15);
        make.trailing.equalTo(self.topView).offset(-15);
        make.bottom.equalTo(self.topView);
        make.height.equalTo(@0.5);
    }];
    [self.allButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.leading.trailing.equalTo(self);
        make.bottom.equalTo(self);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.allButton).offset(15);
        make.top.equalTo(self.topView.mas_bottom).offset(10);
    }];
    [self.alllabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.detailLabel.mas_trailing).offset(10);
        make.centerY.equalTo(self.detailLabel);
    }];
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
    }
    return _topView;
}
- (UILabel *)yuanLabel {
    if (!_yuanLabel) {
        _yuanLabel = [[UILabel alloc] init];
        _yuanLabel.text = @"￥";
        _yuanLabel.font = [UIFont boldSystemFontOfSize:30];
        _yuanLabel.textColor = UIColor.blackColor;
    }
    return _yuanLabel;
}
- (UITextField *)moneyTF {
    if (!_moneyTF) {
        _moneyTF = [[UITextField alloc] init];
        _moneyTF.font = [UIFont boldSystemFontOfSize:30];
        _moneyTF.textColor = CharacterDarkColor;
        _moneyTF.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _moneyTF;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = LineColor;
    }
    return _lineView;
}

- (UIButton *)allButton {
    if (!_allButton) {
        _allButton = [[UIButton alloc] init];
        [_allButton addTarget:self action:@selector(allButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _allButton;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.text = @"本次可提现￥59.47,";
        _detailLabel.textColor = CharacterGrayColor;
        _detailLabel.font = [UIFont systemFontOfSize:15];
    }
    return _detailLabel;
}

- (UILabel *)alllabel {
    if (!_alllabel) {
        _alllabel = [[UILabel alloc] init];
        _alllabel.textColor = MineColor;
        _alllabel.font = [UIFont systemFontOfSize:15];
    }
    return _alllabel;
}

@end
