 //
//  BaseModel.m
//  BYDFans
//
//  Created by QinMingChuan on 14-3-17.
//  Copyright (c) 2014年 Tentinet. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

@implementation BaseModel

//从字典给属性赋值
- (void)setObjectAndKeysWithDict:(NSDictionary *)dict
{
    for(NSString *key in dict.allKeys)
    {
        char cc = [key characterAtIndex:0];
        cc = cc + 'A' - 'a'; //第一个字母大写
        NSString *selString = [NSString stringWithFormat:@"set%c%@:",cc,[key substringFromIndex:1]];
        SEL selector = sel_registerName(selString.UTF8String);
        if([self respondsToSelector:selector])
        {
            [self setValue:dict[key] forKey:key];
        }
    }
}

- (NSDictionary *)properties_aps
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];

        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    
    free(properties);
    
    return props;
}

- (NSString *)description
{
    NSString *printString = [NSString stringWithFormat:@"%@%@", [super description], [[self properties_aps] description]];
    return printString;
}

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self != nil) {
    
    }
    
    return self;
}

@end
