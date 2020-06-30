//
//  LxmSelectView.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/29.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LxmSelectView : UIButton

@property (nonatomic, strong) UILabel *leftLabel;//左侧label

@property (nonatomic, strong) UILabel *rightLabel;//右侧label

@end


@interface LxmAgreeProtocolButton : UIButton

@property (nonatomic, strong) UIImageView *iconImgView;//图标

@property (nonatomic, strong) UIButton *protocolButton;//协议

@end
