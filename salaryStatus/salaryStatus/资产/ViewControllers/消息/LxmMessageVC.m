//
//  LxmMessageVC.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/26.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmMessageVC.h"

@interface LxmMessageVC ()

@property (nonatomic, strong) NSArray <LxmMessageModel *>*dataArr;

@end

@implementation LxmMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"消息中心";
    self.dataArr = [NSArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self loadData];
}

- (void)loadData {
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:user_findNewsList parameters:@{@"token" : SESSION_TOKEN} returnClass:[LxmMessageRootModel class] success:^(NSURLSessionDataTask *task, LxmMessageRootModel *responseObject) {
        [SVProgressHUD dismiss];
        if (responseObject.key.intValue == 1) {
            self.dataArr = responseObject.result;
            self.dataArr.count > 0 ? [self hideNoneDataLabel] : [self showNoneDataLabel];
            [self.tableView reloadData];
        }else {
            [UIAlertController showAlertWithmessage:responseObject.message];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmMessageCell"];
    if (!cell) {
        cell = [[LxmMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmMessageCell"];
    }
    LxmMessageModel *m = self.dataArr[indexPath.row];
    cell.model = m;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmMessageModel *m = self.dataArr[indexPath.row];
    return m.cellHeight;
}

@end

@interface LxmMessageCell()

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) UILabel *timeLabel;//时间

@property (nonatomic, strong) UILabel *contentLabel;//内容

@property (nonatomic, strong) UIView *redView;

@end

@implementation LxmMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        [self setConstrains];
        
        UIView * line = [[UIView alloc] init];
        line.backgroundColor = BGGrayColor;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

/**
 初始化子视图
 */
- (void)initSubViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.redView];
}

/**
 设置约束
 */
- (void)setConstrains {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-115);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.width.equalTo(@100);
    }];
    [self.redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.equalTo(self.timeLabel);
        make.width.height.equalTo(@6);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
    }];
}

/**
 懒加载子视图
 */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = CharacterDarkColor;
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = CharacterLightGrayColor;
        _timeLabel.font = [UIFont systemFontOfSize:15];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}
- (UIView *)redView {
    if (!_redView) {
        _redView = [[UIView alloc] init];
        _redView.backgroundColor = [UIColor colorWithRed:255/255.0 green:67/255.0 blue:66/255.0 alpha:1];
        _redView.layer.cornerRadius = 3;
        _redView.layer.masksToBounds = YES;
    }
    return _redView;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = CharacterDarkColor;
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

/**
 赋值
 */
- (void)setModel:(LxmMessageModel *)model {
    _model = model;
    self.titleLabel.text = _model.title;
    self.timeLabel.text = _model.creatTime;
    self.redView.hidden = _model.isread.intValue == 1 ? YES : NO;
    self.contentLabel.text = _model.content;
}

@end
