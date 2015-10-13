//
//  DVCusVideoPlayerView.m
//  Diver
//
//  Created by denglong on 15/6/16.
//  Copyright (c) 2015年 Tentinet. All rights reserved.
//

#import "DVCusVideoPlayerView.h"
#import <MediaPlayer/MediaPlayer.h>
//#import "DVHttpMethod.h"
//#import "NSFileManager+DragonCategory.h"
#import <AVFoundation/AVFoundation.h>

#define kPlayerRealTimeNotification @"kPlayerRealTimeNotification"
@interface DVCusVideoPlayerView()
@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;//视频播放控制器
@property (nonatomic,strong) NSURL *playUrl;

@property (nonatomic,weak) UIButton *playBtn;
@property (nonatomic,weak) UIImageView *screenshotImgView;
@property (nonatomic,weak) UIView *coverView;
@property (nonatomic,weak) UIProgressView *playProgressView;

@property (nonatomic,assign) BOOL isAddObserver;//标记是否添加了KVO
@property (nonatomic,strong) NSTimer *timer;//定时器，实时控制进度条进度
@property (nonatomic,assign) BOOL isHandTap;//标记是否是手动控制暂停与播放

@end

@implementation DVCusVideoPlayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [playBtn setImage:[UIImage imageNamed:@"cusVideoPlayer_icon"] forState:UIControlStateNormal];
        [playBtn addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
        self.playBtn = playBtn;
        
        UIImageView *screenshotImgView = [[UIImageView alloc] init];
        screenshotImgView.backgroundColor = [UIColor blackColor];
        screenshotImgView.contentMode = UIViewContentModeScaleAspectFit;
        screenshotImgView.clipsToBounds = YES;
        self.screenshotImgView = screenshotImgView;
        
        UIView *coverView = [[UIView alloc] init];
        self.coverView = coverView;
        self.coverView.hidden = YES;
        [self addCoverGesture];
        
        
        UIProgressView *playProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        self.playProgressView = playProgressView;
        self.playProgressView.hidden = YES;
        
        [self addSubview:screenshotImgView];
        [self addSubview:playBtn];
        [self addSubview:coverView];
        [self addSubview:playProgressView];
    }
    return self;
}

- (void)addCoverGesture{
    UITapGestureRecognizer *singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playOrPause:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.coverView addGestureRecognizer:singleRecognizer];
    

    // 双击的 Recognizer
    UITapGestureRecognizer *doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOrScale:)];
    doubleRecognizer.numberOfTapsRequired = 2; // 双击
    [singleRecognizer requireGestureRecognizerToFail:doubleRecognizer];//关键在这一行，双击手势确定监测失败才会触发单击手势的相应操作
    [self.coverView addGestureRecognizer:doubleRecognizer];
}

- (void)initSetting{
    //添加通知
    [self addNotification];
}

/**
 *  添加通知监控媒体播放控制器状态
 */
-(void)addNotification{
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerPlaybackPlaying:) name:MPMoviePlayerNowPlayingMovieDidChangeNotification object:self.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(recoverOriginPlayView) name:MPMoviePlayerDidExitFullscreenNotification object:self.moviePlayer];
    [notificationCenter addObserver:self selector:@selector(mediaPlayerLoadStateChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:self.moviePlayer];
}

