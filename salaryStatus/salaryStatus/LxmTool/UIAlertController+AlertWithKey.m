//
//  UIAlertController+AlertWithKey.m
//  JawboneUP
//
//  Created by 李晓满 on 2017/11/7.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import "UIAlertController+AlertWithKey.h"
#import "UIViewController+TopVC.h"
@implementation UIAlertController (AlertWithKey)
+(void)showAlertWithKey:(NSNumber *)num  message:(NSString *)message
{
    int n = [num intValue];
    NSString * msg = nil;
    switch (n)
    {
        case 2:
            msg=@"服务器异常";
            break;
        case 3:
            msg=@"没有相关数据";
            break;
        case 4:
            msg=@"必要参数为空";
            break;
        case 5:
            msg=@"验签失败";
            break;
        case 6:
            msg=message;
            break;
        case 7:
            msg=@"用户未登录";
            break;
        default:
            msg=message;
            break;
    }
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    
    [[UIViewController topViewController] presentViewController:alertController animated:YES completion:nil];
    
}

+(void)showAlertWithmessage:(NSString *)message {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    
    [[UIViewController topViewController] presentViewController:alertController animated:YES completion:nil];
}

@end
