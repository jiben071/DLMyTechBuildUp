//
//  DVToolButton.m
//  Diver
//
//  Created by denglong on 15/7/10.
//  Copyright (c) 2015年 Tentinet. All rights reserved.
//

#import "DVToolButton.h"
#import "UIColor+Helper.h"
#import "UIView+Helpers.h"

#define kbuttonIconImageWH 22.0f
#define kbuttonLabelH 12.0f

@implementation DVToolButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        [self setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat btnIconX = (self.frameSizeWidth - kbuttonIconImageWH) * 0.5;
    CGFloat btnIconY = 6.0f;
    return CGRectMake(btnIconX, btnIconY, kbuttonIconImageWH, kbuttonIconImageWH);//图片的位置大小
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = self.frameSizeHeight - kbuttonLabelH - 4.0;
    return CGRectMake(titleX, titleY, self.bounds.size.width, kbuttonLabelH);//文本的位置大小
}

@end
