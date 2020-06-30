//
//  LxmResourceVC.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/25.
//  Copyright © 2019年 李晓满. All rights reserved.
//
#import "LxmResourceVC.h"
#import "SNY_AdScrollView.h"
#import "LxmResourceBannerModel.h"
#import "LxmResourceHeaderView.h"
#import "LxmCurrentOrderCell.h"
#import "LxmResourceExperienceCell.h"
#import "LxmMessageVC.h"
#import "LxmKeJieVC.h"
#import "LxmOrderDetailVC.h"
#import "SNYQRCodeVC.h"
#import "LxmWebViewController.h"
#import "LxmAccountDetailVC.h"
#import "LxmYiLuYongVC.h"


@interface LxmResourceButton : UIButton

@property (nonatomic, strong) UIImageView *iconImgView;//图标

@property (nonatomic, strong) UILabel *textLabel;//标题

@property (nonatomic, strong) UIImageView *accImgView;//箭头

@end

@implementation LxmResourceButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImgView];
        [self addSubview:self.textLabel];
        [self addSubview:self.accImgView];
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(20);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@24);
        }];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.iconImgView.mas_trailing).offset(15);
            make.centerY.equalTo(self);
        }];
        [self.accImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(-20);
            make.centerY.equalTo(self);
            make.width.height.equalTo(@15);
        }];
    }
    return self;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
        _iconImgView.image = [UIImage imageNamed:@"yhk"];
    }
    return _iconImgView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = CharacterDarkColor;
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.text = @"工资钱包";
    }
    return _textLabel;
}

- (UIImageView *)accImgView {
    if (!_accImgView) {
        _accImgView = [[UIImageView alloc] init];
        _accImgView.image = [UIImage imageNamed:@"xiayiye"];
    }
    return _accImgView;
}

@end




@interface LxmResourceVC ()<SNYQRCodeVCDelegate, SNY_AdScrollViewDelegate>

@property (nonatomic, strong) UIView *headerView;//表头视图

@property (nonatomic, strong) UIView *bgBannerView;//banner背景

@property (strong, nonatomic) SNY_AdScrollView *cycleScrollView; //轮播的控件

@property (strong, nonatomic) NSMutableArray <LxmResourceBannerModel *> *bannerArr;//轮播的内容

@property (nonatomic, strong) LxmResourceButton *qianbaoButton;

@property (nonatomic, strong) UIView *bgAccountView;//可预支账户背景

@property (nonatomic, strong) UIButton *kejieAccountView;//可预支账户

@property (nonatomic, strong) UILabel *moneyLabel;//可预支账户钱数

@property (nonatomic, strong) UILabel *textLabel;//可预支账户文字

@property (nonatomic, strong) UIView *bgMoneyAccountView;//账户背景

@property (nonatomic, strong) UIButton *moneyAccountView;//账户

@property (nonatomic, strong) UILabel *moneyLabel1;//工资账户钱数￥

@property (nonatomic, strong) UILabel *textLabel1;//工资账户文字

@property (nonatomic, strong) NSArray *arr;//测试数据

@property (nonatomic, strong) NSArray *arr1;//测试数据

@property (nonatomic, strong) LxmAssetCurrentOrderDataModel *currentDataModel;//当前订单

@property (nonatomic, strong) NSMutableArray <LxmAssetWorkSubProcessDataModel *>*workProgressArr;//薪跳历程

@property (nonatomic, assign) NSInteger orderType;

@end

@implementation LxmResourceVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initNavRightView];
    [self initHeaderView];
    [self setHeaderConstrains];
    
    self.bannerArr = [NSMutableArray array];
    self.workProgressArr = [NSMutableArray array];
    [self.tableView reloadData];
    
    [self loadBannerData];
    [self loadAssetData];
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [self loadBannerData];
        [self loadAssetData];
    }];
    
    [LxmEventBus registerEvent:@"tixianSuccess" block:^(id data) {
        [self loadAssetData];
    }];
}

/**
 获取banner列表
 */
