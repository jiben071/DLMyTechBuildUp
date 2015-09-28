//
//  NSString+size.m
//  Diver
//
//  Created by TentinetIOS12 on 15/4/24.
//  Copyright (c) 2015年 Tentinet. All rights reserved.
//

#import "NSString+size.h"
#import "DLCommonMacro.h"

@implementation NSString (size)
//返回字符串所占用的尺寸.
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    if (iOS7) {
        NSDictionary *attrs = @{NSFontAttributeName : font};
        return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    }
    
    return [self sizeWithFont:font
            constrainedToSize:maxSize];
}

@end
