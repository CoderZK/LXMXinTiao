//
//  LxmKeJieVC.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/30.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LxmResourceBannerModel.h"

typedef NS_ENUM(NSInteger, LxmKeJieVC_type) {
    LxmKeJieVC_type_kejie,
    LxmKeJieVC_type_moneyAccount
};

@interface LxmKeJieVC : BaseTableViewController

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(LxmKeJieVC_type)type;

@end


/**
 添加银行卡
 */
@interface LxmNoBankCardCell : UITableViewCell

@end

/**
 输入提现金额
 */
@interface LxmPutinMoenyCell : UITableViewCell

@property (nonatomic, strong) UITextField *moneyTF;//输入钱数

@property (nonatomic, strong) LxmSalaryInfoModel *salaryInfoModel;//工资账户信息




@end
