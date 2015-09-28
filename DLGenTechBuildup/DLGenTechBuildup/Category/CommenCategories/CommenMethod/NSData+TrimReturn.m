//
//  NSData+TrimReturn.m
//  Diver
//
//  Created by 程凯 on 14-4-9.
//  Copyright (c) 2014年 Tentinet. All rights reserved.
//

#import "NSData+TrimReturn.h"

@implementation NSData (TrimReturn)

-(NSData *) trimReturn
{
    
    NSString * str=[[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    NSString * strResult=str;
    strResult=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSData * result=[strResult dataUsingEncoding:NSUTF8StringEncoding];
    
    return  result;
}
@end
