//
//  LxmOrderDetailVC.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/31.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmOrderDetailVC.h"
#import "LxmSureBaoMingAlertView.h"
#import "LxmVerityHeTongAlertView.h"
#import "LxmWebViewController.h"

@interface LxmOrderDetailVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *navBar;//导航栏

@property (nonatomic, strong) UIImageView *navBgImgView;//导航栏

@property (nonatomic, strong) UIButton *leftButton;//导航栏左侧按钮

@property (nonatomic, strong) UILabel *titleLabel;//导航栏title

@property (nonatomic, strong) UIView *bottomView;//底部视图

@property (nonatomic, strong) UIButton *nextbutton;//下一步

@property (nonatomic, strong) UITableView *headerView;//表头视图

@property (nonatomic, strong) UIButton *tableFooterView;//表尾视图

@property (nonatomic, strong) UIImageView *juImgView;//被拒原因图片

@property (nonatomic, strong) UILabel *jutextLabel;//被拒原因

@property (nonatomic, strong) UILabel *juDetailLabel;//被拒原因描述

@property (nonatomic, strong) LxmOrderDetailModel *rootModel;//订单全部信息

@property (nonatomic, strong) LxmOrderInfoModel *orderInforModel;//订单信息

@property (nonatomic, strong) NSArray <LxmXintiaoProcessModel *>*progressData;

@property (nonatomic, strong) NSString *leftStr;//左边标题

@property (nonatomic, strong) NSString *rightStr;//右边名称

@property (nonatomic, strong) LxmVerityHeTongAlertView *aletView;//协议弹窗

@end

@implementation LxmOrderDetailVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [LxmEventBus registerEvent:@"seeAllready" block:^(id data) {
        self.aletView.hidden = NO;
    }];
    [LxmEventBus registerEvent:@"singCompleted" block:^(id data) {
        [self loadOrderDetail];
    }];
}

- (UIView *)navBar {
    if (!_navBar) {
        _navBar = [[UIView alloc] init];
        _navBar.backgroundColor = [UIColor redColor];
    }
    return _navBar;
}

- (UIImageView *)navBgImgView {
    if (!_navBgImgView) {
        _navBgImgView = [[UIImageView alloc] init];
        _navBgImgView.image = [UIImage imageNamed:@"bg_dingbu"];
    }
    return _navBgImgView;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
        [_leftButton setImage:[UIImage imageNamed:@"home_back"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = UIColor.whiteColor;
    }
    return _titleLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.shadowColor = MineColor.CGColor;
        _bottomView.layer.shadowOffset = CGSizeZero;
        _bottomView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _bottomView.layer.shadowRadius = 10;//阴影半径，默认3
    }
    return _bottomView;
}

