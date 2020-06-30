//
//  LxmYiLuYongTopView.m
//  salaryStatus
//
//  Created by 李晓满 on 2019/2/12.
//  Copyright © 2019年 李晓满. All rights reserved.
//

#import "LxmYiLuYongTopView.h"
#import "LxmResourceBannerModel.h"
#import "LxmDateHeaderView.h"

@interface LxmYiLuYongTopView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger currentIndex;//当前选中

@property (nonatomic, strong) UILabel *topLabel;//日期展示

@end

@implementation LxmYiLuYongTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(floor(ScreenW/7), 100);
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 100 + 30) collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [self addSubview:self.collectionView];
        
        [self.collectionView registerClass:[LxmYiLuYongCollectionCell class] forCellWithReuseIdentifier:@"LxmYiLuYongCollectionCell"];
        
         [_collectionView registerClass:[LxmDateHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LxmDateHeaderView"];
        
    }
    return self;
}

- (void)setKeyArr:(NSArray *)keyArr {
    _keyArr = keyArr;
}
- (void)setDataDict:(NSMutableDictionary *)dataDict {
    _dataDict = dataDict;
    [self.collectionView reloadData];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *arr = [self.dataDict objectForKey:[self.keyArr objectAtIndex:section]];
    return arr.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.keyArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LxmYiLuYongCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LxmYiLuYongCollectionCell" forIndexPath:indexPath];
    NSArray *arr = [self.dataDict objectForKey:[self.keyArr objectAtIndex:
                                                indexPath.section]];
    LxmXintiaoProcessModel * model = [arr objectAtIndex:indexPath.item];
    cell.topLabel.text = [NSString stringWithFormat:@"周%@", [self zhuan:model.weekday.intValue]];
    cell.centerLabel.text = [NSString getDay:model.workTime];
    cell.bottomLabel.text = [NSString stringWithFormat:@"%ldh",model.workHour.integerValue];
    cell.bgYuanImgView.hidden = !(self.currentIndex == indexPath.item);
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        LxmDateHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"LxmDateHeaderView" forIndexPath:indexPath];
        
        NSArray *arr = [self.dataDict objectForKey:[self.keyArr objectAtIndex:
                                                    indexPath.section]];
        LxmXintiaoProcessModel * model = [arr firstObject];
        headerView.titleLab.text = model.sectionTitle;
        return headerView;
    }
    return nil;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.bounds.size.width, 30);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndex = indexPath.item;
    if (self.didSelectItemBlock) {
        self.didSelectItemBlock(self.currentIndex);
    }
    [self.collectionView reloadData];
}

- (NSString *)zhuan:(NSInteger)week {
    switch (week) {
        case 1:
            return  @"一";
            break;
        case 2:
            return  @"二";
            break;
        case 3:
            return  @"三";
            break;
        case 4:
            return  @"四";
            break;
        case 5:
            return  @"五";
            break;
        case 6:
            return  @"六";
            break;
        case 7:
            return  @"日";
            break;
            
        default:
            return  @" ";
            break;
    }
}


@end


@interface LxmYiLuYongCollectionCell ()

@end

@implementation LxmYiLuYongCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
        [self setConstrains];
    }
    return self;
}

- (UILabel *)topLabel {
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.font = [UIFont systemFontOfSize:15];
        _topLabel.textColor = UIColor.whiteColor;
    }
    return _topLabel;
}

- (UILabel *)centerLabel {
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc] init];
        _centerLabel.font = [UIFont boldSystemFontOfSize:15];
        _centerLabel.textColor = UIColor.whiteColor;
    }
    return _centerLabel;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.font = [UIFont systemFontOfSize:12];
        _bottomLabel.textColor = UIColor.whiteColor;
    }
    return _bottomLabel;
}

- (UIImageView *)bgYuanImgView {
    if (!_bgYuanImgView) {
        _bgYuanImgView = [[UIImageView alloc] init];
        _bgYuanImgView.image = [UIImage imageNamed:@"bg_riqi"];
    }
    return _bgYuanImgView;
}

- (void)initSubViews {
    [self addSubview:self.topLabel];
    [self addSubview:self.bgYuanImgView];
    [self addSubview:self.centerLabel];
    [self addSubview:self.bottomLabel];
}

- (void)setConstrains {
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
        make.height.equalTo(@20);
    }];
    [self.bgYuanImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.equalTo(@58);
    }];
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.equalTo(@20);
    }];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.centerX.equalTo(self);
        make.height.equalTo(@20);
    }];
}

@end
