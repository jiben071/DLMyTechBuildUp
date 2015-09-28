//
//  NSUserDefaults+Value.m
//  Alpha1S_NewInteractionDesign
//
//  Created by chenlin on 15/8/5.
//  Copyright (c) 2015年 Ubtechinc. All rights reserved.
//

#import "NSUserDefaults+Value.h"

@implementation NSUserDefaults (Value)

+(void)saveValue:(id)value forKey:(NSString *)key
{
    if (!value || !key)
    {
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
    
}

+(id)getValueForKey:(NSString *)key
{
    if (!key)
    {
        return nil;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    id object = [userDefaults objectForKey:key];
    
    return object;
}

@end
