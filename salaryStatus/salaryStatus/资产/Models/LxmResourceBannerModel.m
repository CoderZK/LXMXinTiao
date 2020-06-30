//
//  LxmResourceBannerModel.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/25.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmResourceBannerModel.h"

@implementation LxmResourceBannerModel

@end

@implementation LxmResourceBannerRootModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"result" : @"LxmResourceBannerModel"
             };
}

@end


#pragma --mark 获取资产数据

/**
 当前订单
 */
@implementation LxmAssetCurrentOrderDataModel

@end

/**
 账户数据
 */
@implementation LxmAssetAccountDataModel

@end

/**
 薪跳历程
 */
@implementation LxmAssetWorkSubProcessDataModel

@end


@implementation LxmAssetWorkProcessDataModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"list" : @"LxmAssetWorkSubProcessDataModel"
             };
}

@end


@implementation LxmAssetDataModel


@end


@implementation LxmAssetDataRootModel


@end

#pragma --mark 工资账户

@implementation LxmSalaryBankInfoModel

@end

@implementation LxmSalaryInfoModel

@end

@implementation LxmSalaryInfoRootModel

@end

#pragma --mark 银行卡列表

@implementation LxmBankListModel

@end

@implementation LxmBankListRootModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"result" : @"LxmBankListModel"
             };
}

@end


@implementation LxmBankListRoot1Model

@end


#pragma --mark 账户明细

@implementation LxmAccountDetailModel

- (void)setSortDate:(NSString *)sortDate {
    _sortDate = sortDate;
    if (_sortDate) {
        NSArray *arr = [_sortDate componentsSeparatedByString:@" "];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        //创作时间
        NSDate *createDate = [format dateFromString:arr.firstObject];
        NSCalendar *createCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *createComponents = [createCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:createDate];
        //本地时间
        NSDate *currentDate = [NSDate date];
        NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *currentComponents = [currentCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:currentDate];
        //比较年
        if ([createComponents year] == [currentComponents year]) { //在同一年
            _sectionTitle = [NSString stringWithFormat:@"%02ld月",(long)[createComponents month]];
        } else {
            _sectionTitle = [NSString stringWithFormat:@"%ld年 %02ld月",(long)[createComponents year],[createComponents month]];
        }
        [format setDateFormat:@"yyyy-MM"];
        NSString *dateStr = [format stringFromDate:createDate];
        NSDate *date = [format dateFromString:dateStr];
        _key = [NSString stringWithFormat:@"%lld",(long long)[date timeIntervalSince1970]];
    }
}

- (void)setCreateTime:(NSString *)createTime {
    _createTime = createTime;
    if (!_sortDate && _createTime) {
        NSArray *arr = [_createTime componentsSeparatedByString:@" "];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        //创作时间
        NSDate *createDate = [format dateFromString:arr.firstObject];
        NSCalendar *createCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *createComponents = [createCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:createDate];
        //本地时间
        NSDate *currentDate = [NSDate date];
        NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *currentComponents = [currentCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:currentDate];
        //比较年
        if ([createComponents year] == [currentComponents year]) { //在同一年
            _sectionTitle = [NSString stringWithFormat:@"%02ld月",(long)[createComponents month]];
        } else {
            _sectionTitle = [NSString stringWithFormat:@"%ld年 %02ld月",(long)[createComponents year],[createComponents month]];
        }
        [format setDateFormat:@"yyyy-MM"];
        NSString *dateStr = [format stringFromDate:createDate];
        NSDate *date = [format dateFromString:dateStr];
        _key = [NSString stringWithFormat:@"%lld",(long long)[date timeIntervalSince1970]];
    }
}


@end

@implementation LxmAccountDetailModel1


+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"list" : @"LxmAccountDetailModel"
             };
}

@end


@implementation LxmAccountDetailRootModel


@end

#pragma --mark 订单详情
//订单信息
@implementation LxmOrderInfoModel

@end

//薪跳历程
@implementation LxmXintiaoProcessModel

- (void)setWorkTime:(NSString *)workTime {
    _workTime = workTime;
    if (_workTime) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        //创作时间
        NSDate *createDate = [format dateFromString:_workTime];
        NSCalendar *createCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *createComponents = [createCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:createDate];
        //本地时间
        NSDate *currentDate = [NSDate date];
        NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//        NSDateComponents *currentComponents = [currentCalendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:currentDate];
        
        _sectionTitle = [NSString stringWithFormat:@"%02ld月 %ld",[createComponents month],(long)[createComponents year]];
        
        //比较年
//        if ([createComponents year] == [currentComponents year]) { //在同一年
//            _sectionTitle = [NSString stringWithFormat:@"%02ld月",(long)[createComponents month]];
//        } else {
//            _sectionTitle = [NSString stringWithFormat:@"%ld年 %02ld月",(long)[createComponents year],[createComponents month]];
//        }
//
        [format setDateFormat:@"yyyy-MM"];
        NSString *dateStr = [format stringFromDate:createDate];
        NSDate *date = [format dateFromString:dateStr];
        _key = [NSString stringWithFormat:@"%lld",(long long)[date timeIntervalSince1970]];
    }
}

@end

//订单返回
@implementation LxmOrderDetailModel : NSObject

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"xintiaoProcess" : @"LxmXintiaoProcessModel"
             };
}

@end


@implementation LxmOrderDetailRootModel


@end


//扫码扫到的
@implementation LxmOrderDetailRoot1Model



@end
