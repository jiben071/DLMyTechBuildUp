//
//  UIView+AppendDivideLine.m
//  DLGenTechBuildup
//
//  Created by denglong on 15/9/28.
//  Copyright © 2015年 denglong. All rights reserved.
//

#import "UIView+AppendDivideLine.h"
#import "UIView+Helpers.h"

@implementation UIView (AppendDivideLine)
#pragma mark - 附加分隔线
- (void)appendDivideLine:(AppendDivideLineType )lineType lineColor:(UIColor *)lineColor{
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = lineColor;
    CGFloat lineX = 0;
    CGFloat lineY = 0;
    CGFloat lineW = 0;
    CGFloat lineH = 0;
    if (lineType == AppendDivideLineTypeTop) {
        lineW = self.frameSizeWidth;
        lineH = 1.0f;
    }else if (lineType == AppendDivideLineTypeBottom){
        lineY = self.frameSizeHeight - 1.0f;
        lineW = self.frameSizeWidth;
        lineH = 1.0f;
    }else if (lineType == AppendDivideLineTypeLeft){
        lineW = 1.0f;
        lineH = self.frameSizeHeight;
    }else{
        lineX = self.frameMaxX - 1.0f;
        lineW = 1.0f;
        lineH = self.frameSizeHeight;
    }
    line.frame = CGRectMake(lineX, lineY, lineW, lineH);
    [self addSubview:line];
}
@end
