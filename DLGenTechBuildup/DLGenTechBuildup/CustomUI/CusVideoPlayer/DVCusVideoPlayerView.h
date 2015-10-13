//
//  DVCusVideoPlayerView.h
//  Diver
//
//  Created by denglong on 15/6/16.
//  Copyright (c) 2015年 Tentinet. All rights reserved.
//  注意：没有实用价值，只用参考价值

#import <UIKit/UIKit.h>

/**
 *  视频播放器(系统方法)
 */
typedef void(^DVVideoPlayerFinishedBlock)();
typedef void(^DVVideoPlayerPlayingBlock)(NSTimeInterval currentPlayingTime);
@interface DVCusVideoPlayerView : UIView

@property (nonatomic,strong) NSString *playUrlStr;
/**
 *  获取视频截图
 */
+(UIImage *)thumbnailImageRequest:(CGFloat )timeBySecond url:(NSURL *)url;

- (void)stop;

/** 临时视频*/
@property (nonatomic,  assign) BOOL isTmpVideo;

@property (nonatomic, getter=isFullscreen) BOOL fullscreen;
@property (nonatomic,copy) DVVideoPlayerFinishedBlock videoPlayFinishedBlock;
@property (nonatomic,copy) DVVideoPlayerPlayingBlock videoPlayPlayingBlock;

#pragma mark - 设置视频截图
@property (nonatomic,strong) NSString *thumbnailImgUrlStr;
@property (nonatomic,strong) UIImage *thumbnailImage;

#pragma mark - 设置开始或结束播放时间
@property (nonatomic) NSTimeInterval initialPlaybackTime;
@property (nonatomic) NSTimeInterval endPlaybackTime;

- (void)play;
- (void)pause;
- (void)prepareToPlay;//准备播放
@end
