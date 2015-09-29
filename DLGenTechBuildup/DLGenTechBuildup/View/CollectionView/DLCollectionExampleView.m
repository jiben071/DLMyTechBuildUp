//
//  DLCollectionExampleView.m
//  DLGenTechBuildup
//
//  Created by denglong on 15/9/29.
//  Copyright © 2015年 denglong. All rights reserved.
//

#import "DLCollectionExampleView.h"
#import "DLCollectionExampleCell.h"


@interface DLCollectionExampleView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,weak) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation DLCollectionExampleView
#pragma mark - 初始化
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - 初始化UI
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initCollectionView];
    }
    return self;
}

- (void)initCollectionView{
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    //确定是水平滚动，还是垂直滚动
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    
    //注册Cell，必须要有
    [collectionView registerClass:[DLCollectionExampleCell class]forCellWithReuseIdentifier:@"DLCollectionExampleCell"];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    [self addSubview:collectionView];
    self.collectionView = collectionView;
}

#pragma mark - 设置子控件的Frame
- (void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

#pragma mark - UICollectionView Delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DLCollectionExampleCell *myCell = [DLCollectionExampleCell cellWithCollectionView:collectionView indexPath:indexPath];
    return myCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellWH = self.bounds.size.width / 4.0;
    return CGSizeMake(cellWH, cellWH);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //{top, left, bottom, right};
    return UIEdgeInsetsMake(5, 0, 5, 0);
}
@end
