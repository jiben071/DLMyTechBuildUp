//
//  NSString+Helpers.h

//
//  Created by Reejo Samuel on 8/2/13.
//  Copyright (c) 2013 Reejo Samuel | m[at]reejosamuel.com All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Helpers)

-(NSString *)MD5;
-(NSString *)sha1;
-(NSString *)reverse;
-(NSString *)URLEncode;
-(NSString *)URLDecode;
-(NSString *)stringByStrippingWhitespace;
-(NSString *)substringFrom:(NSInteger)from to:(NSInteger)to;
-(NSString *)CapitalizeFirst:(NSString *)source;
-(NSString *)UnderscoresToCamelCase:(NSString*)underscores;
-(NSString *)CamelCaseToUnderscores:(NSString *)input;

-(NSUInteger)countWords;


-(BOOL)contains:(NSString *)string;
-(BOOL)isBlank;
- (NSString *)trim;

//把字符串解析成json对象
- (id)jsonObject;

//删除指定的字符，b表示是否删除空格
- (NSString *)filterString:(NSString *)str filterWhiteSpace:(BOOL)b;

@end
