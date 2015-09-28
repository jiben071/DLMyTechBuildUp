//
//  UIImage+Scale.h
//  Alpha1S_NewInteractionDesign
//
//  Created by chenlin on 15/8/4.
//  Copyright (c) 2015年 Ubtechinc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)

/**
 @brief 等比例缩放image
 @param size        缩放之前的size
 @param direction   UIViewContentMode
 @return UIImage 缩放后的image
 @warning 放置缩放后的imageView的contentMode必须与direction设置的一致
 */
-(UIImage *)scaleToSize:(CGSize)size direction:(UIViewContentMode)direction;

/**
 @brief 等比例缩放后的size
 @param  size   缩放之前的size
 @return CGSize 缩放后的size
 @warning 放置缩放后的imageView的contentMode必须与direction设置的一致
 */
-(CGSize)scaledSize:(CGSize)size;

/**
 @brief 利用拍照功能，如果拍出的照片大于2M，照片会自动旋转90度，需要修正orientation信息
 @param aImage  原来的image
 @param UIImage 处理后的image
 @return
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;

/**
 @brief 对image进行简单的缩放，忽略宽高比
 @param image       缩放前的image
 @param newSize     缩放后的size
 @return UIImage    缩放后的image
 */
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

/**
 @brief 根据颜色绘出image对象
 @param color   颜色值
 @param size    绘制区域
 @return UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end

