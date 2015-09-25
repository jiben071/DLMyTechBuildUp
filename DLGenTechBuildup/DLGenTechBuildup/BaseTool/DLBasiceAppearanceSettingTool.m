//
//  DLBasiceAppearanceSettingTool.m
//  DLGenTechBuildup
//
//  Created by denglong on 15/9/25.
//  Copyright © 2015年 denglong. All rights reserved.
//

#import "DLBasiceAppearanceSettingTool.h"
#import "UIColor+Utility.h"
#import "YMCategory.h"
#import "DLCommonMacro.h"

@implementation DLBasiceAppearanceSettingTool
#pragma mark - 设置底栏阴影图片
+ (void)settingNavigationBarBottomViewWithImageName:(NSString *)imgName backColor:(UIColor *)color{
    //[UIColor colorWithHexString:@"#040F1E"]
    //1.根据颜色生成一张背景图片
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:color size:CGSizeMake(ScreenWidth, 64.0f)] forBarMetrics:UIBarMetricsDefault];
    //2.设置底栏图片
    [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"choose_navigation_line"]];
    
    //3.注意：只设置底栏图片是不会生效的，必须具备一张背景图片
}


#pragma mark - 设置导航栏背景图片
+ (void)settingNavigationBarBackImage:(NSString *)imgName navigationBar:(UINavigationBar *)navigationBar{
    UIImageView *titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgName]];
    [navigationBar addSubview:titleView];
    [navigationBar sendSubviewToBack:titleView];
}
@end
