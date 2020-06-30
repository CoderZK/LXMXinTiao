//
//  LxmResourceBannerModel.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/25.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LxmResourceBannerModel : NSObject

@property (nonatomic , strong) NSNumber *type;//类型1图片 2富文本

@property (nonatomic , strong) NSString *title;//标题

@property (nonatomic , strong) NSString *content;//富文本内容

@property (nonatomic , strong) NSString * picUrl;//图片路径

@property (nonatomic , strong) NSString * linkUrl;//跳转路径

@end

@interface LxmResourceBannerRootModel : NSObject

@property (nonatomic, strong) NSNumber *key;//返回状态

@property (nonatomic, strong) NSString *message;//返回信息的描述

@property (nonatomic, strong) NSArray <LxmResourceBannerModel *>*result;

@end



#pragma --mark 获取资产数据

/**
 当前订单
 */
@interface LxmAssetCurrentOrderDataModel : NSObject

@property (nonatomic, strong) NSString *status;//状态（0审核驳回 1报名待审核 2审核成功待签约 3待续签 4未签约（到点未签约） 5签约完成待录用 6录用待考勤 7已考勤工作进行时 8已结束）

@property (nonatomic, strong) NSString *job;//岗位

@property (nonatomic, strong) NSString *totalHour;//累计工时(日结型没有)

@property (nonatomic, strong) NSString *hourFee;//时薪(日结型没有)

@property (nonatomic, strong) NSString *orderType;//订单类型1短期工 2日结型

@end

/**
 账户数据
 */
@interface LxmAssetAccountDataModel : NSObject

@property (nonatomic, strong) NSString *preBorrowAccount;//可预支账户

@property (nonatomic, strong) NSString *salaryAccount;//工资账户

@end


/**
 薪跳历程
 */
@interface LxmAssetWorkSubProcessDataModel : NSObject

@property (nonatomic, strong) NSString *job;//岗位

@property (nonatomic, strong) NSString *totalHour;//累计工时(日结型没有)

@property (nonatomic, strong) NSString *hourFee;//时薪(日结型没有)

@property (nonatomic, strong) NSString *totalFee;//报酬

@property (nonatomic, strong) NSString *workTime;//工作时间

@property (nonatomic, strong) NSString *orderType;//类型1短期工2日结型

@end


@interface LxmAssetWorkProcessDataModel : NSObject

@property (nonatomic, strong) NSString *level;//可预支账户

@property (nonatomic, strong) NSArray <LxmAssetWorkSubProcessDataModel *>*list;//历程列表

@end


@interface LxmAssetDataModel : NSObject

@property (nonatomic, strong) LxmAssetCurrentOrderDataModel *currentOrder;//当前订单

@property (nonatomic, strong) LxmAssetAccountDataModel *accountData;//账户数据

@property (nonatomic, strong) LxmAssetWorkProcessDataModel *workProcess;//薪跳历程

@end

@interface LxmAssetDataRootModel : NSObject

@property (nonatomic, strong) NSNumber *key;//返回状态

@property (nonatomic, strong) NSString *message;//返回信息的描述

@property (nonatomic, strong) LxmAssetDataModel *result;//返回数据

@end

#pragma --mark 工资账户

@interface LxmSalaryBankInfoModel : NSObject

@property (nonatomic, strong) NSString *bank;//银行名称

@property (nonatomic, strong) NSString *cardNumber;//银行卡号

@property (nonatomic, strong) NSString *id;//记录id

@end

@interface LxmSalaryInfoModel : NSObject

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) NSString *preBorrowAccount;//可预支账户

@property (nonatomic, strong) NSString *salaryBorrowAccount;//工资账户

@property (nonatomic, strong) LxmSalaryBankInfoModel *bankInfo;//银行卡信息 没有时返回null

@property (nonatomic, strong) NSString *cashQuota;//可提现金额

@end

@interface LxmSalaryInfoRootModel : NSObject

@property (nonatomic, strong) NSNumber *key;//返回状态

@property (nonatomic, strong) NSString *message;//返回信息的描述

@property (nonatomic, strong) LxmSalaryInfoModel *result;//返回数据

@end

#pragma --mark 银行卡列表

@interface LxmBankListModel : NSObject

@property (nonatomic, strong) NSString *name;//银行名称

@property (nonatomic, strong) NSString *bank;//银行名称

@property (nonatomic, strong) NSString *cardNumber;//银行卡号

@property (nonatomic, strong) NSString *id;//银行id

@property (nonatomic, assign) BOOL isSelect;

@end

@interface LxmBankListRootModel : NSObject

@property (nonatomic, strong) NSNumber *key;//返回状态

