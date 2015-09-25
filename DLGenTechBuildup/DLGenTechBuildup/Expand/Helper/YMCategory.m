//
//  YMCategory.m
//  Helper
//
//  Created by QinMingChuan on 14-3-10.
//  Copyright (c) 2014年 QinMingChuan. All rights reserved.
//

#import "YMCategory.h"
#import "YMUtils.h"

#import <QuartzCore/QuartzCore.h>
#import <objc/message.h>
#import <sys/stat.h>
#import <dirent.h>



//绘画图片
void YMGraphicsBeginImageContext(CGSize size){
    if(UIGraphicsBeginImageContextWithOptions == NULL || [YMUtils iPad]){
        UIGraphicsBeginImageContext(size);
    }
    else{
        UIGraphicsBeginImageContextWithOptions(size, NO, 2);
    }
}

#pragma mark － ==========非UI扩展==========
#pragma mark - NSObject扩展

@implementation NSObject (YM)

//添加观察者方法
- (void)addObserverSelector:(SEL)selector name:(NSString *)name object:(id)object{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:selector name:name object:object];
}

//取消观察者方法
- (void)removeObserverName:(NSString *)name object:(id)object{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:name object:object];
}

//取消定时者方法
- (void)cancelPreviousPerformRequestsWithSelector:(SEL)selector object:(id)object{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:selector object:object];
}

- (NSString *)hashString
{
    return [NSString stringWithFormat:@"%lx",(unsigned long)[self hash]];
}

@end

#pragma mark - NSString扩展

@implementation NSString (YM)

//相对应该根目录的绝对路径
- (NSString *)absolutePath{
    return [[YMUtils YMDocumentDirectory] stringByAppendingPathComponent:self];
}

//地址编码
- (NSString *)encodeURI{
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                     kCFAllocatorDefault,
                                                                     //将当前objectC字符串转为CF字符串
                                                                     (__bridge CFStringRef)self,
                                                                     NULL,
                                                                     //被编码的字符
                                                                     CFSTR("!?&+=%# "),
                                                                     kCFStringEncodingUTF8));
}

//指定日期格式，将字符串转为日期
- (NSDate *)dateWithDateFormat:(NSString *)dateFormat{
    if(dateFormat == nil){
        return nil;
    }
    
    NSDateFormatter *formatter = [NSDateFormatter new];
//    formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    formatter.dateFormat = dateFormat;
    
    NSString *codeString = self;
    if(codeString.length <= 5)
    {
        NSArray *codeList = [codeString componentsSeparatedByString:@":"];
        if(codeList.count >= 2)
        {
            CGFloat dTimes = [codeList.firstObject intValue] * 60 * 60 + [codeList.lastObject intValue] * 60 - [NSDate timeLocationDifference];
            NSDate *backDate = [NSDate dateWithTimeInterval:dTimes sinceDate:[NSDate todayZeroHour]];
            return backDate;
        }
    }
    
    return [formatter dateFromString:self];
}

//使用默认格式，将字符串转为日期
- (NSDate *)date
{
    NSDate *backDate = [self dateWithDateFormat:NSLocalizedString(@"yyyy-MM-dd HH:mm:ss",nil)];
//    if(!backDate)
//    {
//        backDate = [self dateWithDateFormat:NSLocalizedString(@"mm:ss",nil)];
//    }
    
    return backDate;
}

//是否正则匹配
- (BOOL)isRegularMatch:(NSString *)regularString{
    @autoreleasepool {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularString
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        
        //进行匹配
        NSRange range = [regex rangeOfFirstMatchInString:self
                                                 options:NSMatchingReportProgress
                                                   range:NSMakeRange(0, self.length)];
        
        return range.length > 0;
    }
}

//清空两边的空白
- (NSString *)trim
{
    NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:characterSet];
}

@end

#pragma mark - NSData 扩展

@implementation NSData(YM)

- (id)JSONOObject  //执行json解析
{
    return [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:nil];
}

@end

#pragma mark - NSDate 扩展

@implementation NSDate (YM)

//将日期按指定的格式转为字符串
- (NSString *)stringWithDateFormat:(NSString *)dateFormat
{
    if(dateFormat == nil)
    {
        return self.description;
    }
    else
    {
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = dateFormat;
        return [formatter stringFromDate:self];
    }
}



