//
//  CustomTextField.m
//  Alpha1S_NewInteractionDesign
//
//  Created by chenlin on 15/8/6.
//  Copyright (c) 2015年 Ubtechinc. All rights reserved.
//

#import "CustomTextField.h"
#import "UIColor+Utility.h"
#import "NSString+Utility.h"
#import "UIView+Helpers.h"

#define OffsetX 5
#define kTextFieldPlaceholderFont   [UIFont systemFontOfSize:13]
#define kTextFieldFontDefault       [UIFont systemFontOfSize:16]

@implementation CustomTextField{
    NSString *_placeholder;
    NSString *_leftImage;
    NSString *_leftText;
    UIView *_hideView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
                 placeholder:(NSString *)placeholder
                   leftImage:(NSString *)leftImage
                    leftText:(NSString *)leftText
                    hideView:(UIView *)hideView{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        _placeholder = placeholder;
        _leftImage = leftImage;
        _leftText = leftText;
        _hideView = hideView;
        
        [self setLeftImage:_leftImage leftText:_leftText placeholder:_placeholder hideView:_hideView];
        
    }
    return self;
}

-(CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect rect;
    
    CGFloat leftOffsetX = OffsetX;
    CGFloat rightOffsetX = 0;
    if (self.leftView){
        leftOffsetX = self.leftView.frameSizeWidth;
    }
    
    if (UITextFieldViewModeNever != self.clearButtonMode){
        rightOffsetX = 15;
    }
    
    rect = CGRectMake(bounds.origin.x + leftOffsetX, bounds.origin.y, bounds.size.width - leftOffsetX - rightOffsetX, bounds.size.height);
    
    return rect;
}

-(CGRect)placeholderRectForBounds:(CGRect)bounds{
    CGRect rect;
    CGFloat offsetX = OffsetX;
    if (self.leftView){
        offsetX = self.leftView.frameSizeWidth;
    }
    
    CGFloat width = bounds.size.width - offsetX;
    CGSize size = [NSString sizeWithText:self.placeholder size:CGSizeMake(width, CGFLOAT_MAX) font:kTextFieldPlaceholderFont];
    rect = CGRectMake(bounds.origin.x + offsetX, 0, width, size.height);
    return rect;
}

-(void)hideKeyboard:(UITapGestureRecognizer *)tap{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

-(void)setLeftImage:(NSString *)leftImage
           leftText:(NSString *)leftText
        placeholder:(NSString *)placeholder
           hideView:(UIView *)hideView{
    _placeholder = placeholder;
    _leftImage = leftImage;
    _leftText = leftText;
    _hideView = hideView;
    
    self.text = @"";
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#525251"]};
    self.backgroundColor = [UIColor clearColor];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                                 attributes:attributes];
    self.keyboardAppearance =  UIKeyboardAppearanceDark;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self setValue:kTextFieldPlaceholderFont forKeyPath:@"_placeholderLabel.font"];
    self.textColor = [UIColor whiteColor];
    self.font = kTextFieldFontDefault;
    
    
    if (!_hideLayerBorder){
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [[UIColor colorWithHexString:@"#F1EC55"]CGColor];
        self.layer.borderWidth = 0.5f;
        self.layer.cornerRadius = 2.0;
    }
    
    if (hideView){
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard:)];
        [hideView addGestureRecognizer:tap];
    }
    
    if (!leftImage.length && !leftText.length){
        self.leftViewMode = UITextFieldViewModeNever;
    }else{
        self.leftViewMode = UITextFieldViewModeAlways;
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frameSizeHeight, self.frameSizeHeight)];
        if (leftText.length){
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, self.frameSizeHeight)];
            label.text = leftText;
            label.textColor = [UIColor whiteColor];
            self.leftViewMode = UITextFieldViewModeAlways;
            [leftView addSubview:label];
        }else if (leftImage.length){
            CGFloat width = self.frameSizeHeight / 2;
            CGFloat offset = (self.frameSizeHeight - width) / 2;
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(offset, offset, width, width)];
            image.backgroundColor = [UIColor clearColor];
            image.image = [UIImage imageNamed:leftImage];
            image.contentMode = UIViewContentModeScaleAspectFit;
            [leftView addSubview:image];
        }
        self.leftView = leftView;
    }
    self.delegate = self;
}

-(void)setHideLayerBorder:(BOOL)hideLayerBorder{
    _hideLayerBorder = hideLayerBorder;
    if (!_hideLayerBorder){
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [[UIColor colorWithHexString:@"#F1EC55"]CGColor];
        self.layer.borderWidth = 0.5f;
        self.layer.cornerRadius = 2.0;
    }else{
        self.layer.masksToBounds = NO;
        self.layer.borderWidth = 0;
        self.layer.cornerRadius = 0;
    }
}

@end
