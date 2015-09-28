//
//  NSTimer+blockSupport.m
//  alpha2s
//
//  Created by denglong on 15/9/17.
//  Copyright © 2015年 denglong. All rights reserved.
//

#import "NSTimer+blockSupport.h"

@implementation NSTimer (blockSupport)
+ (NSTimer *)xx_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block
                                       repeats:(BOOL)repeats{
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(xx_blockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (void)xx_blockInvoke:(NSTimer *)timer {
    void (^block)() = timer.userInfo;
    if(block) {
        block();
    }
}
@end
