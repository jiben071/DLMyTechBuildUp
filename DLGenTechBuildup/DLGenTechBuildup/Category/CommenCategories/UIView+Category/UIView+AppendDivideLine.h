//
//  UIView+AppendDivideLine.h
//  DLGenTechBuildup
//
//  Created by denglong on 15/9/28.
//  Copyright © 2015年 denglong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AppendDivideLineType){
    AppendDivideLineTypeTop = 0,
    AppendDivideLineTypeBottom = 1,
    AppendDivideLineTypeLeft = 2,
    AppendDivideLineTypeRight = 3,
};
@interface UIView (AppendDivideLine)
/*!
 *  @author denglong, 15-09-28 15:09:16
 *
 *  @brief  给视图附加一条分隔线
 *
 *  @param lineType 分隔线位置
 */
- (void)appendDivideLine:(AppendDivideLineType)lineType lineColor:(UIColor *)lineColor;
@end
