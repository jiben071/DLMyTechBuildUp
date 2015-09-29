//
//  DLCollectionExampleCell.h
//  DLGenTechBuildup
//
//  Created by denglong on 15/9/29.
//  Copyright © 2015年 denglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLCollectionExampleCell : UICollectionViewCell
/*!
 *  @author denglong, 15-09-29 09:09:58
 *
 *  @brief  快速实例化单元格
 *
 *  @param collectionView 集合视图容器
 *  @param indexPath      排序
 *
 *  @return 单元格
 */
+(instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
@end
