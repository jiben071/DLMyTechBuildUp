//
//  UIButton+Extension.m
//  Diver
//
//  Created by Tentinet on 14-3-29.
//  Copyright (c) 2014年 Tentinet. All rights reserved.
//

#import "UIButton+Extension.h"
#import "UIView+Helpers.h"
#import "NSString+Helpers.h"
#import "DLCommonMacro.h"
#import "UIColor+Helper.h"


@implementation UIButton (Extension)

- (void)resizeBackgroundImage
{
    UIImage *resizeNormalImage = [[self backgroundImageForState:UIControlStateNormal]
                                  stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    [self setBackgroundImage:resizeNormalImage forState:UIControlStateNormal];
    
    
    UIImage *resizeHighLightImage = [[self backgroundImageForState:UIControlStateHighlighted]
                                     stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    [self setBackgroundImage:resizeHighLightImage forState:UIControlStateHighlighted];
    
}

- (void)alginImageRightToTitleAndSpace:(CGFloat)space
{
    CGSize btnTitleSize = [[self titleForState:UIControlStateNormal] sizeWithFont:self.titleLabel.font];
    UIImage *imgae = [self imageForState:UIControlStateNormal];
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, btnTitleSize.width + space, 0, 0)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, imgae.size.width)];
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.frame.size.width, 0, self.imageView.frame.size.width);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, self.titleLabel.frame.size.width + space, 0, -self.titleLabel.frame.size.width);
}

- (void)alginImageRightToTitleAndSpace:(CGFloat)space minSize:(CGSize)minSize
{
    NSString *title = [self titleForState:UIControlStateNormal];
    
    CGSize btnTitleSize = [title sizeWithFont:self.titleLabel.font];
    UIImage *imgae = [self imageForState:UIControlStateNormal];
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, btnTitleSize.width + space, 0, 0)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, imgae.size.width)];
    
    CGFloat width = MAX(btnTitleSize.width + imgae.size.width + space, minSize.width);
    CGFloat heiht = MAX(btnTitleSize.height, minSize.height);
    heiht = MAX(imgae.size.height, heiht);
    [self setFrameSize:CGSizeMake(width,heiht)];
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.frame.size.width, 0, self.imageView.frame.size.width);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, self.titleLabel.frame.size.width + space, 0, -self.titleLabel.frame.size.width);
    
    if (title == nil || [title isBlank]) {

        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    
//    self.frameSize = CGSizeMake(btnTitleSize.width + imgae.size.width + space, 20);

    
}

- (void)alginImageLeftToTitleAndSpace:(CGFloat)space minSize:(CGSize)minSize
{
    CGSize btnTitleSize = [[self titleForState:UIControlStateNormal] sizeWithFont:self.titleLabel.font];
    UIImage *imgae = [self imageForState:UIControlStateNormal];
    
//    BYDLogDebug(@"size:%@",NSStringFromCGSize(imgae.size));
    
    float leftX;
    if (iOS7) {
        leftX = 0;
    }else{
        leftX = 5;
    }
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, leftX, 0, space)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, space+leftX, 0, 0)];
    
    CGFloat width = MAX(btnTitleSize.width + imgae.size.width + space, minSize.width);
    CGFloat heiht = MAX(btnTitleSize.height, minSize.height);
    heiht = MAX(imgae.size.height, heiht);
    [self setFrameSize:CGSizeMake(width,heiht)];
    
    
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
}

- (void)alginImageLeftToTitleAndSpace:(CGFloat)space
{
//    CGSize btnTitleSize = [[self titleForState:UIControlStateNormal] sizeWithFont:self.titleLabel.font];
    UIImage *imgae = [self imageForState:UIControlStateNormal];
    
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, space)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, space, 0, 0)];
    
}


- (void)imagePosition:(ButtonImagePosition)imagePosition space:(CGFloat)space
{
    [self imagePosition:imagePosition space:space padding:UIEdgeInsetsZero isbouns:YES];
}
- (void)imagePosition:(ButtonImagePosition)imagePosition space:(CGFloat)space isbouns:(BOOL)isbouns
{
    [self imagePosition:imagePosition space:space padding:UIEdgeInsetsZero isbouns:isbouns];
    
}

- (void)imagePosition:(ButtonImagePosition)imagePosition space:(CGFloat)space padding:(UIEdgeInsets)padding isbouns:(BOOL)isbouns
{
    CGSize imageSize = self.currentImage.size;
    CGSize titleSize = [self.currentTitle sizeWithFont:self.titleLabel.font];
    
    switch (imagePosition) {
        case ButtonImagePositionTop:
        case ButtonImagePositionBottom:
        {
            
            int direction = imagePosition == ButtonImagePositionTop ? -1 : 1;
            
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0, - imageSize.width, (imageSize.height + space) * direction,0)];
            [self setImageEdgeInsets:UIEdgeInsetsMake((titleSize.height + space) * direction, 0, 0, - titleSize.width)];
            
            CGFloat width = MAX(imageSize.width, titleSize.width);
            CGFloat height = imageSize.height + titleSize.height + space;
            
            width = MAX(width, self.frameSizeWidth);
            height = MAX(height, self.frameSizeHeight);
            
            if (isbouns) {
                [self setFrameSize:CGSizeMake(width, height)];
                [self setFrame:UIEdgeInsetsInsetRect(self.frame, padding)];
            }
     
            
        }
            break;
        case ButtonImagePositionLeft:
        case ButtonImagePositionRight:
        {
            int direction = imagePosition == ButtonImagePositionLeft ? -1 : 1;
            [self setImageEdgeInsets:UIEdgeInsetsMake(0,(titleSize.width + space) * direction ,0,-titleSize.width)];
            [self setTitleEdgeInsets:UIEdgeInsetsMake(0,-imageSize.width,0,(imageSize.width + space) * direction)];
            
            CGFloat width = imageSize.width + titleSize.width + space;
            CGFloat height = MAX(imageSize.height, titleSize.height);
            
            width = MAX(width, self.frameSizeWidth);
            height = MAX(height, self.frameSizeHeight);
            
            if (isbouns) {
                [self setFrameSize:CGSizeMake(width, height)];
                [self setFrame:UIEdgeInsetsInsetRect(self.frame, padding)];
            }
        }
            break;
        default:
            break;
    }
}


- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType {
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:12.0f]];
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self setImageEdgeInsets:UIEdgeInsetsMake(-8.0,0.0,0.0,-titleSize.width)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:10.0f]];
    [self.titleLabel setTextColor:[UIColor colorWithHex:0x999999]];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(30.0,
                                              -image.size.width,
                                              0.0,
                                              0.0)];
    [self setTitle:title forState:stateType];
}

@end
