//
//  LxmTabBarVC.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/25.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmTabBarVC.h"
#import "LxmResourceVC.h"
#import "LxmMineVC.h"

@interface LxmTabBarVC ()

@end

@implementation LxmTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.backgroundImage = [UIImage imageNamed:@"tabbarwhite"];
    self.tabBar.shadowImage = [UIImage new];
    self.tabBar.barTintColor = UIColor.whiteColor;
    self.tabBar.tintColor = UIColor.whiteColor;
    self.tabBar.layer.shadowColor = [MineColor colorWithAlphaComponent:0.2].CGColor;
    self.tabBar.layer.shadowRadius = 5;
    self.tabBar.layer.shadowOpacity = 0.5;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, 0);
    
    LxmResourceVC *resourceVC = [[LxmResourceVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    resourceVC.tabBarItem.image = [[UIImage imageNamed:@"ico_zichan_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    resourceVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"ico_zichan_y"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [resourceVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MineColor} forState:UIControlStateSelected];
    [resourceVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:CharacterLightGrayColor} forState:UIControlStateNormal];
    resourceVC.tabBarItem.title = @"资产";
    BaseNavigationController *nav1 = [[BaseNavigationController alloc] initWithRootViewController:resourceVC];
    
    
    LxmMineVC *mineVC = [[LxmMineVC alloc] initWithTableViewStyle:UITableViewStyleGrouped];
    mineVC.tabBarItem.image = [[UIImage imageNamed:@"ico_wode_n"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"ico_wode_y"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [mineVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:MineColor} forState:UIControlStateSelected];
    [mineVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:CharacterLightGrayColor} forState:UIControlStateNormal];
    mineVC.tabBarItem.title = @"我的";
    BaseNavigationController *nav2 = [[BaseNavigationController alloc] initWithRootViewController:mineVC];
    
     self.viewControllers = @[nav1,nav2];
}


@end
