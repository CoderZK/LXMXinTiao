//
//  AppDelegate.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/24.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "AppDelegate.h"
#import "LxmTabBarVC.h"
#import "LxmLoginVC.h"
#import <UMPush/UMessage.h>
#import <UMCommon/UMCommon.h>

//友盟账号
#define UMKey @"5cb8390c0cafb2fca1000ae9"
#define  UMSecret @"dnvnib5jprsmiqrkg1ygqgmb3axfyhsk"

@interface AppDelegate ()<UNUserNotificationCenterDelegate,UIApplicationDelegate>
/**
 身份证识别 银行卡识别SDK http://ai.baidu.com/sdk#ocr  账号15261258810，yi412111  测试的BandleID com.biuwork.heartjump 正式的BandleID com.biubiulife.salaryStatus
 薪跳原型地址 https://1n0st0.axshare.com 密码 123123
 上上签 【链接】上上签 https://openapi.bestsign.info/#/dev/demoCase 18914285156  xintiao2019
 友盟
 XinTiao666   xintiao2019
 苹果账号 npq568@163.com Cc11223344
 */

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 启动图片延时: 2秒
    [NSUserDefaults.standardUserDefaults objectForKey:@"userModel"];
    [NSThread sleepForTimeInterval:2];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if (SESSION_TOKEN&&ISLOGIN) {
        self.window.rootViewController = [[LxmTabBarVC alloc] init];
    }else {
        self.window.rootViewController = [[BaseNavigationController alloc] initWithRootViewController:[[LxmLoginVC alloc] init]];
    }
    self.window.backgroundColor = UIColor.whiteColor;
    [self.window makeKeyAndVisible];
    [self initPush];
    [self initUMeng:launchOptions];
    return YES;
}

-(void)initUMeng:(NSDictionary *)launchOptions
{
    [UMConfigure initWithAppkey:UMKey channel:@"App Store"];
    // Push组件基本功能配置
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
    if (@available(iOS 10.0, *)) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        
    } else {
        // Fallback on earlier versions
    }
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        }else{
        }
    }];
    //iOS10必须加下面这段代码。
       UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
       center.delegate=self;
       UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
       [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
           if (granted) {
               //点击允许
               //这里可以添加一些自己的逻辑
           } else {
               //点击不允许
               //这里可以添加一些自己的逻辑
           }
       }];
    
}

-(void)initPush
{
    [UMConfigure initWithAppkey:UMKey channel:@"App Store"];
    //1.向系统申请推送
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    }
    else
    {
        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
}
//在用户接受推送通知后系统会调用
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
     [UMessage registerDeviceToken:deviceToken];
       NSString *token = [self getHexStringForData:deviceToken];
       //将deviceToken给后台
       NSLog(@"send_token:%@",token);
       [LxmTool ShareTool].deviceToken = token;
       if (ISLOGIN) {
           NSLog(@"%@",[LxmTool ShareTool].deviceToken);
           [[LxmTool ShareTool] uploadDeviceToken];
       }
}

- (NSString *)getHexStringForData:(NSData *)data {
    NSUInteger len = [data length];
    char *chars = (char *)[data bytes];
    NSMutableString *hexString = [[NSMutableString alloc] init];
    for (NSUInteger i = 0; i < len; i++) {
        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx", chars[i]]];
    }
    return hexString;
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    
    NSLog(@"url.scheme : %@",url.scheme);
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"正在APP%@", userInfo);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [UMessage setAutoAlert:NO];
            //应用处于前台时的远程推送接受
            //必须加这句代码
            [UMessage didReceiveRemoteNotification:userInfo];
        }else{
            //应用处于前台时的本地推送接受
//            LxmPushModel *model = [LxmPushModel mj_objectWithKeyValues:userInfo];
//            //1-系统通知，2-代理变动，3-钱包消息，4-接单消息，5-订单消息，6-投诉消息，7-素材消息
//            LxmTabBarVC * bar = (LxmTabBarVC *)self.window.rootViewController;
//            bar.selectedIndex = 0;
//            BaseNavigationController * nav  = (BaseNavigationController *)bar.selectedViewController;
//            [self pageTo:model nav:nav];
        }
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 10.0, *)) {
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
    } else {
        // Fallback on earlier versions
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
