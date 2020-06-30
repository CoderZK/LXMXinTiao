//
//  LxmMineVC.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/25.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmMineVC : BaseTableViewController

@end

/**
 用户头像cell
 */
@interface LxmMineHeaderCell : UITableViewCell

@property (nonatomic, strong) LxmUserInfoModel * model;

@end

/**
 我的界面其他样式cell
 */
@interface LxmMineOtherCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImgView;//图标

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *detaillabel;//说明

@end


