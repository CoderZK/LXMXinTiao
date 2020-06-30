//
//  LxmRegistVC.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/26.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmRegistVC : BaseTableViewController

@end

@interface LxmRegistView : UIView

@property (nonatomic, strong) UILabel *leftLabel;

@property (nonatomic, strong) UITextField *rightTF;

@property (nonatomic, strong) UIView *lineView;

@end

@interface LxmAgreeButton : UIButton

@property (nonatomic, strong) UIImageView *iconImgView;

@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) UIButton *protocolButton;

@property (nonatomic, strong) UILabel *textLabel;

@end