@property (nonatomic, strong) NSString *message;//返回信息的描述

@property (nonatomic, strong) NSArray <LxmBankListModel *>*result;//返回数据

@end

@interface LxmBankListRoot1Model : NSObject

@property (nonatomic, strong) NSNumber *key;//返回状态

@property (nonatomic, strong) NSString *message;//返回信息的描述

@property (nonatomic, strong) LxmBankListModel *result;//返回数据

@end

#pragma --mark 账户明细


@interface LxmAccountDetailModel : NSObject

@property (nonatomic, readonly) NSString *sectionTitle;

@property (nonatomic, readonly) NSString *key;

@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSString *createTime;

@property (nonatomic, strong) NSString *amount;

@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSString *sendCompany;

@property (nonatomic, strong) NSString *remark;

@property (nonatomic, strong) NSString *cashStatus;

@property (nonatomic, strong) NSString *money;

@property (nonatomic, strong) NSString *workTime;

@property (nonatomic, strong) NSString *sortDate;

@end

@interface LxmAccountDetailModel1 : NSObject

@property (nonatomic, strong) NSArray <LxmAccountDetailModel *>*list;

@end

@interface LxmAccountDetailRootModel : NSObject

@property (nonatomic, strong) NSNumber *key;//返回状态

@property (nonatomic, strong) NSString *message;//返回信息的描述

@property (nonatomic, strong) LxmAccountDetailModel1 *result;//返回数据

@end

#pragma --mark 订单详情
//订单信息
@interface LxmOrderInfoModel : NSObject

@property (nonatomic, strong) NSString  *enterpriseName;//公司名称

@property (nonatomic, strong) NSString *address;//工作地点

@property (nonatomic, strong) NSString *calculateWay;//结算方式

@property (nonatomic, strong) NSString *orderType;//订单类型1短期工2日结型

@property (nonatomic, strong) NSString *job;//岗位

@property (nonatomic, strong) NSString *price;//结算单价

@property (nonatomic, strong) NSString *orderStartTime;//订单开始时间

@property (nonatomic, strong) NSString *orderEndTime;//订单结束时间

@property (nonatomic, strong) NSString *enrollEndTime;//报名截止时间

@property (nonatomic, strong) NSString *banciType;//班次类型（1常白班2两班倒3三班倒）

@property (nonatomic, strong) NSString *workDescription;//工作说明

@property (nonatomic, strong) NSString *workContent;//工作内容

@property (nonatomic, strong) NSString *workDuration;//工作时长

@property (nonatomic, strong) NSString *lowHourDay;//最低工作时长

@property (nonatomic, strong) NSString *lowWorkDay;//最低工作天数

@property (nonatomic, strong) NSString *restDuration;//休息时长

@property (nonatomic, strong) NSString *genderRequire;//性别要求

@property (nonatomic, strong) NSString *ageRequire;//年龄要求

@property (nonatomic, strong) NSString *orderNo;//订单号

@end

//薪跳历程
@interface LxmXintiaoProcessModel : NSObject

@property (nonatomic, strong) NSString *workTime;//工作时间

@property (nonatomic, readonly) NSString *sectionTitle;

@property (nonatomic, readonly) NSString *key;

@property (nonatomic, strong) NSString *workHour;//累积工时

@property (nonatomic, strong) NSString *hourFee;//时薪

@property (nonatomic, strong) NSString *totalFee;//报酬

@property (nonatomic, strong) NSString *weekday;//星期数

@end

//订单返回
@interface LxmOrderDetailModel : NSObject

@property (nonatomic, strong) LxmOrderInfoModel *orderInfo;//订单信息

@property (nonatomic, strong) NSString *orderStatus;//状态（0审核驳回 1报名待审核 2审核成功待签约 3待续签 4未签约（到点未签约） 5签约完成待录用 6录用工作进行时 7已结束）

@property (nonatomic, strong) NSString *reason;//驳回原因

@property (nonatomic, strong) NSArray <LxmXintiaoProcessModel *>*xintiaoProcess;

@end


@interface LxmOrderDetailRootModel : NSObject

@property (nonatomic, strong) NSNumber *key;//返回状态

@property (nonatomic, strong) NSString *message;//返回信息的描述

@property (nonatomic, strong) LxmOrderDetailModel *result;//返回数据

@end

//扫码扫到的
@interface LxmOrderDetailRoot1Model : NSObject

@property (nonatomic, strong) NSNumber *key;//返回状态

@property (nonatomic, strong) NSString *message;//返回信息的描述

@property (nonatomic, strong) LxmOrderInfoModel *result;//返回数据

@end
