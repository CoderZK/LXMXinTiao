//
//  NSString+Size.h
//  JawboneUP
//
//  Created by 李晓满 on 2017/10/17.
//  Copyright © 2017年 李晓满. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)
/**
 获得字符串的大小
 */

- (CGSize)getSizeWithMaxSize:(CGSize)maxSize withFontSize:(int)fontSize;
/**
 获得字符串的大小 粗体
 */
- (CGSize)getSizeWithMaxSize:(CGSize)maxSize withBoldFontSize:(int)fontSize;
/* MD5字符串 */
+ (NSString *)stringToMD5:(NSString *)str;

+ (NSDate *)dataWithStr:(NSString *)str;
/****
 ios比较日期大小默认会比较到秒
 ****/
+ (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;


+ (NSString *)convertToJsonData:(id)dict;
+ (CGFloat)getHeightWith:(NSString *)str;

/**
 转化时间
 */
+ (NSString *)stringWithTime:(NSString *)str;

/**
 返回订单状态
 */
+ (NSString *)retOrderStatus:(NSString *)status;

/**
 格式化时间
 */
+ (NSString *)formatterTime:(NSString *)str;

/**
 格式化时间
 */
+ (NSString *)formatterTimee:(NSString *)str;

/**
 获得日子
 */
+ (NSString *)getDay:(NSString *)str;



@end
