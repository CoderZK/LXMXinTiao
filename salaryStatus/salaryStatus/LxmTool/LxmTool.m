//
//  LxmTool.m
//  emptyCityNote
//
//  Created by 李晓满 on 2017/11/22.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "LxmTool.h"

static LxmTool * __tool = nil;
@implementation LxmTool
@synthesize isLogin = _isLogin;

+(LxmTool *)ShareTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __tool=[[LxmTool alloc] init];
    });
    return __tool;
}
- (instancetype)init
{
    if (self = [super init])
    {
        _isLogin = [self isLogin];
    }
    return self;
}
-(void)setIsLogin:(BOOL)isLogin
{
    _isLogin = isLogin;
    [[NSUserDefaults standardUserDefaults] setBool:isLogin forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(BOOL)isLogin {
     _isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
    return _isLogin;
}

-(void)setSession_token:(NSString *)session_token {
    [[NSUserDefaults standardUserDefaults] setObject:session_token forKey:@"session_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSString *)session_token {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"session_token"];
}

- (void)setSession_uid:(NSString *)session_uid {
    [[NSUserDefaults standardUserDefaults] setObject:session_uid forKey:@"session_uid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)session_uid {
     return [[NSUserDefaults standardUserDefaults] objectForKey:@"session_uid"];
}

- (void)setDeviceToken:(NSString *)deviceToken {
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSString *)deviceToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
}

- (void)setUserModel:(LxmUserInfoModel *)userModel{
    if (userModel) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userModel];
        if (data) {
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userModel"];
        }
    }
}
- (LxmUserInfoModel *)userModel{
    //取出
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"userModel"];
    if (data) {
        LxmUserInfoModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return model;
    }
    return nil;

}

-(void)uploadDeviceToken
{
    if (self.isLogin&&self.session_token&&self.pushToken)
    {
        NSDictionary * dic = @{
                               @"dev_id":[[[UIDevice currentDevice] identifierForVendor] UUIDString],
                               @"token":self.session_token,
                               @"dev_token":self.pushToken,
                               @"dev_type":@1
                               };
        [LxmNetworking networkingPOST:user_upUmeng parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"推送token上传成功:%@",responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {

        }];
    }
}


@end
