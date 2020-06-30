//
//  BaseTableViewController.m
//  ShareGo
//
//  Created by 李晓满 on 16/4/7.
//  Copyright © 2016年 李晓满. All rights reserved.
//

#import "BaseTableViewController.h"
//#import "LxmLocationManager.h"
#import "BaseNavigationController.h"
//#import <UMShare/UMShare.h>

@interface BaseTableViewController ()
{
    UITableViewStyle _tableViewStyle;
    UILabel *_noneLabel;
}
@end
@implementation BaseTableViewController

-(instancetype)initWithTableViewStyle:(UITableViewStyle)style
{
    if (self=[super init])
    {
        _tableViewStyle = style;
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initBaseTableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _noneLabel = [[UILabel alloc] init];
    _noneLabel.text = @"没有数据!";
    _noneLabel.hidden = YES;
    _noneLabel.textColor = CharacterDarkColor;
    _noneLabel.font = [UIFont systemFontOfSize:15];
    [self.tableView addSubview:_noneLabel];
    [_noneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
    }];
}

- (void)showNoneDataLabel {
    _noneLabel.hidden = NO;
}

- (void)hideNoneDataLabel {
    _noneLabel.hidden = YES;
}
-(void)initBaseTableView
{
    _tableView=[[UITableView alloc] initWithFrame:self.view.bounds style:_tableViewStyle];
    _tableView.autoresizingMask  =  UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}


- (void)endRefrish {
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

@end
