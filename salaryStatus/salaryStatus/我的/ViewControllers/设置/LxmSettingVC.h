//
//  LxmSettingVC.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/30.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmSettingVC : BaseTableViewController

@end

@interface LxmSettingCell : UITableViewCell

@property (nonatomic, strong) UILabel *leftLabel;//左侧按钮

@property (nonatomic, strong) UILabel *detailLabel;//缓存大小

@property (nonatomic, strong) UIImageView *switchImgView;//开关

@property (nonatomic, strong) UIImageView *accImgView;//箭头

@end
