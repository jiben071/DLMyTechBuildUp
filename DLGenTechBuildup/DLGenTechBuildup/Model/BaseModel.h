//
//  BaseModel.h
//  BYDFans
//
//  Created by QinMingChuan on 14-3-17.
//  Copyright (c) 2014年 Tentinet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BaseModel : NSObject
typedef enum{
    DVRequesting = 1,
    DVRequestFaile = 2,
    DVRequestSuccessed = 3
}ModelStatus;
@property (nonatomic) CGSize contSize;
@property (nonatomic,assign) ModelStatus modelStatus;
//从字典给属性赋值
- (void)setObjectAndKeysWithDict:(NSDictionary *)dict;

//根据dic给属性赋值
- (id)initWithDictionary:(NSDictionary *)dic;

@end