/**
 *  播放状态改变，注意播放完成时的状态是暂停
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackStateChange:(NSNotification *)notification{
    switch (self.moviePlayer.playbackState) {
        case MPMoviePlaybackStatePlaying:{
            self.playBtn.hidden = YES;
            [self removeRealTimeObserver];
            [self addRealTimeObserver];
//            if (self.moviePlayer.currentPlaybackTime > 0.25) {
                [self stopProgress];
//            }
            NSLog(@"正在播放...");
            self.isHandTap = NO;
            break;
        }
        case MPMoviePlaybackStatePaused:{
            [self removeRealTimeObserver];
            NSLog(@"暂停播放.");
            
            if (self.isHandTap) {//如果是手动暂停
                [self stopProgress];
                [self showPlayBtn];
            }else{
//                //显示提示信息
//                if ((self.moviePlayer.duration - self.moviePlayer.currentPlaybackTime) < 0.1) {
//                    [self stopProgress];
//                }else{
//                    [self startProgress:[CommenMethod localizationString:@"VIDEO_PLAY_Buffering"]];
//                }
            }
            self.isHandTap = NO;
            
            break;
        }
        case MPMoviePlaybackStateStopped:{
            [self removeRealTimeObserver];
            NSLog(@"停止播放.");
            [self showPlayBtn];
            [self stopProgress];
            self.isHandTap = NO;
            break;
        }
        default:
            [self removeRealTimeObserver];
            NSLog(@"播放状态:%li",(long)self.moviePlayer.playbackState);
            break;
    }
}

- (void)mediaPlayerLoadStateChange:(NSNotification *)noti{
    switch (self.moviePlayer.loadState) {
        case MPMovieLoadStateUnknown:{
//            DLog(@"无法播放");
            break;
        }
            
        case MPMovieLoadStatePlayable:{
//            DLog(@"可以播放了");
//            [self stopProgress];
            break;
        }
            
        case MPMovieLoadStatePlaythroughOK:{
//            DLog(@"播放中，网络OK");
//            [self stopProgress];
            break;
        }
            
        case MPMovieLoadStateStalled:{
//            DLog(@"网络不好，自动停止");
            [self stopProgress];
//            [self showErrorMessage:[CommenMethod localizationString:@"VideoLoadingFails"]];
            break;
        }
            
        default:
            break;
    }
}

- (void)stopProgress{
//    [SVProgressHUD dismiss];
//    [MBProgressHUD hideHUDForView:self animated:YES];
    
}

- (void)startProgress{
//    [SVProgressHUD show];
    
//    [MBProgressHUD showHUDAddedTo:self animated:NO];
}

- (void)startProgress:(NSString *)message{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:NO];
//    hud.labelText = message;
}

- (void)showErrorMessage:(NSString *)message{
//    [SVProgressHUD showErrorWithStatus:message];
}

- (void)addRealTimeObserver{
    if (!_timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(catchPlayerRealTime) userInfo:nil repeats:YES];
    }
}

- (void)removeRealTimeObserver{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"currentPlaybackTime"]){
        [self catchPlayerRealTime];
    }
}

- (void)catchPlayerRealTime{
    self.playProgressView.progress = self.moviePlayer.currentPlaybackTime / self.moviePlayer.duration;
    if (self.videoPlayPlayingBlock) {
        self.videoPlayPlayingBlock(self.moviePlayer.currentPlaybackTime);
    }
}

- (void)showPlayBtn{
    self.playBtn.hidden = NO;
    [self bringSubviewToFront:self.playBtn];
}

/**
 *  播放完成
 *
 *  @param notification 通知对象
 */
-(void)mediaPlayerPlaybackFinished:(NSNotification *)notification{
    NSLog(@"播放完成.%li",(long)self.moviePlayer.playbackState);
    self.playProgressView.progress = 1.0;
    if (self.videoPlayFinishedBlock) {
        self.videoPlayFinishedBlock();
    }
    [self showPlayBtn];
//    [self stopProgress];
    self.isHandTap = NO;
}

/**
 *  切换视频
 */
-(void)mediaPlayerPlaybackPlaying:(NSNotification *)notification{
}


- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat playW = 100;
    CGFloat playH = 100;
    CGFloat playX = (self.bounds.size.width - playW) * 0.5;
    CGFloat playY = (self.bounds.size.height - playH) * 0.5;
    self.playBtn.frame = CGRectMake(playX, playY, playW, playH);
    self.coverView.frame = self.bounds;
    
    self.screenshotImgView.frame = self.bounds;
    
    
    CGFloat progressX = 0;
    CGFloat progressH = 2;
    CGFloat progressY = self.bounds.size.height - progressH;
    CGFloat progressW = self.bounds.size.width;
    self.playProgressView.frame = CGRectMake(progressX, progressY, progressW, progressH);
}

