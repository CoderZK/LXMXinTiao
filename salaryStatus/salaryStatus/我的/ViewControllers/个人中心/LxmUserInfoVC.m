//
//  LxmUserInfoVC.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/28.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmUserInfoVC.h"
#import "LxmSettingPasswordVC.h"

#import <AssetsLibrary/ALAssetsLibrary.h>
#import "MXPhotoPickerController.h"
#import "UIViewController+MXPhotoPicker.h"

@interface LxmUserInfoVC ()

@property (nonatomic, strong) UIView *bottomView;//底部view

@property (nonatomic, strong)  UIButton *saveButton;//保存

@property (nonatomic, strong) UIImage *headerImage;//头像

@end

@implementation LxmUserInfoVC

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

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] init];
        [_saveButton setBackgroundImage:[UIImage imageNamed:@"lightblue"] forState:UIControlStateNormal];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _saveButton.layer.cornerRadius = 5;
        _saveButton.layer.masksToBounds = YES;
    }
    return _saveButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![LxmTool ShareTool].userModel) {
        [self loadMyUserInfoWithOkBlock:^{
            [self.tableView reloadData];
        }];
    } else {
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人信息";
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self initSubViews];
}

- (void)initSubViews {
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.saveButton];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.equalTo(@80);
    }];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bottomView);
        make.width.equalTo(@(ScreenW - 60));
        make.height.equalTo(@50);
    }];
    [self.view layoutIfNeeded];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 4 || indexPath.row == 5) {
        LxmUserInfoHeaderImageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmUserInfoHeaderImageCell"];
        if (!cell) {
            cell = [[LxmUserInfoHeaderImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmUserInfoHeaderImageCell"];
        }
        if (indexPath.row == 0) {
            cell.leftLabel.text = @"头像";
            cell.headerImgView.hidden = NO;
            [cell.headerImgView sd_setImageWithURL:[NSURL URLWithString:[LxmURLDefine getPicImgWthPicStr:[LxmTool ShareTool].userModel.avatar]] placeholderImage:[UIImage imageNamed:@"moren"]];
        } else if (indexPath.row == 4) {
            cell.leftLabel.text = @"登录密码修改";
            cell.headerImgView.hidden = YES;
        } else if (indexPath.row == 5) {
            cell.leftLabel.text = @"提现密码修改";
            cell.headerImgView.hidden = YES;
        }
        return cell;
    } else {
        LxmUserInfoNameSexCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LxmUserInfoNameSexCell"];
        if (!cell) {
            cell = [[LxmUserInfoNameSexCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LxmUserInfoNameSexCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 1) {
            cell.leftLabel.text = @"姓名";
            cell.rightTF.userInteractionEnabled = NO;
            cell.rightTF.text = [LxmTool ShareTool].userModel.name ? [LxmTool ShareTool].userModel.name : @"";
        } else if (indexPath.row == 2) {
            cell.leftLabel.text = @"性别";
            cell.rightTF.userInteractionEnabled = NO;
            cell.rightTF.text =  [LxmTool ShareTool].userModel.gender;
        } else {
            cell.leftLabel.text = @"手机号码";
            cell.rightTF.userInteractionEnabled = NO;
            cell.rightTF.text = [LxmTool ShareTool].userModel.phone ? [LxmTool ShareTool].userModel.phone : @"";
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 100;
    } else {
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        UIAlertController * actionController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction * a1 = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showMXPhotoCameraAndNeedToEdit:YES completion:^(UIImage *image, UIImage *originImage, CGRect cutRect) {
                if (image) {
                    [self uploadHeadImage:image];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"图片获取失败"];
                }
            }];
        }];
        
        UIAlertAction * a2 = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showMXPhotoPickerControllerAndNeedToEdit:YES completion:^(UIImage *image, UIImage *originImage, CGRect cutRect) {
                if (image) {
                    [self uploadHeadImage:image];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"图片获取失败"];
                }
                
            }];
        }];
        UIAlertAction * a3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [actionController addAction:a1];
        [actionController addAction:a2];
        [actionController addAction:a3];
        [self presentViewController:actionController animated:YES completion:nil];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             [self.tableView reloadData];
        }];
    } else if (indexPath.row == 4) {//登录密码修改
        LxmSettingPasswordVC *vc = [[LxmSettingPasswordVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmSettingPasswordVC_type_login];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 5) {//提现密码修改
        if ([LxmTool ShareTool].userModel.isSetCashPwd.intValue == 0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"您还未设置提现密码,确定要前往设置吗!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                LxmSettingPasswordVC *vc = [[LxmSettingPasswordVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmSettingPasswordVC_type_tixian];
                [self.navigationController pushViewController:vc animated:YES];
            }];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"暂不设置" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:action];
            [alertController addAction:action1];
            [self presentViewController:alertController animated:YES completion:nil];
        }else {
            LxmSettingPasswordVC *vc = [[LxmSettingPasswordVC alloc] initWithTableViewStyle:UITableViewStyleGrouped type:LxmSettingPasswordVC_type_tixian];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)uploadHeadImage:(UIImage *)image {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain", @"text/html",@"text/json",@"text/javascript",@"text/x-chdr", nil];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    [manager POST: Base_upload_img_URL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (image) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.5) name:@"file" fileName:@"test.jpg" mimeType:@"image/jpeg"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        [self editUserInfoWithArray:responseObject[@"result"][@"fileIdList"]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

- (void)editUserInfoWithArray:(NSArray *)ids {
    NSDictionary *dic = @{
                          @"avatar" : ids.firstObject,
                          @"token" : SESSION_TOKEN
                          };
    [SVProgressHUD show];
    [LxmNetworking networkingPOST:user_editUserInfo parameters:dic returnClass:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        if ([responseObject[@"key"] intValue] == 1) {
            [SVProgressHUD showSuccessWithStatus:@"头像修改成功!"];
            [self loadMyUserInfoWithOkBlock:^{
                [self.tableView reloadData];
            }];
        } else {
            [UIAlertController showAlertWithmessage:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


@end

@interface LxmUserInfoHeaderImageCell ()

@property (nonatomic, strong) UIImageView *accImgView;//箭头

@end

@implementation LxmUserInfoHeaderImageCell

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

- (void)initSubViews {
    [self addSubview:self.leftLabel];
    [self addSubview:self.headerImgView];
    [self addSubview:self.accImgView];
}

- (void)setConstrains {
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    [self.headerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.accImgView.mas_leading).offset(-10);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@70);
    }];
    [self.accImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.trailing.equalTo(self).offset(-15);
        make.width.height.equalTo(@10);
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

- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.image = [UIImage imageNamed:@"touxiang"];
        _headerImgView.layer.cornerRadius = 35;
        _headerImgView.layer.masksToBounds = YES;
    }
    return _headerImgView;
}

- (UIImageView *)accImgView {
    if (!_accImgView) {
        _accImgView = [[UIImageView alloc] init];
        _accImgView.image = [UIImage imageNamed:@"xiayiye"];
    }
    return _accImgView;
}

@end


/**
 姓名 性别 手机号cell
 */
@interface LxmUserInfoNameSexCell ()

@end

@implementation LxmUserInfoNameSexCell

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

- (void)initSubViews {
    [self addSubview:self.leftLabel];
    [self addSubview:self.rightTF];
}

- (void)setConstrains {
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    [self.rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
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

- (UITextField *)rightTF {
    if (!_rightTF) {
        _rightTF = [[UITextField alloc] init];
        _rightTF.font = [UIFont systemFontOfSize:15];
        _rightTF.textColor = CharacterDarkColor;
    }
    return _rightTF;
}

@end