- (void)loadBannerData {
    [LxmNetworking networkingPOST:app_findBannerList parameters:@{@"platformType" : @1} returnClass:[LxmResourceBannerRootModel class] success:^(NSURLSessionDataTask *task, LxmResourceBannerRootModel *responseObject) {
        [self endRefrish];
        if (responseObject.key.intValue == 1) {
            [self.bannerArr removeAllObjects];
            [self.bannerArr addObjectsFromArray:responseObject.result];
            self.cycleScrollView.dataArr = responseObject.result;
        } else {
            [UIAlertController showAlertWithKey:responseObject.key message:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefrish];
    }];
}
//查询资产页数据
- (void)loadAssetData {
    [LxmNetworking networkingPOST:user_queryAssetData parameters:@{@"token" : SESSION_TOKEN} returnClass:[LxmAssetDataRootModel class] success:^(NSURLSessionDataTask *task, LxmAssetDataRootModel * responseObject) {
        [self endRefrish];
        if (responseObject.key.intValue == 1) {
            
            NSAttributedString *yuanAtt = [[NSAttributedString alloc] initWithString:@"￥" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]}];
            NSAttributedString *moneyAtt = [[NSAttributedString alloc] initWithString:responseObject.result.accountData.preBorrowAccount ? responseObject.result.accountData.preBorrowAccount : @"" attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:30]}];
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithAttributedString:yuanAtt];
            [att appendAttributedString:moneyAtt];
            self.moneyLabel.attributedText = att;
            
            NSAttributedString *yuanAtt1 = [[NSAttributedString alloc] initWithString:@"￥" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]}];
            NSAttributedString *moneyAtt1 = [[NSAttributedString alloc] initWithString:responseObject.result.accountData.salaryAccount ? responseObject.result.accountData.salaryAccount : @"" attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:30]}];
            NSMutableAttributedString *att1 = [[NSMutableAttributedString alloc] initWithAttributedString:yuanAtt1];
            [att1 appendAttributedString:moneyAtt1];
            self.moneyLabel1.attributedText = att1;
            
            LxmAssetCurrentOrderDataModel *currentOrderModel = responseObject.result.currentOrder;
            self.currentDataModel = currentOrderModel;
            if (currentOrderModel) {
               self.arr = @[currentOrderModel.job, currentOrderModel.totalHour, currentOrderModel.hourFee, [NSString retOrderStatus:currentOrderModel.status]];
            }
            [self.workProgressArr removeAllObjects];
            [self.workProgressArr addObjectsFromArray:responseObject.result.workProcess.list];
            bool ishaveH = NO;
            for (LxmAssetWorkSubProcessDataModel *m in self.workProgressArr) {
                if (m.orderType.intValue == 1) {
                    ishaveH = YES;
                    break;
                }
            }
            self.orderType = ishaveH ? 1 : 2;
            
            int totalhour = 0;
            int count = 0;
            for (LxmAssetWorkSubProcessDataModel *model in self.workProgressArr) {
                if (model.orderType.intValue == 1) {
                    totalhour += model.totalHour.intValue;
                    count ++;
                }
            }
            CGFloat junzhi = totalhour/count;
            self.arr1 = @[[NSString stringWithFormat:@"%ld", self.workProgressArr.count], [NSString stringWithFormat:@"%d", totalhour], [NSString stringWithFormat:@"%.2f", junzhi], [NSString stringWithFormat:@"Lv%@", responseObject.result.workProcess.level]];
            [self.tableView reloadData];
        }else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self endRefrish];
    }];
}

