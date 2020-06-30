//
//  LxmMessageVC.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/26.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LxmMessageModel.h"

@interface LxmMessageVC : BaseTableViewController

@end

@interface LxmMessageCell : UITableViewCell

@property (nonatomic, strong) LxmMessageModel *model;

@end
