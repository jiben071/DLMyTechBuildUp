//
//  NSObject+Utility.m
//  Alpha1S_NewInteractionDesign
//
//  Created by chenlin on 15/8/5.
//  Copyright (c) 2015年 Ubtechinc. All rights reserved.
//

#import "NSObject+Utility.h"
//#import "UBAlertView.h"
//#import "ActionStoreTypeListModel.h"
#import "sys/utsname.h"

#define IllegalCharacters       @"\\/:*?\"<>|"

@implementation NSObject (Utility)

+ (NSString *)replaceNilString:(NSString *)value
{
    if ((value == nil) || value == (NSString *)[NSNull null] || (value.length == 0))
    {
        value = @"";
    }
    return value;
}

#pragma mark deep copy
+ (id)deepMutableCopyWithJson:(id)json
{
    if (json == nil || [json isKindOfClass:[NSNull class]])
    {
        return [NSMutableString stringWithFormat:@""];
    }
    
    if ([json isKindOfClass:[NSString class]])
    {
        return [NSMutableString stringWithFormat:@"%@", json];
    }
    
    if ([json isKindOfClass:[NSNumber class]])
    {
        return json;
    }
    
    if ([json isKindOfClass:[NSArray class]])
    {
        NSMutableArray *array = [NSMutableArray array];
        for (id value in json)
        {
            [array addObject:[self deepMutableCopyWithJson:value]];
        }
        return array;
    }
    
    if ([json isKindOfClass:[NSDictionary class]])
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (NSString *key in json)
        {
            id value = [self deepMutableCopyWithJson:json[key]];
            [dict setObject:value forKey:key];
        }
        return dict;
    }
    
    return json;
}

#pragma mark - transform

+ (NSString *)toStringWithJsonValue:(id)value
{
    if (value == nil || value == [NSNull null])
    {
        return @"";
    }
    
    if ([value isKindOfClass:[NSString class]])
    {
        return value;
    }
    
    if ([value isKindOfClass:[NSNumber class]])
    {
        return  [value stringValue];
    }
    
    return @"";
}

+ (NSNumber *)toNSNumberWithJsonValue:(id)value
{
    if (value == nil || value == [NSNull null])
    {
        return [NSNumber numberWithInteger:0];
    }
    
    if ([value isKindOfClass:[NSString class]])
    {
        id result;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
        result=[formatter numberFromString:value];
        NSString *ex = [NSString stringWithFormat:@"参数属性设置错误！class = %@ value = %@",NSStringFromClass([value class]),value];
        NSAssert(result, ex);
        //        NSParameterAssert(result);
        if (result)
        {
            return result;
        }
    }
    
    if ([value isKindOfClass:[NSNumber class]])
    {
        return  value;
    }
    
    return [NSNumber numberWithInteger:0];
}

+ (NSInteger)toIntegerWithJsonValue:(id)value
{
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
    {
        return [value integerValue];
    }
    
    return 0;
}

+ (BOOL)toBoolWithJsonValue:(id)value
{
    if (value == nil || value == [NSNull null])
    {
        return NO;
    }
    
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value boolValue];
    }
    
    if ([value isKindOfClass:[NSString class]])
    {
        return [value boolValue];
    }
    
    return NO;
}

+ (int16_t)toInt16WithJsonValue:(id)value
{
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value shortValue];
    }
    
    if ([value isKindOfClass:[NSString class]])
    {
        return [value intValue];
    }
    
    return 0;
}

+ (int32_t)toInt32WithJsonValue:(id)value
{
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value intValue];
    }
    
    return 0;
}

+ (int64_t)toInt64WithJsonValue:(id)value
{
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value longLongValue];
    }
    
    return 0;
}

+ (short)toShortWithJsonValue:(id)value
{
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value shortValue];
    }
    
    if ([value isKindOfClass:[NSString class]])
    {
        return [value intValue];
    }
    
    return 0;
}

+ (float)toFloatWithJsonValue:(id)value
{
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value floatValue];
    }
    
    return 0;
}

+ (double)toDoubleWithJsonValue:(id)value
{
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value doubleValue];
    }
    
    return 0;
}

+ (id)toArrayWithJsonValue:(id)value
{
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    
    if ([value isKindOfClass:[NSArray class]])
    {
        return value;
    }
    
    return nil;
}

+ (id)toDictionaryWithJsonValue:(id)value
{
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    
    if ([value isKindOfClass:[NSDictionary class]])
    {
        return value;
    }
    
    return nil;
}

+ (BOOL)compareVersionWithCurrent:(NSString *)current server:(NSString *)server
{
    BOOL needUpgrade = NO;
    
    NSMutableArray *currents = [NSMutableArray arrayWithArray:[current componentsSeparatedByString:@"."]];
    NSMutableArray *servers = [NSMutableArray arrayWithArray:[server componentsSeparatedByString:@"."]];
    
    //将两个数组转化为相同长度
    NSInteger maxCount = MAX(currents.count, servers.count);
    for (int i = 0; i < maxCount - currents.count; i ++)
    {
        [currents addObject:@""];
    }
    
    for (int i = 0; i < maxCount - servers.count; i ++)
    {
        [servers addObject:@""];
    }
    
    for (int i = 0; i < maxCount; i ++)
    {
        NSInteger currentNumber = [currents[i] integerValue];
        NSInteger serverNumber = [servers[i] integerValue];
        
        if (currentNumber > serverNumber)
        {
            //当前版本新不需要更新
            needUpgrade = NO;
            break;
        }
        else if (currentNumber < serverNumber)
        {
            //服务器版本新，需要更新
            needUpgrade = YES;
            break;
        }
        else
        {
            continue;
        }
        
    }
    return needUpgrade;
}

