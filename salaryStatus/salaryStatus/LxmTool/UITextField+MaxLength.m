//
//  UITextField+MaxLength.m
//  54school
//
//  Created by 宋乃银 on 2018/9/1.
//  Copyright © 2018年 李晓满. All rights reserved.
//

#import "UITextField+MaxLength.h"
#import <objc/runtime.h>

@implementation UITextField (MaxLength)
@dynamic maxLength;

- (void)setMaxLength:(NSInteger)maxLength {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(maxLength_textDidChange:) name:UITextFieldTextDidChangeNotification object:self];
    objc_setAssociatedObject(self, @"maxLength", @(maxLength), OBJC_ASSOCIATION_RETAIN);
}

- (NSInteger)maxLength {
    NSNumber *number = objc_getAssociatedObject(self, @"maxLength");
    return number.integerValue;
}

- (void)maxLength_textDidChange:(NSNotification *)noti {
    if (noti.object == self) {
        NSInteger maxLength = self.maxLength;
        if (maxLength > 0 && self.text.length > maxLength) {
            self.text = [self.text substringToIndex:maxLength];
        }
    }
}

@end


@implementation UITextView (MaxLength)
@dynamic maxLength;

- (void)setMaxLength:(NSInteger)maxLength {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(maxLength_textDidChange:) name:UITextViewTextDidChangeNotification object:self];
    objc_setAssociatedObject(self, @"maxLength", @(maxLength), OBJC_ASSOCIATION_RETAIN);
}

- (NSInteger)maxLength {
    NSNumber *number = objc_getAssociatedObject(self, @"maxLength");
    return number.integerValue;
}

- (void)maxLength_textDidChange:(NSNotification *)noti {
    if (noti.object == self) {
        NSInteger maxLength = self.maxLength;
        if (maxLength > 0 && self.text.length > maxLength) {
            self.text = [self.text substringToIndex:maxLength];
        }
    }
}

@end
