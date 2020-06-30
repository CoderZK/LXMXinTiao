//
//  LxmYiLuYongCell.h
//  salaryStatus
//
//  Created by 李晓满 on 2019/2/13.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LxmYiLuYongCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier row:(NSInteger)row;

@property (nonatomic, strong) NSArray *dataArr;

@end