#pragma mark - keyword处理
//将字典中的关键字处理
+ (NSDictionary *)dataHandleWithKey:(NSString *)keyWord dictionary:(NSDictionary *)dictionary
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:dictionary];
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        if ([obj isKindOfClass:[NSDictionary class]])
        {
            obj = [self dataHandleWithKey:keyWord dictionary:obj];
        }
        else if ([obj isKindOfClass:[NSArray class]])
        {
            obj = [self dataHandleWithKey:keyWord array:obj];
        }
        else
        {
            if ([keyWord isEqualToString:key])
            {
                [dic removeObjectForKey:key];
                
                NSString *newKey = [NSString stringWithFormat:@"resource%@",[keyWord capitalizedString]];
                
                [dic setObject:obj forKey:newKey];
            }
        }
        
    }];
    return dic;
}

-(NSArray *)dataHandleWithKey:(NSString *)keyWord array:(NSArray *)array
{
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:array];
    [tempArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj isKindOfClass:[NSDictionary class]])
        {
            obj = [NSObject dataHandleWithKey:keyWord dictionary:obj];
        }
        
    }];
    
    return tempArr;
}

#pragma mark -  获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] firstObject];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
    {
        result = nextResponder;
    }
    else
    {
        result = window.rootViewController;//此时result为WarningViewController
    }
    UINavigationController *navi = nil;
    if ([result.presentedViewController isKindOfClass:[UINavigationController class]])
    {
        navi = (UINavigationController *)result.presentedViewController;
    }
    UIViewController *des = [navi.viewControllers lastObject];
    return des;
}

+(BOOL)containsRenameIllegalCharacter:(NSString *)string
{
    if (!string || !string.length)
    {
        return NO;
    }
    
    for (int i = 0; i < string.length; i ++)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *item = [string substringWithRange:range];
        NSLog(@"item:%@",item);
        if ([IllegalCharacters rangeOfString:item].location != NSNotFound)
        {
            return YES;
        }
    }
    return NO;
    
}

#pragma mark - 讯飞识别
+(NSString *)stringFromIFlyVoiceJson:(NSString *)params
{
    if (params == NULL) {
        return nil;
    }
    
    NSMutableString *tempStr = [[NSMutableString alloc] init];
    NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:    //返回的格式必须为utf8的,否则发生未知错误
                                [params dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    if (resultDic!= nil) {
        NSArray *wordArray = [resultDic objectForKey:@"ws"];
        
        for (int i = 0; i < [wordArray count]; i++) {
            NSDictionary *wsDic = [wordArray objectAtIndex: i];
            NSArray *cwArray = [wsDic objectForKey:@"cw"];
            
            for (int j = 0; j < [cwArray count]; j++) {
                NSDictionary *wDic = [cwArray objectAtIndex:j];
                NSString *str = [wDic objectForKey:@"w"];
                [tempStr appendString: str];
            }
        }
    }
    return tempStr;
}

#pragma mark - storyboard
- (UIViewController *)controllerWithStoryboardName:(NSString *)storyboardName storyboardID:(NSString *)storyboardID
{
    if (!storyboardName.length || !storyboardID.length)
    {
        return nil;
    }
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    UIViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:storyboardID];
    return vc;
}

//-(void)alertWithTitle:(NSString *)title
//{
//    UBAlertView *alert = [[UBAlertView alloc]initWithTitle:title
//                                                     image:nil
//                                                   message:nil
//                                                  delegate:nil
//                                         cancelButtonTitle:@"好的"
//                                         otherButtonTitles:nil, nil];
//    [alert show];
//    
//}

#pragma mark - 转换成拼音
-(NSString *)transformToPinyin:(NSString *)hanziText
{
    NSMutableString *result = [NSMutableString string];
    
    for (int i = 0; i < hanziText.length; i ++)
    {
        unichar ch = [hanziText characterAtIndex:i];
        NSString *item = [NSString stringWithCharacters:&ch length:1];
        
        NSString *pinyin = [self toPinyin:item];
        
        [result appendString:pinyin];
    }
    
    return result;
}

- (NSString *)toPinyin:(NSString *)hanziText
{
    NSMutableString *mutableString = [NSMutableString stringWithString:hanziText];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return mutableString;
}

-(NSString *)getActionTypeIconImageWithType:(NSString *)type
{
    NSString *imageName = @"";
    
//    switch (type.integerValue)
//    {
//        case ActionStoreRequestTypeBasicAction:
//            
//            imageName = @"type_basic_action";
//            
//            break;
//            
//        case ActionStoreRequestTypeDance:
//            
//            imageName = @"type_dance";
//            
//            break;
//            
//        case ActionStoreRequestTypeStory:
//            
//            imageName = @"type_story";
//            
//            break;
//            
//        default:
//            break;
//    }
    
    return imageName;
}

-(NSString *)getSelectActionTypeWithIndex:(NSInteger)idx
{
    NSString *str = @"";
    
    switch (idx)
    {
        case 0:
            
            str = @"基本动作";
            
            break;
            
        case 1:
            
            str = @"寓言故事";
            
            break;
            
        case 2:
            
            str = @"音乐舞蹈";
            
            break;
            
        default:
            break;
    }
    
    return str;
}

- (NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}

+ (NSString *)getCurrentDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

@end
