//
//  LxmCardTypeVC.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/30.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmCardTypeVC.h"
#import "LxmSelectBankVC.h"

@interface LxmCardTypeVC ()

@property (nonatomic, strong) NSMutableArray <LxmSelcetBankModel *>*dataArr;

@end

@implementation LxmCardTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择卡类型";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataArr = [NSMutableArray array];
    LxmSelcetBankModel *m = [[LxmSelcetBankModel alloc] init];
    m.bank = @"储蓄卡";
    m.isSelect = NO;
    
    LxmSelcetBankModel *m0 = [[LxmSelcetBankModel alloc] init];
    m0.bank = @"信用卡";
    m0.isSelect = NO;
    
    [self.dataArr addObject:m];
    [self.dataArr addObject:m0];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmSelectBankCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSelectBankCell"];
    if (!cell) {
        cell = [[LxmSelectBankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSelectBankCell"];
    }
    LxmSelcetBankModel *m = self.dataArr[indexPath.row];
    cell.model = m;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    for (LxmSelcetBankModel *m in self.dataArr) {
        m.isSelect = NO;
    }
    LxmSelcetBankModel *m = self.dataArr[indexPath.row];
    m.isSelect = !m.isSelect;
    if (self.LxmSelectCareTypeBlock) {
        self.LxmSelectCareTypeBlock(m);
    }
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
