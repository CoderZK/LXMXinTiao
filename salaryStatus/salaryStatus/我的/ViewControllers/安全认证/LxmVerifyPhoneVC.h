//
//  LxmVerifyPhoneVC.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/30.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LxmVerifyPhoneVC : BaseTableViewController

@property (nonatomic, assign) BOOL isHuanban;

@property (nonatomic, strong) NSString *oldId;

@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong)  NSString *shiBieImageID;//Ocr识别的银行卡

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *cardNo;

@property (nonatomic, strong) NSString *bankId;

@property (nonatomic, strong) NSString *bank;

@end

@interface LxmVerifyPhoneCodeView : UIView

@property (nonatomic, strong) UIButton *sendCodeButton;//重新发送

@property (nonatomic, strong) UITextField *codeTF;//填写验证码

@end
