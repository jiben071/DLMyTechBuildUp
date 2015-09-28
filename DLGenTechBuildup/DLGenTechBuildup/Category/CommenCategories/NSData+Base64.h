//
//  NSData+Base64.h
//  Alpha1S_NewInteractionDesign
//
//  Created by chenlin on 15/9/17.
//  Copyright (c) 2015年 Ubtechinc. All rights reserved.
//

#import <Foundation/Foundation.h>

void *NewBase64Decode(
                      const char *inputBuffer,
                      size_t length,
                      size_t *outputLength);

char *NewBase64Encode(
                      const void *inputBuffer,
                      size_t length,
                      bool separateLines,
                      size_t *outputLength);

@interface NSData (Base64)

+ (NSData *)dataFromBase64String:(NSString *)aString;
- (NSString *)base64EncodedString;

@end
