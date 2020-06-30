//
//  LxmYiLuYongVC.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/2/12.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmYiLuYongVC.h"
#import "LxmYiLuYongTopView.h"
#import "LxmOrderDetailVC.h"
#import "LxmResourceTopView.h"
#import "LxmYiLuYongCell.h"

@interface LxmYiLuYongVC ()

@property (nonatomic, strong) UIImageView *bgImgView;//顶部背景图

@property (nonatomic, strong) LxmYiLuYongTopView *topView;//日期展示

@property (nonatomic, strong) UITableView *headerView;//表头视图

@property (nonatomic, strong) LxmOrderDetailModel *rootModel;//订单全部信息

@property (nonatomic, strong) LxmOrderInfoModel *orderInforModel;//订单信息

@property (nonatomic, strong) NSArray <LxmXintiaoProcessModel *>*progressData;

@property (nonatomic, strong) NSString *leftStr;//左边标题

@property (nonatomic, strong) NSString *rightStr;//右边名称

@property (nonatomic,strong)NSMutableDictionary * dataDict;

@property (nonatomic,strong)NSArray * keyArr;

@end

@implementation LxmYiLuYongVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBgImgView];
    [self initTableHeaderView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self loadOrderDetail];
}
//获取订单详情
- (void)loadOrderDetail {
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:user_queryOrderDetail parameters:@{@"token" : SESSION_TOKEN} returnClass:[LxmOrderDetailRootModel class] success:^(NSURLSessionDataTask *task, LxmOrderDetailRootModel *responseObject) {
        [SVProgressHUD dismiss];
        self.rootModel = responseObject.result;
        self.orderInforModel = responseObject.result.orderInfo;
        self.progressData = responseObject.result.xintiaoProcess;
        [self handleDataArr:self.progressData];
        [self.headerView reloadData];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)handleDataArr:(NSArray <LxmXintiaoProcessModel *> *)dataArr {
    NSMutableDictionary<NSString *, NSMutableArray<LxmXintiaoProcessModel *> *> *dict = [NSMutableDictionary dictionary];
    for (LxmXintiaoProcessModel *m in dataArr) {
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
    self.topView.keyArr = self.keyArr;
    self.topView.dataDict = self.dataDict;
    NSLog(@"%@",self.keyArr);
}


/**
 初始化顶部试图
 */
- (void)initNavBgImgView {
    
    _bgImgView = [[UIImageView alloc] init];
    _bgImgView.image = [UIImage imageNamed:@"bg_11"];
    _bgImgView.layer.masksToBounds = YES;
    [self.view addSubview:_bgImgView];
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, StateBarH + 9, 34, 25)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"home_back"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBtn];
    
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.equalTo(@(StateBarH + 44 + 150));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImgView.mas_bottom).offset(-15);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self.view layoutIfNeeded];
    
//    _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, StateBarH + 30, 120, 30)];
//    _topLabel.text = @" 二月2019";
//    _topLabel.textColor = UIColor.whiteColor;
//    _topLabel.font = [UIFont boldSystemFontOfSize:20];
//    [self.view addSubview:_topLabel];
    
    _topView = [[LxmYiLuYongTopView alloc] initWithFrame:CGRectMake(0, StateBarH + 30, ScreenW, 100 + 64)];
    _topView.didSelectItemBlock = ^(NSInteger Index) {
        
    };
    [self.view addSubview:_topView];
    [self.view bringSubviewToFront:self.tableView];
}

- (void)leftClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initTableHeaderView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 300)];
    bgView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = bgView;
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(25, 5, ScreenW - 50, 290)];
    view1.backgroundColor = [UIColor whiteColor];
    view1.layer.shadowColor = MineColor.CGColor;
    view1.layer.shadowOffset = CGSizeZero;
    view1.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    view1.layer.shadowRadius = 10;//阴影半径，默认3
    [bgView addSubview:view1];
    
    
    _headerView = [[UITableView alloc] initWithFrame:CGRectMake(15, 0, ScreenW - 30, 300) style:UITableViewStyleGrouped];
    _headerView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _headerView.delegate = self;
    _headerView.dataSource = self;
    _headerView.backgroundColor = [UIColor whiteColor];
    _headerView.layer.cornerRadius = 10;
    _headerView.layer.masksToBounds = YES;
    [bgView addSubview:_headerView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _headerView) {
        return 17;
    }
    if (tableView == self.tableView) {
        return self.progressData.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _headerView) {
        LxmOrderDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmOrderDetailCell"];
        if (!cell) {
            cell = [[LxmOrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmOrderDetailCell"];
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
    if (tableView == self.tableView) {
        LxmYiLuYongCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmYiLuYongCell"];
        if (!cell) {
            cell = [[LxmYiLuYongCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmYiLuYongCell" row:indexPath.row];
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        LxmXintiaoProcessModel *model = self.progressData[indexPath.row];
        cell.dataArr = @[[NSString formatterTimee:model.workTime], [NSString stringWithFormat:@"%dh",model.workHour.intValue], [NSString stringWithFormat:@"%d",model.hourFee.intValue], [NSString stringWithFormat:@"%d",model.totalFee.intValue]];
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
    if (tableView == self.tableView) {
        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
        if (!headerView) {
            headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UITableViewHeaderFooterView"];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 50)];
            titleLabel.font = [UIFont boldSystemFontOfSize:16];
            titleLabel.text = @"薪跳历程";
            [headerView addSubview:titleLabel];
            
            LxmResourceTopView *topView = [[LxmResourceTopView alloc] initWithFrame:CGRectMake(0, 50, ScreenW, 40) titleArr:@[@"工作时间", @"累计工时(h)", @"时薪(￥)", @"报酬"]];
            topView.backgroundColor = BGGrayColor;
            [headerView addSubview:topView];
        }
        headerView.contentView.backgroundColor = [UIColor clearColor];
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _headerView) {
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
    if (tableView == self.tableView) {
        return 40;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _headerView) {
        return 40;
    }
    if (tableView == self.tableView) {
        return 100;
    }
    return 0;
}

@end
