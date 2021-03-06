//
//  InternationalControl.h
//  Diver
//
//  Created by 程凯 on 14-4-7.
//  Copyright (c) 2014年 Tentinet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InternationalControl : NSObject
+(NSBundle *)bundle;//获取当前资源文件

+(void)initUserLanguage;//初始化语言文件

+(NSString *)userLanguage;//获取应用当前语言
+(NSString *)userLanguageEnOrZh; //返回 en 或者 zh
+(void)setUserlanguage:(NSString *)language;//设置当前语言
/**
 获取当前系统语言
 */
+ (NSString *)currentSysLanguage;
@end
