//
//  LxmUserInfoVC.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/28.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmUserInfoVC : BaseTableViewController

@end

/**
 头像cell
 */
@interface LxmUserInfoHeaderImageCell : UITableViewCell

@property (nonatomic, strong) UILabel *leftLabel;//左侧标签

@property (nonatomic, strong) UIImageView *headerImgView;//头像

@end

/**
 姓名 性别 手机号cell
 */
@interface LxmUserInfoNameSexCell : UITableViewCell

@property (nonatomic, strong) UILabel *leftLabel;//左侧标签

@property (nonatomic, strong) UITextField *rightTF;//右侧TF

@end
