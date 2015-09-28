//
//  NSTimer+blockSupport.h
//  alpha2s
//
//  Created by denglong on 15/9/17.
//  Copyright © 2015年 denglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (blockSupport)
+ (NSTimer *)xx_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block
                                       repeats:(BOOL)repeats;
@end
