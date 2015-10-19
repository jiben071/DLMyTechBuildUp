//
//  NSTimer+blockSupport.h
//  alpha2s
//
//  Created by denglong on 15/9/17.
//  Copyright © 2015年 denglong. All rights reserved.
//  http://www.jianshu.com/p/a1312c1653aa

#import <Foundation/Foundation.h>

/*!
 *  @author denglong, 15-10-14 09:10:31
 *
 *  @brief  警惕使用NSTimer时的循环引用
 */
@interface NSTimer (blockSupport)
+ (NSTimer *)xx_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)())block
                                       repeats:(BOOL)repeats;
@end
