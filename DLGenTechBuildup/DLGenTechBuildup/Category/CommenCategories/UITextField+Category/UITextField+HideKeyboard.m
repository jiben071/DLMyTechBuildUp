//
//  UITextField+HideKeyboard.m
//  Alpha1S_NewInteractionDesign
//
//  Created by chenlin on 15/8/6.
//  Copyright (c) 2015年 Ubtechinc. All rights reserved.
//

#import "UITextField+HideKeyboard.h"

@implementation UITextField (HideKeyboard)

-(void)hideKeyboardInView:(UIView *)view
{
    if (!view)
    {
        return;
    }
    
    view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard:)];
    [view addGestureRecognizer:tap];
}

-(void)hideKeyboard:(UITapGestureRecognizer *)tap
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

@end
