//
//  YMBaseDataModel.m
//  Helper
//
//  Created by QinMingChuan on 14-3-17.
//  Copyright (c) 2014年 QinMingChuan. All rights reserved.
//

#import "YMBaseDataModel.h"
#import <objc/runtime.h>

@implementation YMBaseDataModel

//从字典给属性赋值
- (void)setObjectAndKeysWithDict:(NSMutableDictionary *)dict
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

// 获取对象的所有属性
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

// 获取对象的所有方法
-(NSArray *)printMothList
{
    NSMutableArray *prints = [NSMutableArray array];
    unsigned int mothCout_f =0;
    Method* mothList_f = class_copyMethodList([self class],&mothCout_f);
    for(int i = 0; i < mothCout_f; i++)
    {
        Method temp_f = mothList_f[i];
//        IMP imp_f = method_getImplementation(temp_f);
//        SEL name_f = method_getName(temp_f);
//        int arguments = method_getNumberOfArguments(temp_f);
//        const char* encoding =method_getTypeEncoding(temp_f);
//        NSLog(@"方法名：%@,参数个数：%d,编码方式：%@",[NSString stringWithUTF8String:name_s], arguments, [NSString stringWithUTF8String:encoding]);
        
        const char *name_s =sel_getName(method_getName(temp_f));
        if(strlen(name_s) > 0)
        {
            char firstChar = name_s[0];
            if((firstChar >= 'a' && firstChar <= 'z') || (firstChar >= 'A' && firstChar <= 'Z'))
            {
                [prints addObject:[NSString stringWithUTF8String:name_s]];
            }
        }
    }
    
    free(mothList_f);
    
    return prints.count > 0 ? prints: nil;
}

//输出debug代码
- (NSString *)description
{
    NSString *printString = [NSString stringWithFormat:@"%@%@", [super description], [[self properties_aps] description]];
    return printString;
}

@end
