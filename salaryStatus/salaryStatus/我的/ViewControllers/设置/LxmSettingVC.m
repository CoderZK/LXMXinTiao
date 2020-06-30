//
//  LxmSettingVC.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/30.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmSettingVC.h"
#import "LxmLoginVC.h"
#import "LxmWebViewController.h"
#import "NSFileManager+FileSize.h"

@interface LxmSettingVC ()

@property (nonatomic, strong) UIView *bottomView;//底部view

@property (nonatomic, strong) UIButton *exitButton;//退出登录

@property (nonatomic , assign)CGFloat cacheSize;//缓存大小

@property (nonatomic, assign) BOOL isOpen;

@end

@implementation LxmSettingVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString * path = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/default/com.hackemist.SDWebImageCache.default"];
    self.cacheSize = [NSFileManager getFileSizeForDir:path];
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.shadowColor = MineColor.CGColor;
        _bottomView.layer.shadowOffset = CGSizeZero;
        _bottomView.layer.shadowOpacity = 0.5;//阴影透明度，默认0
        _bottomView.layer.shadowRadius = 10;//阴影半径，默认3
    }
    return _bottomView;
}

- (UIButton *)exitButton {
    if (!_exitButton) {
        _exitButton = [[UIButton alloc] init];
        [_exitButton setBackgroundImage:[UIImage imageNamed:@"lightblue"] forState:UIControlStateNormal];
        [_exitButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [_exitButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _exitButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _exitButton.layer.cornerRadius = 5;
        _exitButton.layer.masksToBounds = YES;
        [_exitButton addTarget:self action:@selector(exitClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitButton;
}

//退出登录
- (void)exitClick {
    if (SESSION_TOKEN && ISLOGIN) {
        NSDictionary *dict = @{
                               @"token": SESSION_TOKEN,
                               @"type" : @1//用户类型1员工2中介
                               };
        [SVProgressHUD show];
        [LxmNetworking networkingPOST:user_logout parameters:dict returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];
            if ([responseObject[@"key"] integerValue] == 1) {
                
                [LxmTool ShareTool].pushToken = @"";
                [[LxmTool ShareTool] uploadDeviceToken];
                
                [LxmTool ShareTool].session_token = nil;
                [LxmTool ShareTool].isLogin = NO;
                [SVProgressHUD showSuccessWithStatus:@"已退出登录"];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];
        }];
    } else {
        [SVProgressHUD showErrorWithStatus:@"您尚未登录, 不能退出登录"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self setBottomView];
    [self loadPushStatus];
}

- (void)loadPushStatus {
    [LxmNetworking networkingPOST:user_queryPushStatus parameters:@{@"token" : SESSION_TOKEN} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"key"] integerValue] == 1) {
            NSString *str = responseObject[@"result"][@"isOpen"];
            self.isOpen = str.intValue == 0 ? NO : YES;
            [self.tableView reloadData];
        }else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

//设置 底部退出登录按钮
- (void)setBottomView {
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.exitButton];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.equalTo(@80);
    }];
    [self.exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bottomView);
        make.width.equalTo(@(ScreenW - 60));
        make.height.equalTo(@50);
    }];
    [self.view layoutIfNeeded];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LxmSettingCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmSettingCell"];
    if (!cell) {
        cell = [[LxmSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmSettingCell"];
    }
    if (indexPath.row == 0) {
        cell.leftLabel.text = @"清除缓存";
        cell.detailLabel.text = [NSString stringWithFormat:@"%.2f",self.cacheSize];
        cell.switchImgView.hidden = YES;
        cell.accImgView.hidden = NO;
    } else if (indexPath.row == 1) {
        cell.leftLabel.text = @"推送通知";
        cell.switchImgView.image =  [UIImage imageNamed:self.isOpen ? @"on" : @"off"];
        cell.accImgView.hidden = YES;
    } else {
        cell.leftLabel.text = @"关于我们";
        cell.switchImgView.hidden = YES;
        cell.accImgView.hidden = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        LxmWebViewController * vc = [[LxmWebViewController alloc] init];
        vc.navigationItem.title = @"关于我们";
        vc.hidesBottomBarWhenPushed = YES;
        vc.loadUrl = [NSURL URLWithString:@"https://app.salaryjumptech.com/appweb/AboutUs.html"];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 0){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //清除缓存
        if (self.cacheSize > 0) {
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:nil message:@"确定要清除缓存吗?" preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
            [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                NSString * path = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/default/com.hackemist.SDWebImageCache.default"];
                
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
                self.cacheSize = 0;
                [SVProgressHUD showSuccessWithStatus:@"清理成功" ];
                [self.tableView reloadData];
                
            }]];
            [self presentViewController:alertView animated:YES completion:nil];
        } else {
            [SVProgressHUD showErrorWithStatus:@"暂无缓存可清理!"];
        }
    }else {
        [SVProgressHUD show];
        [LxmNetworking networkingPOST:user_setPushStatus parameters:@{@"token" : SESSION_TOKEN, @"isOpen" : self.isOpen ? @0 : @1} returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"key"] intValue] == 1) {
                [SVProgressHUD showSuccessWithStatus: self.isOpen ? @"推送按钮已关闭" : @"推送按钮已开启"];
                self.isOpen = !self.isOpen;
                [self.tableView reloadData];
            }else {
                [UIAlertController showAlertWithmessage:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        [self.tableView reloadData];
    }
}


@end


@implementation LxmSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

- (void)initSubViews {
    [self addSubview:self.leftLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.switchImgView];
    [self addSubview:self.accImgView];
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = BGGrayColor;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@0.5);
    }];
}

- (void)setConstrains {
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    [self.switchImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.width.equalTo(@33);
        make.height.equalTo(@21);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.accImgView.mas_leading).offset(-3);
        make.centerY.equalTo(self);
    }];
    [self.accImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@15);
    }];
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.textColor = CharacterDarkColor;
        _leftLabel.font = [UIFont systemFontOfSize:15];
    }
    return _leftLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = CharacterDarkColor;
        _detailLabel.font = [UIFont systemFontOfSize:15];
    }
    return _detailLabel;
}

- (UIImageView *)switchImgView {
    if (!_switchImgView) {
        _switchImgView = [[UIImageView alloc] init];
    }
    return _switchImgView;
}

- (UIImageView *)accImgView {
    if (!_accImgView) {
        _accImgView = [[UIImageView alloc] init];
        _accImgView.image = [UIImage imageNamed:@"xiayiye"];
    }
    return _accImgView;
}

@end