- (UIButton *)nextbutton {
    if (!_nextbutton) {
        _nextbutton = [[UIButton alloc] init];
        [_nextbutton setBackgroundImage:[UIImage imageNamed:@"lightblue"] forState:UIControlStateNormal];
        [_nextbutton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _nextbutton.titleLabel.font = [UIFont systemFontOfSize:15];
        _nextbutton.layer.cornerRadius = 5;
        _nextbutton.layer.masksToBounds = YES;
        [_nextbutton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextbutton;
}

- (void)nextClick {
    if (self.orderNo) {
        //扫码接单
        WeakObj(self);
        LxmSureBaoMingAlertView *alertView = [[LxmSureBaoMingAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alertView.sureBaoMingClick = ^{
            [selfWeak baoMing];
        };
        [alertView show];
    }else {
        if (self.rootModel) {//状态（0审核驳回 1报名待审核 2审核成功待签约 3待续签 4未签约（到点未签约） 5签约完成待录用 6录用工作进行时 7已结束）
            if (self.rootModel.orderStatus.intValue == 2 || self.rootModel.orderStatus.intValue == 3) {
                //上上签签署合同
             [self loadUrlProtocol];
//                //审核成功 去签署协议
//                [self.aletView show];
            }
        }
    }
    
}

/**
 扫码接单 报名
 */
- (void)baoMing {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.orderInforModel.orderType.intValue == 1) {
        dict[@"agencyId"] = self.agencyId;
    }
    dict[@"token"] = SESSION_TOKEN;
    dict[@"orderNo"] = self.orderNo;
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:user_enrollOrder parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"已报名!"];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


/**
 导航栏左侧按钮
 */
- (void)leftButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    [self initTableHeaderView];
    if (self.orderNo) {
        [self saomaOrder];
    }else {
        [self loadOrderDetail];
    }
    self.titleLabel.text = @"订单详情";
    self.aletView = [[LxmVerityHeTongAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    WeakObj(self);
    self.aletView.seeProtocolBlock = ^{
        [selfWeak loadProtocol];
    };
    self.aletView.finishProtocolBlock = ^(NSString *code) {
        [selfWeak signProtocol:code];
    };
}

/**
 获取上上签的链接地址
 */
- (void)loadUrlProtocol {
    self.nextbutton.userInteractionEnabled = NO;
    [LxmNetworking networkingPOST:user_signBestSignProtocol parameters:@{@"token" : SESSION_TOKEN, @"orderNo" : self.orderInforModel.orderNo} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        self.nextbutton.userInteractionEnabled = YES;
        if ([responseObject[@"key"] intValue] == 1) {
            self.aletView.hidden = YES;
            NSString * str = responseObject[@"result"][@"url"];
            if ([str isKindOfClass:[NSNull class]]||[str isEqualToString:@""]) {
                str = @"";
            }else{
                str = str;
            }
            LxmWebViewController * vc = [[LxmWebViewController alloc] init];
            vc.navigationItem.title = @"签约";
            vc.loadUrl = [NSURL URLWithString:str];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.nextbutton.userInteractionEnabled = YES;
    }];
}


/**
 要签署的协议内容
 */
- (void)loadProtocol {
    [self.aletView endEditing:YES];
    [LxmNetworking networkingPOST:user_getProtocolById parameters:@{@"token" : SESSION_TOKEN, @"orderNo" : self.orderInforModel.orderNo} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"key"] intValue] == 1) {
            self.aletView.hidden = YES;
            NSString * str = responseObject[@"result"][@"url"];
            if ([str isKindOfClass:[NSNull class]]||[str isEqualToString:@""]) {
                str = @"";
            }else{
                str = str;
            }
            LxmWebViewController * vc = [[LxmWebViewController alloc] init];
            vc.navigationItem.title = @"协议";
            vc.loadUrl = [NSURL URLWithString:str];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


/**
 员工签署协议合同
 */
- (void)signProtocol:(NSString *)code {
    
    NSDictionary *dict = @{
                           @"token" : SESSION_TOKEN,
                           @"verificationCode" : code,
                           @"orderNo" : self.orderInforModel.orderNo
                           };
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:user_signProtocol parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] integerValue] == 1) {
            [self.aletView dismiss];
            [SVProgressHUD showSuccessWithStatus:@"已签署合同!"];
            [self loadOrderDetail];
        }else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

//扫码获取到的详情
- (void)saomaOrder {
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:user_getOrderInfo parameters:@{@"token" : SESSION_TOKEN,@"orderNo" : self.orderNo} returnClass:[LxmOrderDetailRoot1Model class] success:^(NSURLSessionDataTask *task, LxmOrderDetailRoot1Model *responseObject) {
        [SVProgressHUD dismiss];
        self.orderInforModel = responseObject.result;
        self.titleLabel.text = @"扫码接单";
        self.bottomView.hidden = NO;
        [self.nextbutton setTitle:@"报名" forState:UIControlStateNormal];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.navBar.mas_bottom).offset(-7);
            make.leading.trailing.equalTo(self.view);
            make.bottom.equalTo(self.bottomView.mas_top);
        }];
        [self.headerView reloadData];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


//获取订单详情
- (void)loadOrderDetail {
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:user_queryOrderDetail parameters:@{@"token" : SESSION_TOKEN} returnClass:[LxmOrderDetailRootModel class] success:^(NSURLSessionDataTask *task, LxmOrderDetailRootModel *responseObject) {
        [SVProgressHUD dismiss];
        self.rootModel = responseObject.result;
        self.orderInforModel = responseObject.result.orderInfo;
        if (self.rootModel) {//状态（0审核驳回 1报名待审核 2审核成功待签约 3待续签 4未签约（到点未签约） 5签约完成待录用 6录用工作进行时 7已结束）
            switch (self.rootModel.orderStatus.intValue) {
                case 0://驳回
                    {
                        self.bottomView.hidden = YES;
                        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(self.navBar.mas_bottom).offset(-7);
                            make.leading.trailing.equalTo(self.view);
                            make.bottom.equalTo(self.view);
                        }];
                        [self initTableFooterView];
                        self.juDetailLabel.text = self.rootModel.reason;
                        [self.view layoutIfNeeded];
                    }
                        break;
                case 1://待审核
                    {
                        self.bottomView.hidden = YES;
                        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(self.navBar.mas_bottom).offset(-7);
                            make.leading.trailing.equalTo(self.view);
                            make.bottom.equalTo(self.view);
                        }];
                        [self.view layoutIfNeeded];
                    }
                    break;
                case 2://审核成功
                    {
                        self.bottomView.hidden = NO;
                        [self.nextbutton setTitle:@"去签署协议" forState:UIControlStateNormal];
                        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(self.navBar.mas_bottom).offset(-7);
                            make.leading.trailing.equalTo(self.view);
                            make.bottom.equalTo(self.bottomView.mas_top);
                        }];
                        [self.view layoutIfNeeded];
                    }
                    break;
                case 3://3待续签
                    {
                        self.bottomView.hidden = NO;
                        [self.nextbutton setTitle:@"去签署协议" forState:UIControlStateNormal];
                        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(self.navBar.mas_bottom).offset(-7);
                            make.leading.trailing.equalTo(self.view);
                            make.bottom.equalTo(self.bottomView.mas_top);
                        }];
                        [self.view layoutIfNeeded];
                    }
                        break;
                case 4://未签约（到点未签约
                    {
                        self.bottomView.hidden = YES;
                        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(self.navBar.mas_bottom).offset(-7);
                            make.leading.trailing.equalTo(self.view);
                            make.bottom.equalTo(self.view);
                        }];
                        [self.view layoutIfNeeded];
                    }
                        break;
                case 5://5签约完成待录用
                    {
                        self.bottomView.hidden = YES;
                        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(self.navBar.mas_bottom).offset(-7);
                            make.leading.trailing.equalTo(self.view);
                            make.bottom.equalTo(self.view);
                        }];
                        [self.view layoutIfNeeded];
                    }
                        break;
                case 6://6录用工作进行时
                    {
                        self.bottomView.hidden = YES;
                        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(self.navBar.mas_bottom).offset(-7);
                            make.leading.trailing.equalTo(self.view);
                            make.bottom.equalTo(self.view);
                        }];
                        [self.view layoutIfNeeded];
                    }
                        break;
                case 7://已结束
                    {
                        self.bottomView.hidden = YES;
                        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(self.navBar.mas_bottom).offset(-7);
                            make.leading.trailing.equalTo(self.view);
                            make.bottom.equalTo(self.view);
                        }];
                        [self.view layoutIfNeeded];
                    }
                        break;
                    
                default:
                    break;
            }
            [self.headerView reloadData];
            [self.tableView reloadData];
        }else {
            self.titleLabel.text = @"扫码接单";
            self.bottomView.hidden = NO;
            [self.nextbutton setTitle:@"确认接单" forState:UIControlStateNormal];
            [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.navBar.mas_bottom).offset(-7);
                make.leading.trailing.equalTo(self.view);
                make.bottom.equalTo(self.bottomView.mas_top);
            }];
        }
        [self.headerView reloadData];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


