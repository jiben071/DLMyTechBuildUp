//
//  YMBaseDataModel.h
//  Helper
//
//  Created by QinMingChuan on 14-3-17.
//  Copyright (c) 2014年 QinMingChuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMBaseDataModel : NSObject

//从字典给属性赋值
- (void)setObjectAndKeysWithDict:(NSMutableDictionary *)dict;

// 获取对象的所有属性
- (NSDictionary *)properties_aps;
// 获取对象的所有方法
-(NSArray *)printMothList;

@end
