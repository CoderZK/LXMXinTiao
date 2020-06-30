//
//  LxmURLDefine.h
//  shenbian
//
//  Created by 李晓满 on 2018/11/12.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ISLOGIN [LxmTool ShareTool].isLogin
#define TOKEN [LxmTool ShareTool].session_token



//#define Base_URL @"http://e4i9em.natappfree.cc/xintiao/"
//#define Base_img_URL @"http://e4i9em.natappfree.cc/xintiao/downloadFile.do?id="
//#define Base_upload_img_URL @"http://e4i9em.natappfree.cc/xintiao/uploadFile.do"
//#define Base_deleteImg_URL @"http://e4i9em.natappfree.cc/xintiao/deleteFile.do?fileId="

#define Base_URL @"https://app.salaryjumptech.com/xintiao/"
#define Base_img_URL @"https://app.salaryjumptech.com/xintiao/downloadFile.do?id="
#define Base_upload_img_URL @"https://app.salaryjumptech.com/xintiao/uploadFile.do"
#define Base_deleteImg_URL @"https://app.salaryjumptech.com/xintiao/deleteFile.do?fileId="


@interface LxmURLDefine : NSObject

/**
 获取验证码
 1注册
 2忘记密码
 3绑定手机
 4换绑验证旧手机
 5换绑验新手机
 6修改密码"
 */
#define  app_sendVerificationCode Base_URL"app_sendVerificationCode.do"
/**
 注册
 */
#define  app_regsiter Base_URL"app_register.do"
/**
 登录
 */
#define  app_login Base_URL"app_login.do"
/**
 上传推送token
 */
#define  user_upUmeng Base_URL"user_upUmeng.do"
/**
 获取banner列表
 */
#define  app_findBannerList Base_URL"app_findBannerList.do"
/**
 退出登录
 */
#define  user_logout Base_URL"user_logout.do"
/**
 获取资产页数据
 */
#define  user_queryAssetData Base_URL"user_queryAssetData.do"
/**
 个人信息
 */
#define  user_personInfo Base_URL"user_personInfo.do"
/**
 获取图片地址
 */
+(NSString *)getPicImgWthPicStr:(NSString *)pic;
/**
 修改头像
 */
#define  user_editUserInfo Base_URL"user_editUserInfo.do"
/**
 忘记密码
 */
#define  app_forgetPassword Base_URL"app_forgetPassword.do"
/**
 修改登录密码
 */
#define  user_editLoginPassword Base_URL"user_editLoginPassword.do"
/**
 身份认证
 */
#define  user_submitIdCardInfo Base_URL"user_submitIdCardInfo.do"
/**
 可预支额度页面信息
 */
#define  user_preborrowPageInfo Base_URL"user_preborrowPageInfo.do"
/**
 可预支额度页面信息
 */
#define  user_salaryPageInfo Base_URL"user_salaryPageInfo.do"
/**
 查询银行卡
 */
#define  user_getBankCard Base_URL"user_getBankCard.do"
/**
 获取银行列表
 */
#define  app_findBankList Base_URL"app_findBankList.do"
/**
 同意协议
 */
#define  app_getBaseInfo Base_URL"app_getBaseInfo.do"
/**
 绑定银行卡
 */
#define  user_bindBankCard Base_URL"user_bindBankCard.do"
/**
 换绑银行卡
 */
#define  user_rebindBankCard Base_URL"user_rebindBankCard.do"
/**
 修改提现密码
 */
#define  user_editCashPassword Base_URL"user_editCashPassword.do"
/**
 工资账户提现
 */
#define  user_salaryAccountCash Base_URL"user_salaryAccountCash.do"
/**
 预支账户提现
 */
#define  user_preborrowAccountCash Base_URL"user_preborrowAccountCash.do"
/**
 工资账户明细
 */
#define  user_salaryAccountRecord Base_URL"user_salaryAccountRecord.do"

/**
 工资钱包
 */
#define  user_moneyAccountDetail Base_URL"user_moneyAccountDetail.do"

/**
 预支账户明细
 */
#define  user_preborrowAccountRecord Base_URL"user_preborrowAccountRecord.do"
/**
 消息列表
 */
#define  user_findNewsList Base_URL"user_findNewsList.do"
/**
 获取订单详情
 */
#define  user_queryOrderDetail Base_URL"user_queryOrderDetail.do"

/**
 根据订单号获取订单详情
 */
#define  user_getOrderInfo Base_URL"user_getOrderInfo.do"
/**
 扫码接单 报名
 */
#define  user_enrollOrder Base_URL"user_enrollOrder.do"
/**
 签署的协议
 */
#define  user_getProtocolById Base_URL"user_getProtocolById.do"
/**
 签署合同
 */
#define  user_signProtocol Base_URL"user_signProtocol.do"
/**
 推送开关显示
 */
#define  user_queryPushStatus Base_URL"user_queryPushStatus.do"
/**
 推送开关设置
 */
#define  user_setPushStatus Base_URL"user_setPushStatus.do"
/**
 上上签链接地址
 */
#define  user_signBestSignProtocol Base_URL"user_signBestSignProtocol.do"
/**
 绑定光大银行账户
 */
#define  user_bindGuangDaAccount Base_URL"user_bindGuangDaAccount.do"

/**
 首次提交三要素信息查询是否开户
 */
#define  user_submitBankFactorInfo Base_URL"user_submitBankFactorInfo.do"
/**
 绑定二类电子账户
 */
#define  user_bindElectricAccount Base_URL"user_bindElectricAccount.do"
/**
 根据姓名身份证查询电子账户信息
 */
#define  user_queryElectricAccount Base_URL"user_queryElectricAccount.do"
/**
 个人提现
 */
#define  user_getBankH5 Base_URL"user_getBankH5.do"

@end