+ (NSDate *)todayZeroHour
{
    CGFloat dTimeInterval = (int)[[NSDate date] timeIntervalSince1970] % (3600 * 24);
    return [NSDate dateWithTimeInterval:- dTimeInterval sinceDate:[NSDate date]];
}

+ (NSInteger)timeLocationDifference  //调整时区的差值
{
    static NSInteger interval;
    if(interval == 0)
    {
        NSDate *date = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        interval = [zone secondsFromGMTForDate: date];
    }
    
    return interval;
}

@end

#pragma mark - NSFileManger扩展

@implementation NSFileManager(YM)

//文件满路径
NSString *const NSFileName = @"fileName";
//文件访问时间
NSString *const NSFileAccessTime = @"fileAccessTime";

- (void)childFileInPath:(const char *)path block:(BOOL (^)(struct dirent *child, struct stat st, char *file))block{
    if(path == NULL){
        return;
    }
    
    //打开文件
    DIR *dir = opendir(path);
    
    if(dir != NULL){
        //定义子文件路径
        char subdir[1024];
        
        //目录路径长度
        unsigned long length = strlen(path);
        
        //拷贝父目录路径到子路径中
        memcpy(subdir, path, length);
        
        //判断最后一个字符是否是'/'
        if(subdir[length - 1] != '/'){
            subdir[length] = '/';
            length++;
        }
        
        //定义子目录信息
        struct dirent *child;
        
        //统计文件大小
        struct stat st;
        
        while ((child = readdir(dir)) != NULL) {
            //判断是否是文件
            if(child->d_type != DT_LNK && child->d_type != DT_REG && child->d_type != DT_DIR){
                continue;
            }
            
            //复制文件名
            memcpy(subdir + length, child->d_name, child->d_namlen);
            
            subdir[length + child->d_namlen] = 0;
            
            if(lstat(subdir, &st) == 0){
                if(block(child, st, subdir)){
                    break;
                }
            }
        }
        //关闭目录
        closedir(dir);
    }
}

//获取文件夹的大小
- (long long)sizeOfFolderPath:(const char*)path{
    
    __block long long size = 0;
    
    BOOL (^block)(struct dirent *, struct stat, char *) = ^(struct dirent *child, struct stat st, char *file) {
        if(child -> d_type == DT_DIR){
            if(child->d_name[0] != '.'){
                //递归
                size += [self sizeOfFolderPath:file];
            }
        }
        else{
            size += st.st_size;
        }
        
        return NO;
    };
    
    [self childFileInPath:path block:block];
    
    return size;
}

//获取目录下的文件且按访问时间排序
- (NSArray *)filesAtPath:(NSString *)path{
    NSMutableArray *array = [NSMutableArray array];
    
    //当前对象的弱引用
    __unsafe_unretained NSFileManager *blackSelf = self;
    
    BOOL (^block)(struct dirent *, struct stat, char *) = ^(struct dirent *child, struct stat st, char *file) {
        //如果是目录不处理
        if(child -> d_type == DT_DIR && child->d_name[0] == '.'){
            return NO;
        }
        
        //获取文件路径
        NSString *filePath = [NSString stringWithCString:child->d_name encoding:NSUTF8StringEncoding];
        //文件访问时间
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:st.st_atimespec.tv_sec];
        
        NSDictionary *dict = nil;
        
        if(child-> d_type == DT_DIR){
            dict = @{
                     NSFileName : filePath,
                     NSFileSize : @([blackSelf sizeOfFolderPath:file]),
                     NSFileAccessTime : date ,
                     NSFileType : NSFileTypeDirectory
                     };
        }
        else{
            dict = @{
                     NSFileName : filePath,
                     NSFileSize : @(st.st_size),
                     NSFileAccessTime : date
                     };
        }
        
        NSInteger min = 0, max = array.count - 1, mid = 0;
        
        //二分法排序
        while (min <= max) {
            mid = (min + max) / 2;
            
            if([date compare:[array[mid] fileAccessTime]] == NSOrderedAscending){
                max = mid - 1;
            }
            else{
                min = mid + 1;
            }
        }
        
        [array insertObject:dict atIndex:max + 1];
        return NO;
    };
    
    [self childFileInPath:path.fileSystemRepresentation block:block];
    
    return array;
}
@end


#pragma mark - 扩展NSArray

@implementation NSArray (YM)

@end

#pragma mark - 扩展NSDictionary

