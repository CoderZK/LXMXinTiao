//
//  LxmZhifuView.h
//  GatherEasyBuys
//
//  Created by 李晓满 on 2018/12/25.
//  Copyright © 2018年 DaLiu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LxmZhifuView : UIView

- (void)show;

- (void)dismiss;

@property (nonatomic, copy) void(^getPassword)(NSString * password);

@property (nonatomic, copy) void(^forgetPasswordBlock)(void);

@end

