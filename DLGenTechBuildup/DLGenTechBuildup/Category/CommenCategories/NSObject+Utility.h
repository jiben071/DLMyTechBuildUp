//
//  NSObject+Utility.h
//  Alpha1S_NewInteractionDesign
//
//  Created by chenlin on 15/8/5.
//  Copyright (c) 2015年 Ubtechinc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (Utility)

+ (NSString *)replaceNilString:(NSString *)value;

+ (id)deepMutableCopyWithJson:(id)json;

+ (NSString *)toStringWithJsonValue:(id)value;
+ (NSNumber *)toNSNumberWithJsonValue:(id)value;
+ (NSInteger)toIntegerWithJsonValue:(id)value;
+ (BOOL)toBoolWithJsonValue:(id)value;
+ (int16_t)toInt16WithJsonValue:(id)value;
+ (int32_t)toInt32WithJsonValue:(id)value;
+ (int64_t)toInt64WithJsonValue:(id)value;
+ (short)toShortWithJsonValue:(id)value;
+ (float)toFloatWithJsonValue:(id)value;
+ (double)toDoubleWithJsonValue:(id)value;
+ (id)toArrayWithJsonValue:(id)value;
+ (id)toDictionaryWithJsonValue:(id)value;

/**
 @brief 比较版本，是否需要升级
 @param current 本地版本
 @param server  服务器版本
 @return BOOL YES:需要升级 NO：不需要升级
 */
+ (BOOL)compareVersionWithCurrent:(NSString *)current server:(NSString *)server;

/**
 @brief 由于本项目json模型采用的是映射的方法，所以这里对关键字比如description等进行处理，
 防止由于api的readonly属性复制导致崩溃
 @param keyWord 关键字(description)等
 @param dictionary 数据源
 @return NSDictionary 处理后的字典
 */
+ (NSDictionary *)dataHandleWithKey:(NSString *)keyWord dictionary:(NSDictionary *)dictionary;

/**
 @brief 获取当前屏幕显示的viewcontroller
 */
+ (UIViewController *)getCurrentVC;

/**
 @brief 重命名时候是否包含非法字符
 @return BOOL YES 包含非法字符 NO 不包含非法字符
 */
+(BOOL)containsRenameIllegalCharacter:(NSString *)string;

/**
 @brief 从讯飞语音的识别结果中获取文字
 @param params
 ex:{"sn":1,"ls":true,"bg":0,"ed":0,"ws":[{"bg":0,"cw":[{"w":"白日","sc":0}]},{"bg":0,"cw":[{"w":"依山","sc":0}]},{"bg":0,"cw":[{"w":"尽","sc":0}]},{"bg":0,"cw":[{"w":"黄河入海流","sc":0}]},{"bg":0,"cw":[{"w":"。","sc":0}]}]}
 
 @return NSString
 */
+ (NSString *)stringFromIFlyVoiceJson:(NSString *)params;

/**
 @brief 根据storyboard和storyboardId生成congtroller
 @param storyboardName  storyboard名字
 @param storyboardID    controller对应的storyboardID
 @return UIViewController
 */

- (UIViewController *)controllerWithStoryboardName:(NSString *)storyboardName
                                     storyboardID:(NSString *)storyboardID;

/**
 @brief 统一的弹出框
 @param title 弹出框显示的内容
 */
-(void)alertWithTitle:(NSString *)title;

#pragma mark - 转换成拼音
-(NSString *)transformToPinyin:(NSString *)hanziText;

/**
 @brief 根据类型获取动作对应的类型小图标
 @param type 动作类型
 @return NSString   动作小图标
 */
-(NSString *)getActionTypeIconImageWithType:(NSString *)type;

/**
 @brief 根据index获取保存动作时候的动作类型
 @param idx index
 @return NSString   动作类型名称
 */
-(NSString *)getSelectActionTypeWithIndex:(NSInteger)idx;

+ (NSString *)getCurrentDeviceModel;
@end
