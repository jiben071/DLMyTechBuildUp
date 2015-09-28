//
//  DLCommonMacro.h
//  DLGenTechBuildup
//
//  Created by denglong on 15/9/25.
//  Copyright © 2015年 denglong. All rights reserved.
//

#ifndef DLCommonMacro_h
#define DLCommonMacro_h

#define ScreenWidth             ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight            ([UIScreen mainScreen].bounds.size.height)
#define ScreenSize              ([UIScreen mainScreen].bounds.size)

//判断是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

//获得RGB颜色
#define DLColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#endif /* DLCommonMacro_h */
