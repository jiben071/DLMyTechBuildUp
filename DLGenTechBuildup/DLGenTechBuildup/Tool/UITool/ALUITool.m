//
//  ALUITool.m
//  alpha2s
//
//  Created by denglong on 15/9/15.
//  Copyright (c) 2015年 denglong. All rights reserved.
//

#import "ALUITool.h"
#import "NSString+size.h"

@implementation ALUITool
+ (CGSize)sizeOfLabel:(UILabel *)label labelWidth:(CGFloat)labelWidth{
    if (!label || !label.text) {
        return CGSizeZero;
    }
    return [label.text sizeWithFont:label.font maxSize:CGSizeMake(labelWidth, MAXFLOAT)];
}

@end
