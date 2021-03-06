//
//  InternationalControl.m
//  Diver
//
//  Created by 程凯 on 14-4-7.
//  Copyright (c) 2014年 Tentinet. All rights reserved.
//

#import "InternationalControl.h"

@implementation InternationalControl


static NSBundle *bundle = nil;

+ ( NSBundle * )bundle{
    
    return bundle;
}

+(void)initUserLanguage{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSString *string = [def valueForKey:@"userLanguage"];
    
    if(string.length == 0){
        
        //获取系统当前语言版本(中文zh-Hans,英文en)
        
        NSArray* languages = [def objectForKey:@"AppleLanguages"];
        
        NSString *current = [languages objectAtIndex:0];
        
        string = current;
        if ([current isEqualToString:@"zh-Hans"]) {
            [def setValue:@"zh-Hans" forKey:@"userLanguage"];
        }else{
            [def setValue:@"en" forKey:@"userLanguage"];
        }
        [def synchronize];//持久化，不加的话不会保存
    }
    
    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"lproj"];
    
    bundle = [NSBundle bundleWithPath:path];//生成bundle
}


+(void)setUserlanguage:(NSString *)language{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    //1.第一步改变bundle的值
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
    
    bundle = [NSBundle bundleWithPath:path];
    
    //2.持久化
    [def setValue:language forKey:@"userLanguage"];
    
    [def synchronize];
}
+(NSString *)userLanguageEnOrZh
{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSString *language = [def valueForKey:@"userLanguage"];
  
    
    if ([language isEqualToString:@"en"])
    {
        return @"en";
    } else{
        return @"zh";
    }
    
}
+(NSString *)userLanguage{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSString *language = [def valueForKey:@"userLanguage"];
    
    return language;
}

+ (NSString *)currentSysLanguage
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [def objectForKey:@"AppleLanguages"];
    return [languages objectAtIndex:0];
}
@end