@implementation NSDictionary (YM)
//返回文件满路径
- (NSString *)fileName{
    return [self objectForKey:NSFileName];
}

//返回文件访问时间
- (NSDate *)fileAccessTime{
    return [self objectForKey:NSFileAccessTime];
}
@end

#pragma mark - ===========UI相关的扩展==========

#pragma mark - UIColor扩展

@implementation UIColor (YM)

// 将指定的整数转为颜色值
+ (UIColor *)colorWithUInt:(NSUInteger)rgb{
    return [self colorWithUInt:rgb alpha:1];
}

// 指定整数和颜色的透明度
+ (UIColor *)colorWithUInt:(NSUInteger)rgb alpha:(CGFloat)alpha{
    //红色
    float r = (rgb >> 16) / 255.0;
    //绿色
    float g = (rgb >> 8 & 0xff) / 255.0;
    //蓝色
    float b = (rgb & 0xff) / 255.0;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

// 直接将指定的资源图片转为颜色值
+ (UIColor *)colorWithResource:(NSString *)name{
    //获取文件路径
    NSString *file = [[NSBundle mainBundle]pathForResource:name ofType:@"png"];
    
    return [self colorWithPatternImage:[UIImage imageWithContentsOfFile:file]];
}

//获取颜色模式
- (CGColorSpaceModel)colorSpaceModel{
    return CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
}
@end


#pragma mark - UIImage扩展

@implementation UIImage (YM)

// 无缓存的加载图片
+ (UIImage *)imageWithResource:(NSString *)name{
    //获取资源的路径
    return [self imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:name ofType:@"png"]];
}

// 将颜色转为图片
+ (UIImage *)imageWithColor:(UIColor *)color{
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

// 将颜色转换为图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    YMGraphicsBeginImageContext(size);
    
    //获取当前的上下文
    CGContextRef ctf = UIGraphicsGetCurrentContext();
    
    //填充颜色
    CGContextSetFillColorWithColor(ctf, color.CGColor);
    
    //填充
    CGContextAddRect(ctf, CGRectMake(0, 0, size.width, size.height));
    
    CGContextFillPath(ctf);
    
    //获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //结束绘画
    UIGraphicsEndImageContext();
    
    return image;
}

//获取图片等比尺寸
- (CGSize)geometricSize:(CGSize)maxSize{
    CGSize size = self.size;
    
    //计算宽度比例
    float widthRate = maxSize.width / size.width;
    
    //计算高度比例
    float heightRate = maxSize.height / size.height;
    
    if(widthRate < heightRate){
        size.width  = maxSize.width;
        size.height*=widthRate;
    }
    else{
        size.height = maxSize.height;
        size.width *= heightRate;
    }
    
    return size;
}

//改变图片的尺寸
- (UIImage *)imageResize:(CGSize)size{
    UIImage *image = nil;
    
    @autoreleasepool {
        YMGraphicsBeginImageContext(size);
        [self drawInRect:(CGRect){CGPointZero, size}];
        //获取图片
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return image;
}

//改变图片的颜色
- (UIImage *)changeColor:(UIColor *)color{
    YMGraphicsBeginImageContext(self.size);
    
    //要改变的颜色
    [color setFill];
    UIRectFill((CGRect){CGPointZero, self.size});
    
    [self drawAtPoint:CGPointZero blendMode:22 alpha:1];
    
    //获取当前图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //结束绘画
    UIGraphicsEndImageContext();
    
    return image;
}

//改变图片的透明度
- (UIImage *)imageWithAlphaComponent:(CGFloat)alpha{
    YMGraphicsBeginImageContext(self.size);
    [self drawAtPoint:CGPointZero blendMode:kCGBlendModeNormal alpha:alpha];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)changeToRadius:(CGFloat)redius  //改变圆角
{
    CGRect rect = (CGRect){CGPointZero, self.size};
    YMGraphicsBeginImageContext(rect.size);
    
    UIBezierPath *roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:redius];
    roundedRectanglePath.lineWidth = 1;
    roundedRectanglePath.lineJoinStyle = kCGLineJoinRound;  //线条转弯样式
    [roundedRectanglePath addClip];
    
    [self drawInRect:rect];
    //获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //结束绘画
    UIGraphicsEndImageContext();
    return image;
}

@end

#pragma mark - UIView扩展

@implementation UIView (YM)

