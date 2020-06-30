//
//  BaseTableViewController.h
//  ShareGo
//
//  Created by 李晓满 on 16/4/7.
//  Copyright © 2016年 李晓满. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseTableViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

-(instancetype)initWithTableViewStyle:(UITableViewStyle)style;

- (void)showNoneDataLabel;

- (void)hideNoneDataLabel;

- (void)gotoLogin;

- (void)endRefrish;

@property(nonatomic,strong,readonly)UITableView * tableView;


////分享
//- (void)shareWeChatTitle:(NSString *)title content:(NSString *)content pic:(NSString *)pic url:(NSString *)url ok:(void(^)(void))okBlock error:(void(^)(void))errorBlock;
//- (void)shareWXPYQTitle:(NSString *)title content:(NSString *)content pic:(NSString *)pic url:(NSString *)url ok:(void(^)(void))okBlock error:(void(^)(void))errorBlock;

@end
