//
//  LxmCardTypeVC.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/30.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LxmMineModel.h"

@interface LxmCardTypeVC : BaseTableViewController

@property (nonatomic, copy) void(^LxmSelectCareTypeBlock)(LxmSelcetBankModel *model);

@end


