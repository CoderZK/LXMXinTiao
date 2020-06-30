//
//  LxmAccountDetailVC.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/31.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LxmResourceBannerModel.h"

typedef NS_ENUM(NSInteger, LxmAccountDetailVC_type) {
    LxmAccountDetailVC_type_kejie,
    LxmAccountDetailVC_type_moneyAccount,
    LxmAccountDetailVC_type_qianbao
};

@interface LxmAccountDetailVC : BaseTableViewController

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(LxmAccountDetailVC_type)type;

@end


@interface LxmAccountDetailCell : UITableViewCell

@property (nonatomic, strong) LxmAccountDetailModel *yujieModel;

@property (nonatomic, strong) LxmAccountDetailModel *zhanghuModel;

@property (nonatomic, strong) LxmAccountDetailModel *qianbaoModel;

@end