/**
 初始化
 */
- (void)initSubViews {
    [self.view addSubview:self.navBar];
    [self.navBar addSubview:self.navBgImgView];
    [self.navBar addSubview:self.leftButton];
    [self.navBar addSubview:self.titleLabel];
    
    [self.view addSubview:self.bottomView];
    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(StateBarH + 44));
    }];
    [self.navBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self.navBar);
    }];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.navBar).offset(20);
        make.top.equalTo(self.navBar).offset(StateBarH + 10);
        make.width.equalTo(@24);
        make.height.equalTo(@18);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftButton);
        make.centerX.equalTo(self.navBar);
    }];
    
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self.view);
        make.height.equalTo(@100);
    }];
    
    [self.bottomView addSubview:self.nextbutton];
    [self.nextbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bottomView);
        make.width.equalTo(@(ScreenW - 60));
        make.height.equalTo(@50);
    }];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view bringSubviewToFront:self.tableView];
    [self.view layoutIfNeeded];
}

- (void)initTableHeaderView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 400)];
    bgView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = bgView;
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(25, 5, ScreenW - 50, 390)];
    view1.backgroundColor = [UIColor whiteColor];
    view1.layer.shadowColor = MineColor.CGColor;
    view1.layer.shadowOffset = CGSizeZero;
    view1.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    view1.layer.shadowRadius = 10;//阴影半径，默认3
    [bgView addSubview:view1];
    
    
    _headerView = [[UITableView alloc] initWithFrame:CGRectMake(15, 0, ScreenW - 30, 400) style:UITableViewStyleGrouped];
    _headerView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _headerView.delegate = self;
    _headerView.dataSource = self;
    _headerView.backgroundColor = [UIColor whiteColor];
    _headerView.layer.cornerRadius = 10;
    _headerView.layer.masksToBounds = YES;
    [bgView addSubview:_headerView];
}

