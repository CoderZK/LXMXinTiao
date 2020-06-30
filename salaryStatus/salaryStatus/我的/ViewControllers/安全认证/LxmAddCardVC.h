//
//  LxmAddCardVC.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/29.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
typedef NS_ENUM(NSInteger, LxmAddCardVC_type) {
    LxmAddCardVC_type_add,
    LxmAddCardVC_type_huanbang
};
@interface LxmAddCardVC : BaseTableViewController

@property (nonatomic, strong) NSString *oldId;

- (instancetype)initWithTableViewStyle:(UITableViewStyle)style type:(LxmAddCardVC_type)type;

@end


