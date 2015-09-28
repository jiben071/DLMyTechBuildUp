//
//  UITableViewCell+MarkKeyword.m
//  StoryboardDemo
//
//  Created by chenlin on 15/6/24.
//  Copyright (c) 2015年 Ubtechinc. All rights reserved.
//

#import "UITableViewCell+MarkKeyword.h"

@implementation UITableViewCell (MarkKeyword)

#pragma mark - set text
-(void)setText:(NSString *)text
     searchKey:(NSString *)searchKey
{
    if (!text.length)
    {
        text = @"";
    }
    if (!searchKey.length)
    {
        searchKey = @"";
    }
    NSRange range = [text rangeOfString:searchKey options:NSCaseInsensitiveSearch];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:text];
    
    if (range.location == NSNotFound)
    {
        [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,text.length)];
    }
    else
    {
        [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,range.location)];
        [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(range.location,range.length)];
        [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(range.location + range.length,text.length - range.location - range.length)];
        //    [attribute addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:30.0] range:NSMakeRange(0, 5)];
        //    [attribute addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0] range:NSMakeRange(6, 12)];
        //    [attribute addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Courier-BoldOblique" size:30.0] range:NSMakeRange(19, 6)];
    }
    
    [self.textLabel setAttributedText:attribute];
}

@end
