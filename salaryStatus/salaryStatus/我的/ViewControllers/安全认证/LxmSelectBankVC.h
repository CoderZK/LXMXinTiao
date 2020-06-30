//
//  LxmSelectBankVC.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/30.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LxmResourceBannerModel.h"


@interface LxmSelectBankVC : BaseTableViewController

@property (nonatomic, copy) void(^LxmSelectBankBlock)(LxmBankListModel *model);

@end

@interface LxmSelectBankCell : UITableViewCell

@property (nonatomic, strong) LxmBankListModel *model;

@end
