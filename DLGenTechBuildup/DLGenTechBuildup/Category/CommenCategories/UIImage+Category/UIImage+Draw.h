//
//  UIImage+Draw.h
//  Diver
//
//  Created by lxd on 15/3/25.
//  Copyright (c) 2015年 Tentinet. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kImageInstant   @"CIPhotoEffectInstant"   //MARK: - 怀旧
#define kImageTransfer  @"CIPhotoEffectTransfer"  //MARK: - 岁月
#define kImageProcess   @"CIPhotoEffectProcess"   //MARK: - 冲印
#define kImageChrome    @"CIPhotoEffectChrome"    //MARK: - 铬黄
#define kImageMono      @"CIPhotoEffectMono"      //MARK: - 单色
#define kImageFade      @"CIPhotoEffectFade"      //MARK: - 褪色
#define kImageNoir      @"CIPhotoEffectNoir"      //MARK: - 黑白
#define kImageTonal     @"CIPhotoEffectTonal"     //MARK: - 色调


@interface UIImage (Draw)

/**图片滤镜*/
- (UIImage*)imageFilterByFilterName:(NSString *)filterName;
@end
