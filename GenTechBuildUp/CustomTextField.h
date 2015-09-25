//
//  CustomTextField.h
//  Alpha1S_NewInteractionDesign
//
//  Created by chenlin on 15/8/6.
//  Copyright (c) 2015年 Ubtechinc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTextField : UITextField<UITextFieldDelegate>

-(instancetype)initWithFrame:(CGRect)frame
                 placeholder:(NSString *)placeholder
                   leftImage:(NSString *)leftImage
                    leftText:(NSString *)leftText
                    hideView:(UIView *)hideView;

-(void)setLeftImage:(NSString *)leftImage
           leftText:(NSString *)leftText
        placeholder:(NSString *)placeholder
           hideView:(UIView *)hideView;

@property (nonatomic, assign) BOOL hideLayerBorder;//是否隐藏边框

@end
