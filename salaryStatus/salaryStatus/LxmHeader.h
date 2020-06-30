//
//  LxmHeader.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/25.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#ifndef LxmHeader_h
#define LxmHeader_h

#import "BaseNavigationController.h"
#import "BaseViewController.h"
#import "BaseTableViewController.h"
#import "Masonry.h"
#import "IQKeyboardManager.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "Masonry.h"
#import "SVProgressHUD.h"
#import "LxmNetworking.h"
#import "LxmTool.h"

#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#import "LxmURLDefine.h"
#import "NSString+Size.h"
#import "UIAlertController+AlertWithKey.h"
#import "UITextField+MaxLength.h"
#import "UIViewController+TopVC.h"
#import "LxmEventBus.h"


//文字三种颜色
#define CharacterDarkColor [UIColor colorWithRed:56/255.0 green:56/255.0 blue:56/255.0 alpha:1]
#define CharacterGrayColor [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1]
#define CharacterLightGrayColor [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]

#define ISLOGIN [LxmTool ShareTool].isLogin
#define SESSION_TOKEN [LxmTool ShareTool].session_token

/**
 屏幕的长宽
 */
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define StateBarH [UIApplication sharedApplication].statusBarFrame.size.height

/**
 分割线
 */
#define  LineColor [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1]

/**
 背景两种颜色
 */
#define BGGrayColor [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1]

#define  RedColor [UIColor colorWithRed:69/255.0 green:94/255.0 blue:245/255.0 alpha:1]

/**
 主色调
 */
#define MineColor [UIColor colorWithRed:26/255.0 green:166/255.0 blue:242/255.0 alpha:1]
#define BlueColor [UIColor colorWithRed:69/255.0 green:94/255.0 blue:240/255.0 alpha:1]
#define pinkColor [UIColor colorWithRed:255/255.0 green:128/255.0 blue:191/255.0 alpha:1]

#define WeakObj(_obj)    __weak typeof(_obj) _obj##Weak = _obj;

//iPhoneX iPhoneXS CGSizeMake(375, 812), iPhoneXR iPhoneXs max CGSizeEqualToSize(CGSizeMake(414, 896)
#define kDevice_Is_iPhoneX (CGSizeEqualToSize(CGSizeMake(375, 812), UIScreen.mainScreen.bounds.size) || CGSizeEqualToSize(CGSizeMake(414, 896), UIScreen.mainScreen.bounds.size))

#endif /* LxmHeader_h */
