 //
//  UIColor+Utility.h
//  Alpha1S_NewInteractionDesign
//
//  Created by chenlin on 15/8/5.
//  Copyright (c) 2015年 Ubtechinc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RGBA(r,g,b,a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a / 255.0];

@interface UIColor (Utility)

/**
 @brief 从十六进制字符串获取颜色
 @param color 支持@“#123456”、 @“0X123456”、 @“123456”三种格式
 @note 默认透明度为1
 @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)color;

/**
 @brief 从十六进制字符串获取颜色
 @param color 支持@“#123456”、 @“0X123456”、 @“123456”三种格式
 @param alpha 透明度
 @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

/**
 @brief 获取随机颜色，一般用于调试
 @return
 */
+ (UIColor *)randomColor;
@end
