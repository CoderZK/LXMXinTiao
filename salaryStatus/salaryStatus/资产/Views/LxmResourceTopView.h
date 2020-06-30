//
//  LxmResourceTopView.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/25.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LxmResourceTopView : UIView

@property (nonatomic, assign) NSInteger orderType;

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr;

@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) NSArray *dataArr;

@end

NS_ASSUME_NONNULL_END
