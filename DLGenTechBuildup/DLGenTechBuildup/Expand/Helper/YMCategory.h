//
//  YMCategory.h
//  Helper
//
//  Created by QinMingChuan on 14-3-10.
//  Copyright (c) 2014年 QinMingChuan. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark － ==========非UI扩展==========

#pragma mark - NSObject 扩展

@interface NSObject (YM)

//添加观察者
- (void)addObserverSelector:(SEL)selector name:(NSString *)name object:(id)object;

//取消观察者
- (void)removeObserverName:(NSString *)name object:(id)object;

//取消定时方法
- (void)cancelPreviousPerformRequestsWithSelector:(SEL)selector object:(id)object;

//获取对象的hash值的字符串
- (NSString *)hashString;

@end

@interface NSString(YM)

- (NSString *)encodeURI; //地址编码

//相对应该根目录的绝对路径a
- (NSString *)absolutePath;

//指定日期格式，将字符串转为日期
- (NSDate *)dateWithDateFormat:(NSString *)dateFormat;

//使用默认格式，将字符串转为日期
- (NSDate *)date;

//是否正则匹配
- (BOOL)isRegularMatch:(NSString *)regularString;

//清空两边的空白字符
- (NSString *)trim;

@end

#pragma mark - NSData 扩展

@interface NSData(YM)
- (id)JSONOObject;  //执行json解析
@end

#pragma mark - NSDate 扩展

@interface NSDate (YM)

// 将日期按钮格式的字符串输出
- (NSString *)stringWithDateFormat:(NSString *)dateFormat;

// 将日期格式成短字符串
- (NSString *)formatShortDate;

//今天凌晨0点
+ (NSDate *)todayZeroHour;

//调整时区的差值
+ (NSInteger)timeLocationDifference;  //调整时区的差值

@end



#pragma mark - 扩展 NSFileManager

@interface NSFileManager (YM)

- (long long)sizeOfFolderPath:(const char*)path;

//获取目录下的文件且按访问时间排序
- (NSArray *)filesAtPath:(NSString *)path;
@end


#pragma mark - 扩展 NSDictionary

@interface NSDictionary (YM)

//获取文件满路径
- (NSString *)fileName;

//获取文件最后访问时间
- (NSDate *)fileAccessTime;

@end



#pragma mark - 扩展NSArray

@interface NSArray (YM)

@end

#pragma mark - ===========UI相关的扩展==========

#pragma mark - UIColor 扩展

@interface UIColor (YM)

// 将指定的整数转为颜色值
+ (UIColor *)colorWithUInt:(NSUInteger)rgb;

// 指定整数和颜色的透明度
+ (UIColor *)colorWithUInt:(NSUInteger)rgb alpha:(CGFloat)alpha;

// 由指定的文件名图片转为颜色值
+ (UIColor *)colorWithResource:(NSString *)name;

//获取颜色模式
- (CGColorSpaceModel)colorSpaceModel;

@end


#pragma mark - UIImage 扩展

@interface UIImage (YM)
// 无缓存的加载图片
+ (UIImage *)imageWithResource:(NSString *)name;

// 将颜色转为图片
+ (UIImage *)imageWithColor:(UIColor *)color;

// 将颜色转换为图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

//计算图片等比压缩比例
- (CGSize)geometricSize:(CGSize)maxSize;

//改变图片的尺寸
- (UIImage *)imageResize:(CGSize)size;

//改变图片的颜色
- (UIImage *)changeColor:(UIColor *)color;

//改变图片的透明度
- (UIImage *)imageWithAlphaComponent:(CGFloat)alpha;

//改变圆角
- (UIImage *)changeToRadius:(CGFloat)redius;  //改变圆角

@end

#pragma mark - UIView扩展

@interface UIView(YM)

//设置外边框
- (void)outerBorderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;

//设置视图内边框
- (void)innerBorderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;

//在视图上执行CATransition动画
- (void)transitionType:(NSString *)type subtype:(NSString *)subtype delegate:(id)delegate;

- (void)transitionType:(NSString *)type subtype:(NSString *)subtype;

//视图回弹效果
- (void)reboundEffect;

- (void)reboundEffectAnimationDuration:(CGFloat)duration;

- (void)animationToBigType:(NSUInteger)inType; //动画回弹
@end


#pragma mark - UIImageView扩展

@interface UIImageView (YM)

//加载网络图片
- (void)setImageWithURLString:(NSString *)urlString;

//加载网络图片，将指定初始图
- (void)setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeImage;

//加载图片后处理为圆图缓存下来
- (void)setRoundImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeImage;

//下载好图片后可以处理后再缓存到本地
- (void)setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeImage transDataBlock:(NSData *(^)(NSData *data))transDataBlock;

@end
#pragma mark - 扩展UIBarButtonItem

@interface UIBarButtonItem (YM)
//初始化为不加边框的按钮
- (id)initWithCustomViewImage:(UIImage *)image customViewTitle:(NSString *)title;

//静态初始化
+ (id)barButtonItemWithCustomViewImage:(UIImage *)image customViewTitle:(NSString *)title;
@end