//设置外边框
- (void)outerBorderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth{
    CALayer *layer = self.layer;
    
    layer.borderWidth = borderWidth;
    layer.borderColor = color.CGColor;
}

//设置视图内边框
- (void)innerBorderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth{
    //设置视图内边框
    NSArray *sublayers = self.layer.sublayers;
    
    //内边层名称
    NSString *name = @"YMViewInnerBorder";
    
    CALayer *layer = nil;
    
    for (CALayer *child in sublayers) {
        if([child.name isEqualToString:name]){
            layer = child;
            break;
        }
    }
    
    //删除内边框
    if(color == nil && borderWidth == 0){
        [layer removeFromSuperlayer];
    }
    else{
        if(layer == nil){
            layer = [CALayer layer];
            layer.name = name;
            layer.frame = self.bounds;
            
        }
        //边框颜色
        layer.borderColor = color.CGColor;
        layer.borderWidth = borderWidth;
        
        [self.layer insertSublayer:layer atIndex:(unsigned)sublayers.count];
    }
}


//执行动画
- (void)transitionType:(NSString *)type subtype:(NSString *)subtype delegate:(id)delegate{
    CATransition *animation = [CATransition animation];
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.fillMode = kCAFillModeForwards;
    animation.duration = .3;
    
    animation.type = type;
    animation.subtype = subtype;
    
    if(type == kCATransitionReveal){
        self.hidden = YES;
    }
    
    animation.delegate = delegate;
    
    [self.layer addAnimation:animation forKey:nil];
}


- (void)transitionType:(NSString *)type subtype:(NSString *)subtype{
    CATransition *animation = [CATransition animation];
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.duration = .3;
    
    animation.type = type;
    animation.subtype = subtype;
    
    [self.layer addAnimation:animation forKey:nil];
}

//视图回弹效果
- (void)reboundEffect
{
    [self reboundEffectAnimationDuration:1];
}


- (void)reboundEffectAnimationDuration:(CGFloat)duration
{
    CAKeyframeAnimation *frame = [CAKeyframeAnimation new];
    frame.keyPath = @"transform";
    
    frame.duration = duration;
    frame.values = [NSArray arrayWithObjects:
                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)],
                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)],
                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)],
                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)],
                    nil];
    
    [self.layer addAnimation:frame forKey:@"reboundEffect"];
}

- (void)animationToBigType:(NSUInteger)inType //动画回弹
{
    //添加赞的效果
    CAKeyframeAnimation *transformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    //透明
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    
    if(inType == 0)
    {
        //放大三倍
        transformAnimation.values = @[
                                      [NSValue valueWithCATransform3D:CATransform3DMakeScale(2, 2, 1)],
                                      [NSValue valueWithCATransform3D:CATransform3DMakeScale(3, 3, 1)],
                                      [NSValue valueWithCATransform3D:CATransform3DMakeScale(2, 2, 1)],
                                      [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)]
                                      ];
        opacityAnimation.values = @[@.5, @0.0, @.5, @1.0]; //0.5倍透明
    }
    else if(inType == 1)
    {
        //放大1倍 然后缩小
        transformAnimation.values = @[
                                      [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1)],
                                      [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
                                      [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1)],
                                      [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)]
                                      ];
        opacityAnimation.values = @[@0.4, @0.7, @0.9, @1.0]; //1倍透明
    }
    else
    {
        //放大2倍
        transformAnimation.values = @[
                                      [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1)],
                                      [NSValue valueWithCATransform3D:CATransform3DMakeScale(2, 2, 1)],
                                      [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1)],
                                      [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)]
                                      ];
        opacityAnimation.values = @[@.5, @0.0, @.5, @1.0]; //0.5倍透明
    }
    
    //动画组
    CAAnimationGroup *groupAnimation = [[CAAnimationGroup alloc]init];
    //动画对象
    groupAnimation.animations = @[transformAnimation, opacityAnimation];
    //动画时间
    groupAnimation.duration = 0.5;
    groupAnimation.fillMode = kCAFillModeForwards;
    
    //执行动画
    [self.layer addAnimation:groupAnimation forKey:nil];
}

@end

//进度视图的tag
#define kProgressViewTag 1314520

@interface YMURLProgressView : UILabel  //进度视图
@property (nonatomic) CGFloat progress;
@end

