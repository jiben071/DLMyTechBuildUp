//
//  UIImage+dl.m
//  dlWeibo
//
//  Created by 邓 龙 on 2/10/15.
//  Copyright (c) 2015 dl. All rights reserved.
//

#import "UIImage+dl.h"

@implementation UIImage (dl)

#pragma mark -- 拦截UIImage的生成，适配iOS6和iOS7
//+(instancetype)imageWithName:(NSString *)imageName{
//    if (iOS7) {
//        NSString *newName = [imageName stringByAppendingString:@"_os7"];
//        UIImage *image = [UIImage imageNamed:newName];
//        if (image == nil) {
//            image =  [UIImage imageNamed:imageName];
//        }
//        return image;
//    }
//    
//    //非iOS7
//    return [UIImage imageNamed:imageName];
//}

+ (UIImage *)resizedImageWithName:(NSString *)name{
    return [self resizedImageWithName:name left:0.5 top:0.5];
}

+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top{
    UIImage *image = [self imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left  topCapHeight:image.size.height * top];
}
@end
