//
//  NSString+Utility.h
//  UserDefinedActionEditDemo
//
//  Created by chenlin on 15/7/6.
//  Copyright (c) 2015年 Ubtechinc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface NSString (Utility)

/**
 @brief 获取路径下文件的md5
 @param  path     文件路径
 @return NSString 文件的md5
 */
+(NSString*)getFileMD5WithPath:(NSString *)path;

/**
 @brief md5加密 16位
 @param input   输入字符串
 @return NSString 小写
 */
+ (NSString *)md5HexDigest16:(NSString*)input;

/**
 @brief md5加密 32位
 @param input   输入字符串
 @return NSString 小写
 */
+ (NSString *)md5HexDigest32:(NSString*)input;


/**
 @brief 是否是合法的电子邮箱地址
 @param email   电子邮箱地址
 @param BOOL    YES 合法 NO 不合法
 @return
 */
+(BOOL)isValidateEmail:(NSString *)email;

/**
 @brief 是否是合法的手机号码
 @param mobile  手机号码
 @param BOOL    YES 合法 NO 不合法
 @return
 */
+(BOOL)isValidateMobile:(NSString *)mobile;

/**
 @brief 是否是合法的车牌
 @param carNo   车牌
 @param BOOL    YES 合法 NO 不合法
 @return
 */
+(BOOL)isValidateCarNo:(NSString *)carNo;

/**
 @brief 判断是否为纯数字
 @param string  字符
 @param BOOL    YES 纯数字 NO 不是纯数字
 @return
 */
+ (BOOL)isPureInt:(NSString *)string;

/**
 @brief 文本自适应大小
 @param text    文本
 @param size    文本显示区域限制
 @param font    文本字体
 @return CGSize
 */
+(CGSize)sizeWithText:(NSString *)text size:(CGSize)size font:(UIFont *)font;

/**
 @brief 是否为空字符串
 @note NSNull nil @""均当做空字符串
 @return
 */
-(BOOL)isEqualToNull;

@end