- (void)accountClick:(UIButton *)button {
    if (button == self.kejieAccountView) {//可借账户
        LxmKeJieVC *vc = [[LxmKeJieVC alloc] initWithTableViewStyle:UITableViewStylePlain type:LxmKeJieVC_type_kejie];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {//工资账户
        LxmAccountDetailVC *vc = [[LxmAccountDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmAccountDetailVC_type_moneyAccount];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //获取点击页面加载的url
    NSString *url = request.URL.absoluteString;
    NSLog(@"%@",url);
    if ([url rangeOfString:@"此处是想拦截的字符串"].location != NSNotFound) {
        return NO;
    }
    return YES;
}


- (void)initNavRightView {
    
    UIImageView *leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 164, 19)];
    leftImgView.image = [UIImage imageNamed:@"home_nav"];
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc] initWithCustomView:leftImgView];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton setImage:[UIImage imageNamed:@"message"]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(messageClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    UIButton *rightButton1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    rightButton1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightButton1 setImage:[UIImage imageNamed:@"scan"]forState:UIControlStateNormal];
    [rightButton1 addTarget:self action:@selector(scanClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:rightButton1];
    self.navigationItem.leftBarButtonItem = item0;
    self.navigationItem.rightBarButtonItems = @[item1, item];
}

/**
 消息
 */
