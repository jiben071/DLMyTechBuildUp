//
//  DLBasiceAppearanceSettingTool.h
//  DLGenTechBuildup
//
//  Created by denglong on 15/9/25.
//  Copyright © 2015年 denglong. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*!
 *  @author denglong, 15-09-25 15:09:46
 *
 *  @brief  通用设置
 */
@interface DLBasiceAppearanceSettingTool : NSObject
/*!
 *  @author denglong, 15-09-25 15:09:30
 *
 *  @brief  设置底栏阴影图片
 *
 *  @param imgName 图片名称
 *  @param color   导航栏背景色
 */
+ (void)settingNavigationBarBottomViewWithImageName:(NSString *)imgName backColor:(UIColor *)color;

/*!
 *  @author denglong, 15-09-25 15:09:04
 *
 *  @brief  设置导航栏背景图片
 *
 *  @param imgName       背景图片
 *  @param navigationBar 导航栏
 */
+ (void)settingNavigationBarBackImage:(NSString *)imgName navigationBar:(UINavigationBar *)navigationBar;
@end
