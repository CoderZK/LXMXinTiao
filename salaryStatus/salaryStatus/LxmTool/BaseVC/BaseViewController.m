//
//  BaseViewController.m
//  Lxm
//
//  Created by Lxm on 15/10/13.
//  Copyright © 2015年 Lxm. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<UIGestureRecognizerDelegate>

@end
@implementation BaseViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (BOOL)shouldAutorotate
{
    return NO;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
	return NO;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=BGGrayColor;
    
    self.navigationController.navigationBar.tintColor = CharacterDarkColor;
    if (self.navigationController.viewControllers.count > 1) {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_back"] style:UIBarButtonItemStyleDone target:self action:@selector(baseLeftBtnClick)];
        leftItem.tintColor = UIColor.whiteColor;
//        leftItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 10);
        self.navigationItem.leftBarButtonItem = leftItem;
    }
}

- (void)baseLeftBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //只有在二级页面生效
        if ([self.navigationController.viewControllers count] > 1) {
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        } else {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}


- (void)loadMyUserInfoWithOkBlock:(void(^)(void))okBlock {
    //获取个人信息
    [LxmNetworking networkingPOST:user_personInfo parameters:@{@"token":TOKEN} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"key"] integerValue] == 1) {
            [LxmTool ShareTool].userModel = [LxmUserInfoModel mj_objectWithKeyValues:responseObject[@"result"]];
            [LxmEventBus sendEvent:@"userInfo" data:nil];
            if (okBlock) {
                okBlock();
            }
        } else {
            [UIAlertController showAlertWithKey:responseObject[@"key"] message:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


@end
