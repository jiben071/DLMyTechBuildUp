//
//  UITextField+HideKeyboard.h
//  Alpha1S_NewInteractionDesign
//
//  Created by chenlin on 15/8/6.
//  Copyright (c) 2015年 Ubtechinc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (HideKeyboard)

/**
 @brief     设置点击隐藏textField的view
 @param     view 要点击的view
 @return    
 */
-(void)hideKeyboardInView:(UIView *)view;

@end