#pragma mark - 私有方法
- (void)setPlayUrlStr:(NSString *)playUrlStr{
    _playUrlStr = playUrlStr;
    _playUrlStr = [_playUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _playUrl = [NSURL URLWithString:_playUrlStr];
}

/**
 *  创建媒体播放控制器
 *
 *  @return 媒体播放控制器
 */
-(MPMoviePlayerController *)moviePlayer{
    if (!_moviePlayer) {
        _moviePlayer = [[MPMoviePlayerController alloc]init];
        _moviePlayer.view.frame = self.bounds;
        _moviePlayer.view.clipsToBounds = YES;
        _moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
        _moviePlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self settingStartEndTime];
        _moviePlayer.controlStyle = MPMovieControlStyleNone;
        [_moviePlayer setFullscreen:NO];
        if (!self.isTmpVideo) {
//            NSString *videoName = [[self.playUrlStr componentsSeparatedByString:@"/"] lastObject];
//            NSString *moviePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"]
//                                   stringByAppendingString:[NSString stringWithFormat:@"/%@",videoName]];
//            if ([NSFileManager hasFileByFilePath:moviePath]) {
//                _moviePlayer.contentURL = kURLFile(moviePath);
//                [self playVideo:nil];
//            }
        }else{
            _moviePlayer.contentURL = self.playUrl;
        }
        [self insertSubview:_moviePlayer.view belowSubview:self.screenshotImgView];
        
        [self initSetting];//添加通知
    }
    return _moviePlayer;
}



- (void)playVideo:(UIButton *)btn{
    
//    if (!self.isTmpVideo) {
//        NSString *videoName = [[self.playUrlStr componentsSeparatedByString:@"/"] lastObject];
//        NSString *moviePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"]
//                               stringByAppendingString:[NSString stringWithFormat:@"/%@",videoName]];
//        if (![NSFileManager hasFileByFilePath:moviePath]) {
//            [self disposeDownloadVideoFile:moviePath];
//            return;
//        }else{
//            self.isHandTap = btn?YES:NO;
//            if (!self.isHandTap) {
////                _moviePlayer.contentURL = kURLFile(moviePath);
//            }
//            
//            self.playBtn.hidden = YES;
//            self.screenshotImgView.hidden = YES;
//            self.coverView.hidden = NO;
//            self.playProgressView.hidden = NO;
//            [self.moviePlayer play];
////            DLog(@"准备播放");
//            [self bringToFront];
//        }
//    }else{
//        self.isHandTap = btn?YES:NO;
//        self.playBtn.hidden = YES;
//        self.screenshotImgView.hidden = YES;
//        self.coverView.hidden = NO;
//        self.playProgressView.hidden = NO;
//        [self.moviePlayer play];
//        DLog(@"准备播放");
//        [self bringToFront];
//    }
    
}

- (void)bringToFront{
    [self bringSubviewToFront:self.coverView];
    [self bringSubviewToFront:self.playProgressView];
}

-(void)dealloc{
    NSLog(@"播放器销毁");
    //移除所有通知监控
    [self cancelPlayDealing];
}

