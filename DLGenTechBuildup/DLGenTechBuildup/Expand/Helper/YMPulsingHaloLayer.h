//
//  YMPulsingHaloLayer.h
//  YM
//  脉冲动画层
//  Created by QinMingChuan on 14-5-5.
//  Copyright (c) 2014年 QinMingChuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface YMPulsingHaloLayer : CALayer

@property (nonatomic) CGFloat radius;                   // default:60pt
@property (nonatomic) NSTimeInterval animationDuration; // default:3s
@property (nonatomic) NSTimeInterval pulseInterval;     // default is 0s

//开始动画并指定延迟开始时间
- (void)beginAnimationAfterDelay:(NSTimeInterval)afterDelay;
//关闭动画
- (void)closeAnimation;

@end
