//
//  ALCommentMethod.h
//  alpha2s
//
//  Created by denglong on 15/9/19.
//  Copyright © 2015年 denglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InternationalControl.h"

@interface ALCommentMethod : NSObject
/*!
 *  @author denglong, 15-09-19 12:09:13
 *
 *  @brief  获取本地化字符串
 *
 *  @param key 关键字
 *
 *  @return 关键字所对应的本地化字符串
 */
+ (NSString *)localizationString:(NSString *)key;
@end
