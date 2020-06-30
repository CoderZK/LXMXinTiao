//
//  LxmVerityHeTongAlertView.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/2/22.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 同意协议按钮
 */
@interface LxmSureProtocolButton : UIButton

@property (nonatomic, strong) UIImageView *iconImgView;//图标

@property (nonatomic, strong) UIButton *underlineButton;//协议

@end


@interface LxmVerityHeTongAlertView : UIView

@property (nonatomic, copy) void(^finishProtocolBlock)(NSString *code);

@property (nonatomic, copy) void(^seeProtocolBlock)(void);

- (void)show;

- (void)dismiss;

@end