/**
 初始化表尾视图
 */
- (void)initTableFooterView {
    _tableFooterView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 200)];
    [_tableFooterView addTarget:self action:@selector(bejuReaseClick) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = _tableFooterView;
    
    _juImgView = [[UIImageView alloc] init];
    _juImgView.image = [UIImage imageNamed:@"bg_jujue"];
    [_tableFooterView addSubview:_juImgView];
    
    _jutextLabel = [[UILabel alloc] init];
    _jutextLabel.font = [UIFont boldSystemFontOfSize:15];
    _jutextLabel.text = @"驳回原因";
    [_tableFooterView addSubview:_jutextLabel];
    
    _juDetailLabel = [[UILabel alloc] init];
    _juDetailLabel.font = [UIFont systemFontOfSize:13];
    _juDetailLabel.textColor = CharacterLightGrayColor;
    _juDetailLabel.text = @"您的身份信息不符合招聘要求";
    [_tableFooterView addSubview:_juDetailLabel];
    
   
    
    [self.juImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableFooterView).offset(20);
        make.centerX.equalTo(self.tableFooterView);
        make.width.equalTo(@53);
        make.height.equalTo(@50);
    }];
    [self.jutextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.juImgView.mas_bottom).offset(10);
        make.centerX.equalTo(self.tableFooterView);
    }];
    [self.juDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.jutextLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.tableFooterView);
    }];
}

/**
 被拒原因
 */
