//
//  LxmSettingPasswordVC.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/28.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

typedef NS_ENUM(NSInteger, LxmSettingPasswordVC_type) {
    LxmSettingPasswordVC_type_login,
    LxmSettingPasswordVC_type_forget,
    LxmSettingPasswordVC_type_tixian
};

@interface LxmSettingPasswordVC : BaseTableViewController

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(LxmSettingPasswordVC_type)type;

@property (nonatomic, assign) BOOL isSetTiXian;

@end

