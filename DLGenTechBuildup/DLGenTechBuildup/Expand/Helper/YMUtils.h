//
//  YMUtils.h
//  Helper
//
//  Created by QinMingChuan on 14-3-10.
//  Copyright (c) 2014年 QinMingChuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMUtils : NSObject

#pragma mark - YMUtils 工具方法

+ (NSString *)YMDocumentDirectory; //documents目录
+ (NSString *)YMCacheDirectory;

//不安全的共享的数据缓冲，内存警告的时候会自动释放
+ (NSCache *)shareCache;

//返回一个guid
+ (NSString *)guid;

//创建目录
+ (BOOL)createDirectoryAtPath:(NSString *)path;

//将plist对象保存到磁盘
+ (BOOL)writePlist:(id)plist toFile:(NSString *)path;

//读取plist对象
+ (id)readPlistOfFile:(NSString *)path;

//判断当前设置是否是iPad
+ (BOOL)iPad;

//创建不在icloud备份的文件目录，如果文件存在则不创建
+ (BOOL)createUnBackupDirectory:(NSString *)path;

//获取设备号
+ (NSString *)deviceIdentifier;

//md5密码
+ (NSString *)MD5Encode:(const char *)lawsChar;

//计算文件的MD5
+ (NSString *)MD5FromFilePath:(NSString *)path;

//获取mac地址信息
+ (NSData *)macAddress;

//获取mac地址
+ (NSString *)macAddressString;

//des加密和解密
+ (NSData *)descrypto:(NSData *)data decrypt:(BOOL)decrypt  key:(const Byte *)key iv:(const Byte *)iv;

//base64加密
+ (NSString *)toBase64:(NSData *)data;

//base64编码
//+ (NSString *)toBase64:(const Byte *)bytes length:(NSInteger)length;

//base64解密
+ (NSData *)fromBase64:(NSString *)text;

//注意需要释放指针
//+ (NSData *)fromBase64:(const Byte *)bytes length:(NSInteger)length;

//将参数转换成字典
+ (NSMutableDictionary *)dictionaryWithQueryString:(NSString *)query;

@end

