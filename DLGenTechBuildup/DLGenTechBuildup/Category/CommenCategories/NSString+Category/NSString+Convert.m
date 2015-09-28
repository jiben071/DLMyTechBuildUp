//
//  NSString+Convert.m
//  Diver
//
//  Created by 程凯 on 14-4-9.
//  Copyright (c) 2014年 Tentinet. All rights reserved.
//

#import "NSString+Convert.h"

@implementation NSString (Convert)
-(NSString *) stringValue
{
    if([self isKindOfClass:[NSNumber class]])
    {
        NSNumber * number=(NSNumber * ) self;
        return  [number stringValue];
    }
    
    return  self;
}
@end