- (void)bejuReaseClick {
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _headerView) {
        return 17;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _headerView) {
        LxmOrderDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmOrderDetailCell"];
        if (!cell) {
            cell = [[LxmOrderDetailCell alloc]   initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmOrderDetailCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case 0:
            {
                self.leftStr = @"公司名称";
                self.rightStr = self.orderInforModel.enterpriseName ? self.orderInforModel.enterpriseName : @"";
            }
                break;
            case 1:
            {
                self.leftStr = @"工作地点";
                self.rightStr = self.orderInforModel.address ? self.orderInforModel.address : @"";
            }
                break;
            case 2:
            {
                if (self.orderInforModel.calculateWay && [self.orderInforModel.calculateWay isEqualToString:@""]) {
                    self.leftStr = @"";
                    self.rightStr = @"";
                }else {
                    self.leftStr = @"结算方式";
                    self.rightStr = self.orderInforModel.calculateWay ? self.orderInforModel.calculateWay : @"";
                }
            }
                break;
            case 3:
            {
                self.leftStr = @"岗位";
                self.rightStr = self.orderInforModel.job ? self.orderInforModel.job : @"";
            }
                break;
            case 4:
            {
                self.leftStr = @"结算单价";
                if (self.orderInforModel.orderType.intValue == 1) {
                    self.rightStr = [NSString stringWithFormat:@"%@元/小时",self.orderInforModel.price];
                }else {
                    self.rightStr = [NSString stringWithFormat:@"%@元/天",self.orderInforModel.price];
                }
            }
                break;
            case 5:
            {
                self.leftStr = @"订单类型";
                self.rightStr = self.orderInforModel.orderType.intValue == 1 ? @"短期工" : @"日结";
            }
                break;
            case 6:
            {
                self.leftStr = @"开始时间";
                self.rightStr = [NSString formatterTime:self.orderInforModel.orderStartTime] ? [NSString formatterTime:self.orderInforModel.orderStartTime] : @"";
            }
                break;
            case 7:
            {
                self.leftStr = @"结束时间";
                self.rightStr = [NSString formatterTime:self.orderInforModel.orderEndTime] ? [NSString formatterTime:self.orderInforModel.orderEndTime] : @"";
            }
                break;
            case 8:
            {
                self.leftStr = @"报名截止时间";
                self.rightStr = [NSString formatterTime:self.orderInforModel.enrollEndTime] ? [NSString formatterTime:self.orderInforModel.enrollEndTime] : @"";
            }
                break;
            case 9:
            {
                if (self.orderInforModel.orderType.intValue == 2) {
                    self.leftStr = @"";
                    self.rightStr = @"";
                }else {
                    self.leftStr = @"工作时长";
                    self.rightStr = [NSString stringWithFormat:@"%d小时/天",self.orderInforModel.workDuration.intValue];
                }
            }
                break;
            case 10:
            {
                if (self.orderInforModel.orderType.intValue == 2) {
                    self.leftStr = @"";
                    self.rightStr = @"";
                }else {
                    self.leftStr = @"单日最低工时";
                    self.rightStr = [NSString stringWithFormat:@"%d小时/天",self.orderInforModel.lowHourDay.intValue];
                }
            }
                break;
            case 11:
            {
                if (self.orderInforModel.orderType.intValue == 2) {
                    self.leftStr = @"";
                    self.rightStr = @"";
                }else {
                    self.leftStr = @"休息时长";
                    self.rightStr = [NSString stringWithFormat:@"%d小时/天",self.orderInforModel.restDuration.intValue];
                }
            }
                break;
            case 12:
            {
                self.leftStr = @"工作说明";
                self.rightStr = self.orderInforModel.workDescription ? self.orderInforModel.workDescription : @"";
            }
                break;
            case 13:
            {
                self.leftStr = @"工作内容";
                self.rightStr = self.orderInforModel.workContent ? self.orderInforModel.workContent : @"";
            }
                break;
            case 14:
            {
                if (self.orderInforModel.orderType.intValue == 2) {
                    self.leftStr = @"";
                    self.rightStr = @"";
                }else {
                    self.leftStr = @"最低工作天数";
                    self.rightStr = [NSString stringWithFormat:@"%@天", self.orderInforModel.lowWorkDay];
                }
                
            }
                break;
            case 15:
            {
                self.leftStr = @"性别要求";
                self.rightStr = self.orderInforModel.genderRequire ? self.orderInforModel.genderRequire : @"";
            }
                break;
            case 16:
            {
                self.leftStr = @"年龄要求";
                self.rightStr = self.orderInforModel.ageRequire ? self.orderInforModel.ageRequire : @"";
            }
                break;
            default:
                break;
        }
        cell.leftLabel.text = self.leftStr;
        cell.rightLabel.text = self.rightStr;
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == _headerView) {
        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
        if (!headerView) {
            headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
            UILabel *orderLabel = [[UILabel alloc] init];
            orderLabel.font = [UIFont systemFontOfSize:12];
            orderLabel.textColor = CharacterDarkColor;
            orderLabel.tag = 111;
            [headerView addSubview:orderLabel];
            
            UILabel *stateLabel = [[UILabel alloc] init];
            stateLabel.font = [UIFont systemFontOfSize:12];
            stateLabel.textColor = UIColor.whiteColor;
            stateLabel.tag = 112;
            stateLabel.textAlignment = NSTextAlignmentCenter;
            stateLabel.layer.cornerRadius = 3;
            stateLabel.layer.masksToBounds = YES;
            [headerView addSubview:stateLabel];
            
            [orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(headerView).offset(15);
                make.centerY.equalTo(headerView);
                make.trailing.lessThanOrEqualTo(stateLabel.mas_leading).offset(-5);
            }];
            [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(headerView).offset(-15);
                make.centerY.equalTo(headerView);
                make.width.lessThanOrEqualTo(@80);
                make.height.equalTo(@20);
            }];
            [stateLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            
        }
        headerView.contentView.backgroundColor = [UIColor whiteColor];
        UILabel *orderLabel = [headerView viewWithTag:111];
        orderLabel.text = [NSString stringWithFormat:@"订单号: %@", self.orderInforModel.orderNo];
        
        UILabel *stateLabel = [headerView viewWithTag:112];
        
        if (self.rootModel) {//状态（0审核驳回 1报名待审核 2审核成功待签约 3待续签 4未签约（到点未签约） 5签约完成待录用 6录用工作进行时 7已结束）
            stateLabel.hidden = NO;
            switch (self.rootModel.orderStatus.intValue) {
                case 0://驳回
                {
                    stateLabel.text = @" 已驳回 ";
                    stateLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:67/255.0 blue:68/255.0 alpha:1];
                }
                    break;
                case 1://待审核
                {
                    stateLabel.text = @" 已报名 ";
                    stateLabel.backgroundColor = [UIColor colorWithRed:252/255.0 green:189/255.0 blue:14/255.0 alpha:1];
                }
                    break;
                case 2://审核成功
                {
                    stateLabel.text = @" 待签署 ";
                    stateLabel.backgroundColor = [UIColor colorWithRed:252/255.0 green:189/255.0 blue:14/255.0 alpha:1];
                }
                    break;
                case 3://3待续签
                {
                    stateLabel.text = @" 待续签 ";
                    stateLabel.backgroundColor = [UIColor colorWithRed:252/255.0 green:189/255.0 blue:14/255.0 alpha:1];
                }
                    break;
                case 4://未签约（到点未签约
                {
                    stateLabel.text = @" 未签约 ";
                    stateLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:67/255.0 blue:68/255.0 alpha:1];
                }
                    break;
                case 5://5签约完成待录用
                {
                    stateLabel.text = @" 待录用 ";
                    stateLabel.backgroundColor = [UIColor colorWithRed:252/255.0 green:189/255.0 blue:14/255.0 alpha:1];
                }
                    break;
                case 6://6录用工作进行时
                {
                    stateLabel.text = @" 工作进行时  ";
                    stateLabel.backgroundColor = MineColor;
                }
                    break;
                case 7://已结束
                {
                    stateLabel.text = @" 已结束 ";
                    stateLabel.backgroundColor = [UIColor colorWithRed:252/255.0 green:189/255.0 blue:14/255.0 alpha:1];
                }
                    break;
                    
                default:
                    break;
            }
        }else {
            //扫码
            stateLabel.hidden = YES;
        }
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * str = @"";
    switch (indexPath.row) {
        case 0:
        {
            str = self.orderInforModel.enterpriseName ? self.orderInforModel.enterpriseName : @"";
        }
            break;
        case 1:
        {
            str = self.orderInforModel.address ? self.orderInforModel.address : @"";
        }
            break;
        case 2:
        {
            str = self.orderInforModel.calculateWay ? self.orderInforModel.calculateWay : @"";
        }
            break;
        case 3:
        {
            str = self.orderInforModel.job ? self.orderInforModel.job : @"";
        }
            break;
        case 4:
        {
            if (self.orderInforModel.orderType.intValue == 1) {
                str = [NSString stringWithFormat:@"%@元/小时",self.orderInforModel.price];
            }else {
                str = [NSString stringWithFormat:@"%@元/天",self.orderInforModel.price];
            }
        }
            break;
        case 5:
        {
            str = self.orderInforModel.orderType.intValue == 1 ? @"短期工" : @"日结";
        }
            break;
        case 6:
        {
            str = [NSString formatterTime:self.orderInforModel.orderStartTime] ? [NSString formatterTime:self.orderInforModel.orderStartTime] : @"";
        }
            break;
        case 7:
        {
            str = [NSString formatterTime:self.orderInforModel.orderEndTime] ? [NSString formatterTime:self.orderInforModel.orderEndTime] : @"";
        }
            break;
        case 8:
        {
            str = [NSString formatterTime:self.orderInforModel.enrollEndTime] ? [NSString formatterTime:self.orderInforModel.enrollEndTime] : @"";
        }
            break;
        case 9:
        {
            if (self.orderInforModel.orderType.intValue == 2) {
                str = @"";
            }else {
                 str = [NSString stringWithFormat:@"%d小时/天",self.orderInforModel.workDuration.intValue];
            }
        }
            break;
        case 10:
        {
            if (self.orderInforModel.orderType.intValue == 2) {
                str = @"";
            }else {
                str = [NSString stringWithFormat:@"%d小时/天",self.orderInforModel.lowHourDay.intValue];
            }
        }
            break;
        case 11:
        {
            if (self.orderInforModel.orderType.intValue == 2) {
                str = @"";
            }else {
                str = [NSString stringWithFormat:@"%d小时/天",self.orderInforModel.restDuration.intValue];
            }
        }
            break;
        case 12:
        {
            str = self.orderInforModel.workDescription ? self.orderInforModel.workDescription : @"";
        }
            break;
        case 13:
        {
            str = self.orderInforModel.workContent ? self.orderInforModel.workContent : @"";
        }
            break;
        case 14:
        {
            if (self.orderInforModel.orderType.intValue == 2) {
                str = @"";
            }else {
                str = [NSString stringWithFormat:@"%@天", self.orderInforModel.lowHourDay];
            }
            
        }
            break;
        case 15:
        {
            str = self.orderInforModel.genderRequire ? self.orderInforModel.genderRequire : @"";
        }
            break;
        case 16:
        {
            str = self.orderInforModel.ageRequire ? self.orderInforModel.ageRequire : @"";
        }
            break;
        default:
            break;
    }
    if (str && [str isEqualToString:@""]) {
        return 0;
    }else {
        CGFloat cellHeight = [str getSizeWithMaxSize:CGSizeMake(ScreenW - 30 -30 -100, 9999) withFontSize:15].height;
        cellHeight = (cellHeight >= 20 ? cellHeight : 20);
        return cellHeight + 10;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (tableView == _headerView) {
        return [UIView new];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _headerView) {
        return 40;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == _headerView) {
        return 10;
    }
    return 0;
}

@end


@interface LxmOrderDetailCell ()

@end

@implementation LxmOrderDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
        [self setConstrains];
    }
    return self;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = [UIFont systemFontOfSize:15];
        _leftLabel.textColor = CharacterLightGrayColor;
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = [UIFont systemFontOfSize:15];
        _rightLabel.textColor = CharacterDarkColor;
        _rightLabel.numberOfLines = 0;
    }
    return _rightLabel;
}

- (void)initSubviews {
    [self addSubview:self.leftLabel];
    [self addSubview:self.rightLabel];
}

- (void)setConstrains { //screenW - 30 -30 -100
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.top.equalTo(self).offset(5);
        make.width.equalTo(@100);
    }];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.leading.equalTo(self.leftLabel.mas_trailing);
        make.trailing.equalTo(self).offset(-15);
    }];
}

@end
