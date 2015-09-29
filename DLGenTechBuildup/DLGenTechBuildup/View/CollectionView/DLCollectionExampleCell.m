//
//  DLCollectionExampleCell.m
//  DLGenTechBuildup
//
//  Created by denglong on 15/9/29.
//  Copyright © 2015年 denglong. All rights reserved.
//

#import "DLCollectionExampleCell.h"
#import "DLCommonMacro.h"
#import "UIView+Helpers.h"

#define DEFAULT_CELL_BORDER_COLOR   DLColor(204,206,205)    //cell边框颜色
#define DEFAULT_CELL_BORDER_HEIGHT  0.5                 //cell边框高度
#define DEFAULT_CELL_CORNOR_RADIUS  2                   //cell圆角半径

@interface DLCollectionExampleCell()
@property (nonatomic,weak) UIButton *photoBtn;
@property (weak, nonatomic) UIButton *closeButton;
@end

@implementation DLCollectionExampleCell

#pragma mark - 初始化
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //1.按钮
        UIButton *photoBtn = [[UIButton alloc] init];
        [photoBtn setTitle:@"删除" forState:UIControlStateNormal];
        photoBtn.imageView.layer.borderColor = DEFAULT_CELL_BORDER_COLOR.CGColor;
        photoBtn.imageView.layer.cornerRadius = DEFAULT_CELL_CORNOR_RADIUS + 1;
        [self.contentView addSubview:photoBtn];
        photoBtn.adjustsImageWhenHighlighted = NO;
        [photoBtn setImage:[UIImage imageNamed:@"add_icon_normal"] forState:UIControlStateNormal];
        [photoBtn setImage:[UIImage imageNamed:@"add_icon_click"] forState:UIControlStateHighlighted];
        [photoBtn addTarget:self
                     action:@selector(tapProfileImage)
           forControlEvents:UIControlEventTouchUpInside];
        self.photoBtn = photoBtn;

        
        //2.删除按钮
        UIButton *closeButton = [[UIButton alloc] init];
        [closeButton setImage:[UIImage imageNamed:@"recordImage_delete"] forState:UIControlStateNormal];
        [self.contentView addSubview:closeButton];
        self.closeButton = closeButton;
        [self.closeButton addTarget:self action:@selector(deletePhoto:)
                   forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - 快速实例化单元格
+(instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath{
    DLCollectionExampleCell *collectionCell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"DLCollectionExampleCell" forIndexPath:indexPath];
    [collectionCell sizeToFit];
    return collectionCell;
}


#pragma mark - UI操作
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat photoMargin = 10;
    CGFloat cellW = self.frameSizeWidth;
    
    //1.图片
    CGFloat photoX = 0;
    CGFloat photoY = photoMargin;
    CGFloat photoW = cellW - photoMargin;
    CGFloat photoH = photoW;
    self.photoBtn.frame = CGRectMake(photoX, photoY, photoW, photoH);
    
    //2.删除按钮
    CGFloat closeBtnX = self.photoBtn.frameMaxX - photoMargin;
    CGFloat closeBtnY = 0;
    CGFloat closeBtnW = 20;
    CGFloat closeBtnH = closeBtnW;
    self.closeButton.frame = CGRectMake(closeBtnX, closeBtnY, closeBtnW, closeBtnH);
    
}

#pragma mark - 辅助操作
- (void) tapProfileImage{

}

- (void)deletePhoto: (UIButton *)sender{

}
@end
