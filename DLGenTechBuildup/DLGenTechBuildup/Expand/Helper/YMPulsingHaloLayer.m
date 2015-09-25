//
//  YMPulsingHaloLayer.m
//  YM
//
//  Created by QinMingChuan on 14-5-5.
//  Copyright (c) 2014年 zengxiang All rights reserved.
//

#import "YMPulsingHaloLayer.h"
#import "YMCategory.h"

#define kAnimationKey @"pulsingHalo"

@interface YMPulsingHaloLayer()

@property (nonatomic, strong) CAAnimationGroup *animationGroup;

@end

@implementation YMPulsingHaloLayer

- (void)dealloc{
    [self removeAnimationForKey:kAnimationKey];
}

- (id)init {
    self = [super init];
    if (self) {
        
        self.contentsScale = [UIScreen mainScreen].scale;
        self.opacity = 0;
        
        // default
        self.radius = 60;
        self.animationDuration = 2;
        self.pulseInterval = 0;
        self.backgroundColor = [[UIColor colorWithRed:0 green:208.0f/255.0f blue:150.0f/255.0f alpha:0.5] CGColor];
        
    }
    return self;
}

- (void)beginAnimationAfterDelay:(NSTimeInterval)afterDelay
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        [self setupAnimationGroup];
    });
    
    if(afterDelay == 0)
    {
        [self beginMyAnimation];
    }
    else
    {
        [self performSelector:@selector(beginMyAnimation) withObject:nil afterDelay:afterDelay];
    }
}

- (void)beginMyAnimation
{
    if(!self.animationGroup)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        
            [self setupAnimationGroup];
            
            if(self.pulseInterval != INFINITY)
            {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    
                    [self addAnimation:self.animationGroup forKey:kAnimationKey];
                });
            }
        });
    }
    else
    {
        if(self.pulseInterval != INFINITY) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                [self addAnimation:self.animationGroup forKey:kAnimationKey];
            });
        }
    }
}

- (void)setRadius:(CGFloat)radius
{
    _radius = radius;
    
    CGPoint tempPos = self.position;
    
    CGFloat diameter = self.radius * 2;
    
    self.bounds = CGRectMake(0, 0, diameter, diameter);
    self.cornerRadius = self.radius;
    self.position = tempPos;
}

//关闭动画
- (void)closeAnimation{
    [self removeAllAnimations];
    [self cancelPreviousPerformRequestsWithSelector:@selector(beginMyAnimation) object:nil];
}

- (void)setupAnimationGroup
{
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    self.animationGroup = [CAAnimationGroup animation];
    self.animationGroup.duration = self.animationDuration + self.pulseInterval;
    self.animationGroup.repeatCount = INFINITY;
    self.animationGroup.removedOnCompletion = NO;
    self.animationGroup.timingFunction = defaultCurve;
    
    //基本动画 放大
//    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
//    scaleAnimation.fromValue = @0.0;
//    scaleAnimation.toValue = @1.0;
//    scaleAnimation.duration = self.animationDuration;
//    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; //缓入缓出
    
    //关键帧动画 放大
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.duration = self.animationDuration;
    scaleAnimation.values = @[@0.9, @1.1, @1.3];
    scaleAnimation.keyTimes = @[@0, @0.5, @1];
    scaleAnimation.removedOnCompletion = NO;
    
    //关键帧动画 透明度和时间复合
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = self.animationDuration;
    opacityAnimation.values = @[@1, @0.8,@0.6,@0.4,@0.2, @0];
    opacityAnimation.keyTimes = @[@0, @0.2, @0.4,@0.6,@0.8,@1];
    opacityAnimation.removedOnCompletion = NO;
    
    NSArray *animations = @[scaleAnimation, opacityAnimation];
    
    self.animationGroup.animations = animations;
    
    [self setNeedsDisplay];
}


//旋转动画
+ (CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount
{
    CATransform3D rotationTransform  = CATransform3DMakeRotation(degree, 0, 0,direction);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue       = [NSValue valueWithCATransform3D:rotationTransform];
    animation.duration      = dur;
    animation.autoreverses  = NO;
    animation.cumulative    = YES;
    animation.fillMode      = kCAFillModeForwards;
    animation.repeatCount   = repeatCount;
    animation.delegate      = self;
    animation.removedOnCompletion = NO;
    
    return animation;
}

@end
