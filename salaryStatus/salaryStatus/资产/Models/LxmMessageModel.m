//
//  LxmMessageModel.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/26.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmMessageModel.h"

@implementation LxmMessageModel
@synthesize cellHeight = _cellHeight;

- (CGFloat)cellHeight {
    if (_cellHeight == 0) {
        CGFloat titleHeight = [self.title getSizeWithMaxSize:CGSizeMake(ScreenW - 130, 9999) withBoldFontSize:15].height + 30;
        CGFloat contentHeight = [self.content getSizeWithMaxSize:CGSizeMake(ScreenW - 30, 9999) withFontSize:13].height + 15;
        _cellHeight = titleHeight + contentHeight;
    }
    return _cellHeight;
}

@end

@implementation LxmMessageRootModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"result" : @"LxmMessageModel"
             };
}

@end
