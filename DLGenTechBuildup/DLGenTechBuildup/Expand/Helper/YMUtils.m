//
//  YMUtils.m
//  Helper
//
//  Created by QinMingChuan on 14-3-10.
//  Copyright (c) 2014年 QinMingChuan. All rights reserved.
//

#import "YMUtils.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <sys/xattr.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>

@implementation YMUtils

+ (NSCache *)shareCache
{
    static NSCache * globalCache;
    if(!globalCache)
    {
        globalCache = [[NSCache alloc] init];
    }
    
    return globalCache;
}

+ (NSString *)YMDocumentDirectory //documents目录
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
}

+ (NSString *)YMCacheDirectory //cache目录
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
}

//guid
+ (NSString *)guid
{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef uuidStr = CFUUIDCreateString(kCFAllocatorDefault, uuid);
    NSString *string = [(__bridge NSString *)uuidStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    CFRelease(uuid);
    CFRelease(uuidStr);
    
    return string;
}

//创建目录
+ (BOOL)createDirectoryAtPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    
    if(![fileManager fileExistsAtPath:path]){
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    return error == nil;
}

//将plist对象保存到磁盘中
+ (BOOL)writePlist:(id)plist toFile:(NSString *)path{
    NSString *error;
    
    NSData *data = [NSPropertyListSerialization dataFromPropertyList:plist
                                                              format:NSPropertyListBinaryFormat_v1_0
                                                    errorDescription:&error];
    
    return !data ? NO : [data writeToFile:path atomically:YES];
}

//读取plist
+ (id)readPlistOfFile:(NSString *)path{
    NSString *error;
    NSPropertyListFormat format;
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    if(!data){
        return nil;
    }
    
    id plist = [NSPropertyListSerialization propertyListFromData:data
                                                mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                          format:&format
                                                errorDescription:&error];
    
    return plist;
}

//判断当前设备是否是iPad
//+ (BOOL)iPad{
//    //默认是0（需要选择赋值），1表示使用iPad,2表示高清ipad,3表示使用其他设备
//    static char _iPad = 0;
//    
//    if(_iPad == 0){
//        if([[UIDevice currentDevice].model hasPrefix:@"iPad"]){
//            //ipad高清屏的屏幕大小为2048 * 1536，注意iphone可能出4.0寸，判断size将显得不合理
//            _iPad = [[UIScreen mainScreen]currentMode].size.width >= 2048 ? 2 : 1;
//        }
//        else{
//            _iPad = 3;
//        }
//    }
//    
//    return _iPad == 1;
//}

//创建不在icloud备份的文件目录
+ (BOOL)createUnBackupDirectory:(NSString *)path{
    //返回结果
    BOOL result = YES;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //判断是否存在文件
    if(![fileManager fileExistsAtPath:path]){
        NSError *error = nil;
        
        //创建文件
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        
        result = error != nil;
        
        u_int8_t b = 1;
        
        setxattr(path.fileSystemRepresentation, "com.apple.MobileBackup", &b, 1, 0, 0);
    }
    
    return result;
}


//获取mac地址
+ (NSData *)macAddress{
    size_t              len;
    char                *buf;
    const Byte          *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    int mib[6] = { CTL_NET , AF_ROUTE, 0, AF_LINK, NET_RT_IFLIST};
    
    //获取wifi地址
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        return nil;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        return nil;
    }
    
    if ((buf = malloc(len)) == NULL) {
        return nil;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
        return nil;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (const Byte *)LLADDR(sdl);
    
    free(buf);
    
    NSData *data = [NSData dataWithBytes:ptr length:6];
    
    //如果获取结果都是0，则获取失败
    if(strcmp((const char *)data.bytes, "000000") == 0){
        data = nil;
    }
    
    return data;
}

//获取mac地址
+ (NSString *)macAddressString{
    NSData *data = [self macAddress];
    
    NSString *result = nil;
    
    //mac地址
    if(data){
        const char *bytes = data.bytes;
        result = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x",bytes[0],bytes[1],bytes[2],bytes[3],bytes[4],bytes[5]];
    }
    
    return result;
}

//获取设备号
+ (NSString *)deviceIdentifier{
    
    NSString *macAddress = [self macAddressString];
    
    return macAddress ? [self MD5Encode:macAddress.UTF8String] : nil;
}

//md5加载
+ (NSString *)MD5Encode:(const char *)lawsChar{
    unsigned char result[16];
    
    CC_MD5( lawsChar, (CC_LONG)strlen(lawsChar), result);
    
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
}

//计算文件的MD5
+ (NSString *)MD5FromFilePath:(NSString *)path
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if( handle== nil ) {
        return nil;
    }
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while(!done)
    {
        NSData* fileData = [handle readDataOfLength: 256 ];
        CC_MD5_Update(&md5, [fileData bytes], [fileData length]);
        if( [fileData length] == 0 ) done = YES;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    
    return s;
}

//des加密和解密
+ (NSData *)descrypto:(NSData *)data decrypt:(BOOL)decrypt  key:(const Byte *)key iv:(const Byte *)iv{
    if(data == nil){
        return nil;
    }
    
    CCOperation op = decrypt ? kCCDecrypt :  kCCEncrypt;
    
    //密文长度
    size_t size = data.length + kCCKeySize3DES;
    
    Byte *buffer = (Byte *)malloc(size * sizeof(Byte));
    
    //结果的长度
    size_t numBytes = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(
                                          op,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          key,
                                          kCCKeySizeDES,
                                          iv,
                                          data.bytes,
                                          data.length,
                                          buffer,
                                          size,
                                          &numBytes
                                          );
    
    
    NSData *result = nil;
    
    if(cryptStatus == kCCSuccess){
        result = [NSData dataWithBytes:buffer length:numBytes];
    }
    
    //释放指针
    free(buffer);
    
    return result;
}

//base64编码
+ (NSString *)toBase64:(NSData *)data{
    const Byte *bytes = data.bytes;
    
    NSUInteger length = data.length;
    
    if(data.length == 0){
        return nil;
    }
    
    //加密串
    const char *keys =  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    //结果
    char *result = (char *)malloc(((length + 2) / 3 * 4 + 1) * sizeof(char));
    
    NSInteger i =  0;
    NSInteger n =  0;
    short     k =  2;
    char   byte =  0;
    
    while (i < length) {
        result[ n ++ ] = keys[ byte | (bytes[i] >> k)];
        byte =  0x3f & (bytes[i] << (6 - k));
        
        if(k == 6){
            result[n++] = keys[byte];
            k = 2;
            byte = 0;
        }
        else{
            k += 2;
        }
        
        i++;
    }
    
    if(k != 2){
        result[n++] = keys[byte];
        result[n++] = '=';
        if(k == 4){
            result[n++] = '=';
        }
    }
    
    //字符串结尾
    result[n] = 0;
    
    NSString *string = [NSString stringWithUTF8String:result];
    
    free(result);
    
    return string;
}

//base64解码
+ (NSData *)fromBase64:(NSString *)text{
    
    const Byte *bytes = (const Byte*)text.UTF8String;
    NSUInteger length = [text lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    //是否存在文本
    if(length % 4 != 0){
        return nil;
    }
    
    //解密码键
    const char keys[] = {
        -1, -1, -1, -1, -1, -1, -1, -1,
        -1, -1, -1, -1, -1, -1, -1, -1,
        -1, -1, -1, -1, -1, -1, -1, -1,
        -1, -1, -1, -1, -1, -1, -1, -1,
        -1, -1, -1, -1, -1, -1, -1, -1,
        -1, -1, -1, 62, -1, -1, -1, 63,
        52, 53, 54, 55, 56, 57, 58, 59,
        60, 61, -1, -1, -1, -1, -1, -1,
        -1,  0,  1,  2,  3,  4,  5,  6,
        7,  8,  9, 10, 11, 12, 13, 14,
        15, 16, 17, 18, 19, 20, 21, 22,
        23, 24, 25, -1, -1, -1, -1, -1,
        -1, 26, 27, 28, 29, 30, 31, 32,
        33, 34, 35, 36, 37, 38, 39, 40,
        41, 42, 43, 44, 45, 46, 47, 48,
        49, 50, 51, -1, -1, -1, -1, -1
    };
    
    //结果
    char *result = (char *)malloc(((length / 4) * 3) * sizeof(char));
    
    NSInteger m = 0;
    
    //判断结尾是否是等于号
    while (bytes[length - 1] == '=') {
        length --;
        
        //解析错误
        if(m ++ == 2){
            free(result);
            return nil;
        }
    }
    
    char   byte = 0;
    short index = 0;
    NSInteger n = 0;
    NSInteger i = 0;
    NSInteger k = 8;
    
    while (i < length) {
        //读取对应的字符
        index = bytes[i];
        char c = keys[index];
        //解析到非法字符
        if(c == -1){
            free(result);
            return  nil;
        }
        if(k == 8){
            byte = c << 2;
            k = 2;
        }
        else{
            result[n++] = byte | (c >> (6 - k));
            k += 2;
            byte = c << k;
        }
        
        i++;
    }
    
    NSData *data = [NSData dataWithBytes:result length:n];
    free(result);
    return data;
}

//参数转换成字典
+ (NSMutableDictionary *)dictionaryWithQueryString:(NSString *)query{
    NSMutableDictionary *dict = nil;
    
    @autoreleasepool {
        //判断参数列表是否存在
        if(query.length == 0){
            return nil;
        }
        
        //分解字符串
        NSArray *queryArray = [query componentsSeparatedByString:@"&"];
        
        if(queryArray.count > 0){
            dict  = [NSMutableDictionary dictionaryWithCapacity:queryArray.count];
            
            for (NSString *item in queryArray) {
                NSRange range = [item rangeOfString:@"="];
                
                if(range.length == 1){
                    if(range.location == 0){
                        continue;
                    }
                    if(range.location == item.length - 1){
                        dict[item] = @"";
                    }
                    else{
                        dict[[item substringToIndex:range.location]] = [item substringFromIndex:range.location + 1];
                    }
                }
                else{
                    dict[item] = @"";
                }
            }
        }
    }
    
    return dict;
}
@end

