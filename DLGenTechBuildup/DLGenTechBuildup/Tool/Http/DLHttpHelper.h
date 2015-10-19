//
//  DLHttpHelper.h
//  DLGenTechBuildup
//
//  Created by denglong on 15/10/19.
//  Copyright © 2015年 denglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLReachability.h"

@interface DLHttpHelper : NSObject
+ (BOOL)NetWorkIsOK;//检查网络是否可用
+ (void)post:(NSString *)Url RequestParams:(NSDictionary *)params FinishBlock:(void (^)(NSData *data, NSURLResponse *response,NSError *connectionError)) block;//post请求封装
@end
