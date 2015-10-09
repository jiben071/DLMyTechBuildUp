//
//  UIImage+dl.h
//  dlWeibo
//
//  Created by 邓 龙 on 2/10/15.
//  Copyright (c) 2015 dl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (dl)

/**
 加载图片
 */
//+ (instancetype)imageWithName:(NSString *)imageName;

/**
 返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;

+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;
@end
