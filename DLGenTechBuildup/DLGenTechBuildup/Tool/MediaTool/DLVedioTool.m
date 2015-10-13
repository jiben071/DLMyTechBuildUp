//
//  DLVedioTool.m
//  DLGenTechBuildup
//
//  Created by denglong on 15/10/13.
//  Copyright © 2015年 denglong. All rights reserved.
//

#import "DLVedioTool.h"
#import <AVFoundation/AVFoundation.h>

@implementation DLVedioTool
/**
 *  截取指定时间的视频缩略图
 *
 *  @param timeBySecond 时间点
 */
+(UIImage *)thumbnailImageRequest:(CGFloat )timeBySecond url:(NSURL *)url{
    //根据url创建AVURLAsset
    AVURLAsset *urlAsset=[AVURLAsset assetWithURL:url];
    //根据AVURLAsset创建AVAssetImageGenerator
    AVAssetImageGenerator *imageGenerator=[AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    NSError *error=nil;
    //CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
    /*截图
     * requestTime:缩略图创建时间
     * actualTime:缩略图实际生成的时间
     */
    CMTime time=CMTimeMakeWithSeconds(timeBySecond, 10);
    CMTime actualTime;
    CGImageRef cgImage= [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    if(error){
        NSLog(@"截取视频缩略图时发生错误，错误信息：%@",error.localizedDescription);
        return nil;
    }
    CMTimeShow(actualTime);
    UIImage *image=[UIImage imageWithCGImage:cgImage];//转化为UIImage
    return image;
}
@end
