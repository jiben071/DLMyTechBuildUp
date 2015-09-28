//
//  NSUserDefaults+Value.h
//  Alpha1S_NewInteractionDesign
//
//  Created by chenlin on 15/8/5.
//  Copyright (c) 2015年 Ubtechinc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Value)

/**
 @brief 对象存入NSUserDefaults
 @param  value 存储对象
 @param  key   键值
 */
+ (void)saveValue:(id)value forKey:(NSString *)key;

/**
 @brief 根据键值获取NSUserDefaults存储的对象
 @param  key   键值
 @return id    存储的对象
 */
+ (id)getValueForKey:(NSString *)key;

@end
