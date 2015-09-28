//
//  ALCommentMethod.m
//  alpha2s
//
//  Created by denglong on 15/9/19.
//  Copyright © 2015年 denglong. All rights reserved.
//

#import "ALCommentMethod.h"


@implementation ALCommentMethod
+ (NSString *)localizationString:(NSString *)key{
    NSBundle *langBundle = [InternationalControl bundle];
    NSString *str = [langBundle localizedStringForKey:key value:@"" table:nil];
    return str;
}
@end
