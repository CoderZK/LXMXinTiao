//
//  LxmAddCardNextVCViewController.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/29.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"


@interface LxmAddCardNextVC : BaseTableViewController

@property (nonatomic, assign) BOOL isHuanban;

@property (nonatomic, strong) NSString *oldId;

@property (nonatomic, strong)  NSMutableDictionary *bankInfodDic;//银行卡类型

@property (nonatomic, strong)  NSString *shiBieImageID;//Ocr识别的银行卡

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *cardNo;

@end

