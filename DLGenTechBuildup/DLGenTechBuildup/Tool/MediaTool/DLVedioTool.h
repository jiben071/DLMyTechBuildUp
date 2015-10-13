//
//  DLVedioTool.h
//  DLGenTechBuildup
//
//  Created by denglong on 15/10/13.
//  Copyright © 2015年 denglong. All rights reserved.
//

#import <UIKit/UIKit.h>
/*!
 *  @author denglong, 15-10-13 19:10:16
 *
 *  @brief  视频工具类
 */
@interface DLVedioTool : NSObject
/*!
 *  @author denglong, 15-10-13 19:10:03
 *
 *  @brief  视频截图
 *
 *  @param timeBySecond 截图时间点
 *  @param url          视频地址
 *
 *  @return 截图
 */
+(UIImage *)thumbnailImageRequest:(CGFloat )timeBySecond url:(NSURL *)url;
@end
