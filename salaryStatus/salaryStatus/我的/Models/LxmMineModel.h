//
//  LxmMineModel.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/30.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LxmMineModel : NSObject

@end

@interface LxmUserInfoModel : NSObject<NSCoding>

@property (nonatomic , strong) NSString *isSetCashPwd;//是否设置过提现密码

@property (nonatomic , strong) NSString *nickname;//用户名

@property (nonatomic , strong) NSString *rndId;//内部id

@property (nonatomic , strong) NSString *authStatus;//认证审核状态1未提交认证2提交审核中 3审核成功 4审核驳回

@property (nonatomic , strong) NSString *avatar;//头像

@property (nonatomic , strong) NSString *name;//真实姓名

@property (nonatomic , strong) NSString *gender;//性别

@property (nonatomic , strong) NSString *phone;//手机号

@property (nonatomic , strong) NSString *bankAccount;//光大银行卡号

@end


/**
 选择银行
 */
@interface LxmSelcetBankModel : NSObject

@property (nonatomic, strong) NSString *bank;

@property (nonatomic, assign) BOOL isSelect;

@end

/**
 是否在光大银行开过户
 */
@interface LxmKaiHuInfoModel : NSObject

@property (nonatomic, strong) NSString *isOpen;

@property (nonatomic, strong) NSString *htmlContent;

@property (nonatomic, strong) NSString *electricAccount;

@end
