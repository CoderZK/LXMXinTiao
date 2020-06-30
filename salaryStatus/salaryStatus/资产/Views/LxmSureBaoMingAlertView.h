//
//  LxmSureBaoMingAlertView.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/2/1.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LxmSureBaoMingAlertView : UIView

@property (nonatomic, copy) void(^sureBaoMingClick)(void);

- (void)show;

- (void)dismiss;

@end


