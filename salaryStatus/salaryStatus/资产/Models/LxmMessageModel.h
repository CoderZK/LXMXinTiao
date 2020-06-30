//
//  LxmMessageModel.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/26.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LxmMessageModel : NSObject

@property (nonatomic, strong) NSString *title;//标题

@property (nonatomic, strong) NSString *creatTime;//创建日期

@property (nonatomic, strong) NSString *content;//发送内容

@property (nonatomic, strong) NSString *isread;//是否已读0否1是

@property (nonatomic, strong) NSString *id;//消息id

@property (nonatomic, strong) NSString *messageType;//消息类型（1审核结果2录用3结束订单4提现5系统）

@property (nonatomic, strong) NSString *objectId;//相关对象id

@property (nonatomic, assign) CGFloat cellHeight;

@end

@interface LxmMessageRootModel : NSObject

@property (nonatomic, strong) NSNumber *key;//返回状态

@property (nonatomic, strong) NSString *message;//返回信息的描述

@property (nonatomic, strong) NSArray <LxmMessageModel *>*result;//返回

@end