@implementation YMURLProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.textAlignment = UITextAlignmentCenter;
        self.font          = [UIFont systemFontOfSize:11];
        self.textColor     = [UIColor whiteColor];
        self.shadowColor   = [UIColor blackColor];
        self.shadowOffset  = CGSizeMake(0.5, 0.5);
    }
    
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    if(_progress != progress)
    {
        self.text = [NSString stringWithFormat:@"%ld%@",(NSInteger)(progress * 100), @"%"];
        _progress = progress;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGFloat lineWidth = 4;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, lineWidth); //设置线条的宽度
    CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
    CGContextMoveToPoint(context,CGRectGetMidX(rect), rect.origin.y + (lineWidth + 1) / 2);
    CGContextAddArc(context, CGRectGetMidX(rect), CGRectGetMidY(rect), rect.size.width/2 - (lineWidth + 1) / 2,   -M_PI/2, (-M_PI/2 + _progress*2*M_PI), 0);
    CGContextStrokePath(context);
}
@end

#pragma mark - UIImageView扩展

@implementation UIImageView (YM)

//指定网址，加载网络图片
- (void)setImageWithURLString:(NSString *)urlString
{
    [self setImageWithURLString:urlString placeholderImage:nil];
}

//指定网址和初始图片，加载网络图片
- (void)setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeImage
{
    [self setImageWithURLString:urlString placeholderImage:placeImage transDataBlock:NULL];
}

//加载图片后处理为圆图缓存下来
- (void)setRoundImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeImage
{
    [self setImageWithURLString:urlString placeholderImage:placeImage transDataBlock:^NSData *(NSData *data) {
        UIImage *image = [UIImage imageWithData:data];
        if((image.size.width - image.size.height) / image.size.height > 0.05)  //不是正方形就处理程正方形
        {
            CGFloat nXY = MIN(image.size.width, image.size.height);
            image = [image imageResize:CGSizeMake(nXY, nXY)];
        }
        
        image = [image changeToRadius:8];
        
        return UIImagePNGRepresentation(image);
    }];
}

- (YMURLProgressView *)progressView
{
    YMURLProgressView *progress = (YMURLProgressView *)[self viewWithTag:kProgressViewTag];
    if(!progress)
    {
        progress = [[YMURLProgressView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        progress.backgroundColor = [UIColor clearColor];
        progress.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        progress.tag = kProgressViewTag;
    }
    
    return progress;
}

//数据加载中 进度
- (void)asyncDataURLString:(NSString *)urlString progress:(CGFloat)progress;
{
    [(YMURLProgressView *)[self viewWithTag:kProgressViewTag] setProgress:progress];
}

//数据加载成功
- (void)asyncDataURLString:(NSString *)urlString receiveData:(NSData *)data fromLocal:(BOOL)fromLocal
{
    [[self viewWithTag:kProgressViewTag] removeFromSuperview];
    
    UIImage *image = [UIImage imageWithData:data];
    self.image = image;
}

//数据加载失败
- (void)asyncDataURLString:(NSString *)urlString error:(NSError *)error
{
    [[self viewWithTag:kProgressViewTag] removeFromSuperview];
}

@end

#pragma mark - 扩展UIBarButtonItem

@implementation UIBarButtonItem (YM)

//初始化为不带边框的按钮元素
- (id)initWithCustomViewImage:(UIImage *)image customViewTitle:(NSString *)title{
    self = [super init];
    
    if(self){
        UIButton *customView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
        
        customView.showsTouchWhenHighlighted = YES;
        
        //图片
        if(image){
            [customView setImage:image forState:UIControlStateNormal];
        }
        
        //标题
        if(title){
            [customView setTitle:title forState:UIControlStateNormal];
            
            UILabel *label = customView.titleLabel;
            //字体
            label.font = [UIFont boldSystemFontOfSize:12];
            //阴影
            //label.shadowColor = [UIColor grayColor];
            [customView setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            label.shadowOffset = CGSizeMake(0.5, 0.5);
        }
        
        //绑定事件
        [customView addTarget:self
                       action:@selector(touchUpInside:)
             forControlEvents:UIControlEventTouchUpInside];
        
        self.customView = customView;
        
        //ios6会导致值为值，必须注意
        customView.enabled  = YES;
    }
    
    return self;
}

//构造工厂
+ (id)barButtonItemWithCustomViewImage:(UIImage *)image customViewTitle:(NSString *)title{
    return [[self alloc] initWithCustomViewImage:image customViewTitle:title];
}

@end