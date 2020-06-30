//
//  LxmURLDefine.m
//  shenbian
//
//  Created by 李晓满 on 2018/11/12.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "LxmURLDefine.h"

@implementation LxmURLDefine

/**
 获取图片地址
 */
+(NSString *)getPicImgWthPicStr:(NSString *)pic{
    NSString * picStr = @"";
    if (pic) {
        if ([pic hasPrefix:@"http:"] || [pic hasPrefix:@"https:"]) {
            picStr = pic;
        }else{
            picStr = [Base_img_URL stringByAppendingString:pic];
        }
    }
    return picStr;
}

@end
