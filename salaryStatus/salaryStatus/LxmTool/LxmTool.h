//
//  LxmTool.h
//  emptyCityNote
//
//  Created by 李晓满 on 2017/11/22.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LxmMineModel.h"


@interface LxmTool : NSObject
+(LxmTool *)ShareTool;

@property(nonatomic,assign)bool isLogin;
@property(nonatomic,strong)NSString * session_uid;
@property(nonatomic,strong)NSString * session_token;

@property (nonatomic,strong)LxmUserInfoModel * userModel;

//推送token
@property(nonatomic,strong)NSString * deviceToken;

@property(nonatomic,strong)NSString * pushToken;

@property(nonatomic, assign) BOOL isPublic;
@property(nonatomic, copy) void(^okBlock)(void);

-(void)uploadDeviceToken;

@end
