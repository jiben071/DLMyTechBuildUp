//
//  UITableViewCell+MarkKeyword.h
//  StoryboardDemo
//
//  Created by chenlin on 15/6/24.
//  Copyright (c) 2015年 Ubtechinc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (MarkKeyword)

/**
 @brief 设置cell的搜索关键字标红
 @param text        要显示的文字
 @param searchKey   要标红的文字
 @return
 */
-(void)setText:(NSString *)text searchKey:(NSString *)searchKey;

@end
