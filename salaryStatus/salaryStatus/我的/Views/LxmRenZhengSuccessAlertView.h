//
//  LxmRenZhengSuccessAlertView.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/9/4.
//  Copyright © 2019 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LxmRenZhengSuccessAlertView : UIView

@property (nonatomic, assign) BOOL isSuccess;

@property (nonatomic, copy) void(^backBlock)(LxmRenZhengSuccessAlertView *view);

- (void)show;

- (void)dismiss;

@end