- (void)messageClick {
    LxmMessageVC *vc = [[LxmMessageVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 扫描
 */
- (void)scanClick {
    SNYQRCodeVC * vc = [[SNYQRCodeVC alloc] init];
    vc.delegate = self;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SNYQRCodeVCDelegate

- (void)SNYQRCodeVC:(SNYQRCodeVC *)vc scanResult:(NSString *)str {
    
    [vc.navigationController popViewControllerAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray * dataArr = [str componentsSeparatedByString:@"&"];
        NSString *orderNo = @"";
        NSString *agencyId = @"";
        if (dataArr.count == 1) {
            NSString *order = dataArr.firstObject;
            NSArray *tempArr = [order componentsSeparatedByString:@"="];
            if (tempArr.count == 2) {
                orderNo = tempArr.lastObject;
            }
        }else if (dataArr.count == 2) {
            NSString *order = dataArr.firstObject;
            NSString *order1 = dataArr.lastObject;
            NSArray *tempArr = [order componentsSeparatedByString:@"="];
            NSArray *tempArr1 = [order1 componentsSeparatedByString:@"="];
            if (tempArr.count == 2 || tempArr1.count == 2) {
                orderNo = tempArr.lastObject;
                agencyId = tempArr1.lastObject;
            }
        }
        LxmOrderDetailVC *vc = [[LxmOrderDetailVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.orderNo = orderNo;
        vc.agencyId = agencyId;
        [self.navigationController pushViewController:vc animated:YES];
        
    });
}

/**
 轮播图跳转
 */
-(void)sny_adScrollView:(SNY_AdScrollView *)scrollView selectedIndex:(NSInteger)index {
    LxmResourceBannerModel *model = self.bannerArr[index];
    LxmWebViewController * vc = [[LxmWebViewController alloc] init];
    vc.navigationItem.title = @"详情";
    if (model.type.intValue == 1) {//图片
        vc.loadUrl = [NSURL URLWithString:model.linkUrl];
    }else {//富文本
        [vc loadHtmlStr:model.content withBaseUrl:Base_URL];
    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma --mark tableView的delegate和dataSource方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.workProgressArr.count + 1 + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LxmCurrentOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmCurrentOrderCell"];
        if (!cell) {
            cell = [[LxmCurrentOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmCurrentOrderCell" section:0];
        }
        cell.currentDataModel = self.currentDataModel;
        cell.dataArr = self.arr;
        return cell;
    } else {
        if (indexPath.row == 0) {
            LxmCurrentOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmCurrentOrderCell1"];
            if (!cell) {
                cell = [[LxmCurrentOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmCurrentOrderCell1" section:1];
            }
            cell.orderType = self.orderType;
            cell.workProgressArr = self.workProgressArr;
            cell.dataArr = self.arr1;
            return cell;
        } else {
            LxmResourceExperienceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmResourceExperienceCell"];
            if (!cell) {
                cell = [[LxmResourceExperienceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmResourceExperienceCell" row:indexPath.row];
            }
            if (indexPath.row == 1) {
                cell.backgroundColor = BGGrayColor;
                cell.dataArr = self.workProgressArr.count > 0 ? @[@"岗位", @"累计工时(h)", @"时薪(￥)", @"报酬(￥)", @"工作时间"] : @[@"", @"", @" ", @"", @""];
            } else {
                cell.backgroundColor = [UIColor whiteColor];
                LxmAssetWorkSubProcessDataModel *model = self.workProgressArr[indexPath.row - 2];
                if (model.orderType.intValue == 1) {//短期工
                    cell.dataArr = @[model.job, model.totalHour, model.hourFee, model.totalFee, [NSString formatterTime:model.workTime]];
                } else {
                    cell.dataArr = @[model.job, @"-", @"-", model.totalFee,[NSString formatterTime:model.workTime]];
                }
            }
            return cell;
        }
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LxmResourceHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LxmResourceHeaderView"];
    if (!headerView) {
        headerView = [[LxmResourceHeaderView alloc] initWithReuseIdentifier:@"LxmResourceHeaderView"];
    }
    headerView.section = section;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {//没有数据时  高度是150  有数据时高度是100
        return self.currentDataModel ? 100 : 150;
    } else {
        if (indexPath.row == 0) {
            return self.workProgressArr.count > 0 ? 100 : 150;
        }
        return self.workProgressArr.count > 0 ? 50 : 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {//没有数据时  高度是150  有数据时高度是100
        if (self.currentDataModel) {
            //状态（0审核驳回 1报名待审核 2审核成功待签约 3待续签 4未签约（到点未签约） 5签约完成待录用 6录用工作进行时 7已结束）
            if (self.currentDataModel.status.intValue == 6 ||self.currentDataModel.status.intValue == 7) {//当前订单 已录用 正在进行时
                if (self.currentDataModel.orderType.intValue == 1) {//1短期工 2日结型
                    LxmYiLuYongVC *vc = [[LxmYiLuYongVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }else {
                    LxmOrderDetailVC *vc = [[LxmOrderDetailVC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            }else {
                LxmOrderDetailVC *vc = [[LxmOrderDetailVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    } else {
        if (indexPath.row != 0 && indexPath.row != 1) {
            //已结束的订单
            LxmOrderDetailVC *vc = [[LxmOrderDetailVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}


/**
 工资钱包
 */
- (void)gongziQianbaoClick {
    LxmAccountDetailVC *detailVC = [[LxmAccountDetailVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmAccountDetailVC_type_qianbao];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma --mark 初始化头视图
/**
 初始化头视图
 */
- (void)initHeaderView {
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, ScreenW - 30, 495 + 50)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.headerView;
    
    [self.headerView addSubview:self.bgBannerView];
    [self.bgBannerView addSubview:self.cycleScrollView];
    
    [self.headerView addSubview:self.qianbaoButton];
    
    [self.headerView addSubview:self.bgAccountView];
    [self.headerView addSubview:self.kejieAccountView];
    [self.kejieAccountView addSubview:self.moneyLabel];
    [self.kejieAccountView addSubview:self.textLabel];
    
    [self.headerView addSubview:self.bgMoneyAccountView];
    [self.headerView addSubview:self.moneyAccountView];
    [self.moneyAccountView addSubview:self.moneyLabel1];
    [self.moneyAccountView addSubview:self.textLabel1];
    
}

/**
 设置头视图约束
 */
- (void)setHeaderConstrains {
    
    [self.bgBannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.headerView).offset(20);
        make.trailing.equalTo(self.headerView).offset(-20);
        make.height.equalTo(@190);
    }];
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self.headerView).offset(15);
        make.trailing.equalTo(self.headerView).offset(-15);
        make.height.equalTo(@200);
    }];
    
    [self.qianbaoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cycleScrollView.mas_bottom).offset(15);
        make.leading.trailing.equalTo(self.headerView);
        make.height.equalTo(@50);
    }];
    
    [self.bgAccountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.qianbaoButton.mas_bottom).offset(15);
        make.leading.equalTo(self.headerView).offset(20);
        make.trailing.equalTo(self.headerView).offset(-20);
        make.height.equalTo(@100);
    }];
    [self.kejieAccountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.qianbaoButton.mas_bottom).offset(10);
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
    
    [self.bgMoneyAccountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgAccountView.mas_bottom).offset(30);
        make.leading.equalTo(self.headerView).offset(20);
        make.trailing.equalTo(self.headerView).offset(-20);
        make.height.equalTo(@100);
    }];
    [self.moneyAccountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgAccountView.mas_bottom).offset(25);
        make.leading.equalTo(self.headerView).offset(15);
        make.trailing.equalTo(self.headerView).offset(-15);
        make.height.equalTo(@110);
    }];
    [self.moneyLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.moneyAccountView);
        make.bottom.equalTo(self.bgMoneyAccountView.mas_centerY);
    }];
    [self.textLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLabel1.mas_bottom).offset(10);
        make.centerX.equalTo(self.moneyLabel1);
    }];
    
}

/**
 初始化子视图
 */
- (UIView *)bgBannerView {
    if (!_bgBannerView) {
        _bgBannerView = [[UIView alloc] init];
        _bgBannerView.backgroundColor = [UIColor whiteColor];
        _bgBannerView.layer.shadowColor = MineColor.CGColor;
        _bgBannerView.layer.shadowOffset = CGSizeZero;
        _bgBannerView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _bgBannerView.layer.shadowRadius = 10;//阴影半径，默认3
    }
    return _bgBannerView;
}

- (SNY_AdScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [[SNY_AdScrollView alloc] init];
        _cycleScrollView.backgroundColor = [UIColor whiteColor];
        _cycleScrollView.layer.cornerRadius = 10;
        _cycleScrollView.layer.masksToBounds = YES;
        _cycleScrollView.delegate = self;
    }
    return _cycleScrollView;
}

- (LxmResourceButton *)qianbaoButton {
    if (!_qianbaoButton) {
        _qianbaoButton = [[LxmResourceButton alloc] init];
        [_qianbaoButton addTarget:self action:@selector(gongziQianbaoClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qianbaoButton;
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

- (UIButton *)kejieAccountView {
    if (!_kejieAccountView) {
        _kejieAccountView = [[UIButton alloc] init];
        _kejieAccountView.backgroundColor = [UIColor whiteColor];
        _kejieAccountView.layer.cornerRadius = 10;
        _kejieAccountView.layer.masksToBounds = YES;
        [_kejieAccountView addTarget:self action:@selector(accountClick:) forControlEvents:UIControlEventTouchUpInside];
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
        _textLabel.text = @"可预支账户";
    }
    return _textLabel;
}

- (UIView *)bgMoneyAccountView {
    if (!_bgMoneyAccountView) {
        _bgMoneyAccountView = [[UIView alloc] init];
        _bgMoneyAccountView.backgroundColor = [UIColor whiteColor];
        _bgMoneyAccountView.layer.shadowColor = MineColor.CGColor;
        _bgMoneyAccountView.layer.shadowOffset = CGSizeZero;
        _bgMoneyAccountView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _bgMoneyAccountView.layer.shadowRadius = 10;//阴影半径，默认3
    }
    return _bgMoneyAccountView;
}

- (UIButton *)moneyAccountView {
    if (!_moneyAccountView) {
        _moneyAccountView = [[UIButton alloc] init];
        _moneyAccountView.backgroundColor = [UIColor whiteColor];
        _moneyAccountView.layer.cornerRadius = 10;
        _moneyAccountView.layer.masksToBounds = YES;
        [_moneyAccountView addTarget:self action:@selector(accountClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moneyAccountView;
}

- (UILabel *)moneyLabel1 {
    if (!_moneyLabel1) {
        _moneyLabel1 = [[UILabel alloc] init];
        _moneyLabel1.textColor = BlueColor;
    }
    return _moneyLabel1;
}

- (UILabel *)textLabel1 {
    if (!_textLabel1) {
        _textLabel1 = [[UILabel alloc] init];
        _textLabel1.font = [UIFont systemFontOfSize:15];
        _textLabel1.textColor = BlueColor;
        _textLabel1.text = @"工资账户";
    }
    return _textLabel1;
}

@end
