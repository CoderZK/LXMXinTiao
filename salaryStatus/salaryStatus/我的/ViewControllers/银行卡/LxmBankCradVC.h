//
//  LxmBankCradVC.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/30.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LxmResourceBannerModel.h"

@interface LxmBankCradVC : BaseTableViewController

@end

@interface LxmBankCradCell : UITableViewCell

@property (nonatomic, assign) NSInteger cellRow;

@property (nonatomic, strong) LxmSalaryBankInfoModel *bankModel;

@property (nonatomic, strong) LxmBankListModel *bankListModel;

@end

@interface LxmBankCardFooterView : UIButton

@end
