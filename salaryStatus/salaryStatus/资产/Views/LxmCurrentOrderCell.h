//
//  LxmCurrentOrderCell.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/1/25.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LxmResourceBannerModel.h"

@interface LxmCurrentOrderCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier section:(NSInteger)section;

@property (nonatomic, assign) NSInteger orderType;

@property (nonatomic, strong) NSMutableArray <LxmAssetWorkSubProcessDataModel *>*workProgressArr;//薪跳历程

@property (nonatomic, strong) NSArray * dataArr;

@property (nonatomic, strong) LxmAssetCurrentOrderDataModel *currentDataModel;//当前订单

@end

