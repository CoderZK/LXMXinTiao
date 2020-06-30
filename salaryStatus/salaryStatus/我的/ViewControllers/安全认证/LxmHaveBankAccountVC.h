//
//  LxmHaveBankAccountVC.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/9/4.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LxmHaveBankAccountVC : BaseTableViewController

@property (nonatomic, strong) LxmKaiHuInfoModel *model;

@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) NSString *code;

@property (nonatomic, strong) NSMutableDictionary *dict;

@end

NS_ASSUME_NONNULL_END