- (void)cancelPlayDealing{
    self.playBtn.hidden = NO;
    self.screenshotImgView.hidden = NO;
    self.coverView.hidden = YES;
    self.playProgressView.hidden = YES;
    [self.moviePlayer stop];
    [self.moviePlayer.view removeFromSuperview];
    self.moviePlayer = nil;
    [self removeRealTimeObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)stop{
    [self cancelPlayDealing];
}

- (BOOL)isFullscreen{
    return self.moviePlayer.isFullscreen;
}

- (void)setThumbnailImage:(UIImage *)thumbnailImage{
    _thumbnailImage = thumbnailImage;
    self.screenshotImgView.image = thumbnailImage;
}


- (void)setThumbnailImgUrlStr:(NSString *)thumbnailImgUrlStr{
    _thumbnailImgUrlStr = thumbnailImgUrlStr;
//    [self.screenshotImgView setImageWithURL:[BYDUrlFactory getImageUrlByPath:thumbnailImgUrlStr] placeholderImage:[GlobalCommen getPlaceHolderGrayImage] options:SDWebImageRetryFailed];
}

- (void)setInitialPlaybackTime:(NSTimeInterval)initialPlaybackTime{
    _initialPlaybackTime = initialPlaybackTime;
    [self settingStartEndTime];
}

- (void)setEndPlaybackTime:(NSTimeInterval)endPlaybackTime{
    _endPlaybackTime = endPlaybackTime;
    [self settingStartEndTime];
}

- (void)settingStartEndTime{
    if (_moviePlayer && _initialPlaybackTime) {
        _moviePlayer.initialPlaybackTime = self.initialPlaybackTime;
    }
    if (_moviePlayer && _endPlaybackTime) {
        _moviePlayer.endPlaybackTime = self.endPlaybackTime;
    }
}

/**
 *  手势控制播放或暂停
 */
- (void)playOrPause:(UIGestureRecognizer *)guesture{
    self.isHandTap = guesture ? YES : NO;
    self.playBtn.hidden = !self.playBtn.hidden;
    self.coverView.hidden = !self.playBtn.hidden;
    if (self.playBtn.hidden) {
    }else{
        if (_moviePlayer) {
            [_moviePlayer pause];
        }
    }
}


- (void)recoverOriginPlayView{
    _moviePlayer.controlStyle = MPMovieControlStyleNone;
    _moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    [_moviePlayer setFullscreen:NO animated:YES];
}


- (void)zoomOrScale:(UIGestureRecognizer *)guesture{
    if ([_moviePlayer isFullscreen]) {
        [self recoverOriginPlayView];
    }else{
        _moviePlayer.view.userInteractionEnabled = NO;
        _moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
        _moviePlayer.scalingMode = MPMovieScalingModeNone;
        [_moviePlayer setFullscreen:YES animated:YES];
        [self cancelDoubleTapScale:_moviePlayer.view];
        [self cancelDoubleTapScale:_moviePlayer.backgroundView];
    }
}


/**
 *   去除双击事件
 */
- (void)cancelDoubleTapScale:(UIView *)cancelview{
    [[cancelview subviews] enumerateObjectsUsingBlock:^(id view, NSUInteger idx, BOOL *stop) {
        [[view gestureRecognizers] enumerateObjectsUsingBlock:^(id tap, NSUInteger idx, BOOL *stop) {
            if([tap isKindOfClass:[UITapGestureRecognizer class]]) {
                if([tap numberOfTapsRequired]==2){
                    [tap addTarget:self action:@selector(doubleTap:)];
                }
            }
        }];
    }];
}

- (void)doubleTap:(UIGestureRecognizer *)guesture{
//    DLog(@"双击事件");
}

#pragma mark - 类方法

/**
 *  截取指定时间的视频缩略图
 *
 *  @param timeBySecond 时间点
 */
+(UIImage *)thumbnailImageRequest:(CGFloat )timeBySecond url:(NSURL *)url{
    //创建URL
    //    NSURL *url=[self getNetworkUrl];
    //根据url创建AVURLAsset
    AVURLAsset *urlAsset=[AVURLAsset assetWithURL:url];
    //根据AVURLAsset创建AVAssetImageGenerator
    AVAssetImageGenerator *imageGenerator=[AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    /*截图
     * requestTime:缩略图创建时间
     * actualTime:缩略图实际生成的时间
     */
    NSError *error=nil;
    CMTime time=CMTimeMakeWithSeconds(timeBySecond, 10);//CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
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

#pragma mark - 对外方法
- (void)play{
    [self playVideo:nil];
}

- (void)pause{
    [self playOrPause:nil];
}

- (void)prepareToPlay{
//    [self startProgress];
    [self.moviePlayer setShouldAutoplay:YES];
    [self.moviePlayer prepareToPlay];
}

#pragma mark - 下载视频

//- (void)disposeDownloadVideoFile:(NSString *)filePath{
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
//    hud.mode = MBProgressHUDModeAnnularDeterminate;
//    [self addSubview:hud];
//    [hud show:YES];
//    self.playBtn.hidden = YES;
//    [DVHttpMethod downloadFileWithUrl:self.playUrlStr filePath:filePath pressBlock:^(NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
//        CGFloat progress = (CGFloat)((CGFloat)totalBytesRead / (CGFloat)totalBytesExpected);
//        NSLog(@"%lld,%lld,%f",totalBytesRead,totalBytesExpected,progress);
//        
//        hud.progress = progress;
//    } actionResult:^(id results, NSError *error) {
//        [hud hide:YES];
//        self.playBtn.hidden = NO;
//        if (!error) {
//            _moviePlayer.contentURL = kURLFile(filePath);
//            [self playVideo:nil];
//        }else{
//           [self showErrorMessage:[CommenMethod localizationString:@"VideoLoadingFails"]];
//        }
//        
//    }];
//}
@end
