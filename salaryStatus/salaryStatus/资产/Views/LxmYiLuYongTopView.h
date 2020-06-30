//
//  LxmYiLuYongTopView.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/2/12.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LxmYiLuYongTopView : UIView

@property (nonatomic,strong) NSMutableDictionary * dataDict;

@property (nonatomic,strong) NSArray * keyArr;

@property (nonatomic, copy) void(^didSelectItemBlock)(NSInteger Index);

@end

@interface LxmYiLuYongCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *topLabel;//周几

@property (nonatomic, strong) UILabel *centerLabel;//几号

@property (nonatomic, strong) UILabel *bottomLabel;//工作时间

@property (nonatomic, strong) UIImageView *bgYuanImgView;//圆点背景

@end
