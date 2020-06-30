//
//  LxmOrderDetailVC.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/31.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LxmResourceBannerModel.h"

@interface LxmOrderDetailVC : BaseTableViewController

@property (nonatomic, strong) NSString *orderNo;//扫码接单

@property (nonatomic, strong) NSString *agencyId;//中介id

@end

@interface LxmOrderDetailCell : UITableViewCell

@property (nonatomic, strong) UILabel *leftLabel;//标题

@property (nonatomic, strong) UILabel *rightLabel;//描述

@end
