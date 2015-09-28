//
//  UIImage+Draw.m
//  Diver
//
//  Created by lxd on 15/3/25.
//  Copyright (c) 2015年 Tentinet. All rights reserved.
//

#import "UIImage+Draw.h"

@implementation UIImage (Draw)

- (UIImage *)imageFilterByFilterName:(NSString *)filterName {
    CIFilter *filter = [CIFilter filterWithName:filterName];
    
    CIImage *beginImage = [CIImage imageWithCGImage:self.CGImage];
    [filter setValue:beginImage forKey:kCIInputImageKey];
    
    //得到滤镜之后的图片
    CIImage *outputCIImage = [filter outputImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    
    // 转换图片
    CGImageRef cgimg = [context createCGImage:outputCIImage fromRect:[outputCIImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    
    //释放C对象
    CGImageRelease(cgimg);
    
    return newImg;
}

@end
