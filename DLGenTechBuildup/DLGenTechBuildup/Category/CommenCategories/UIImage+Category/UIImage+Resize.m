// UIImage+Resize.m
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

#import <UIKit/UIKit.h>

#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"
#import "UIImage+Alpha.h"
#import "UIImageResizing.h"

@implementation UIImage (Resize)

// Returns a copy of this image that is cropped to the given bounds.
// The bounds will be adjusted using CGRectIntegral.
// This method ignores the image's imageOrientation setting.
- (UIImage *)croppedImage:(CGRect)bounds {
    CGFloat scale = MAX(self.scale, 1.0f);
    CGRect scaledBounds = CGRectMake(bounds.origin.x * scale, bounds.origin.y * scale, bounds.size.width * scale, bounds.size.height * scale);
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], scaledBounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    return croppedImage;
}

// Returns a copy of this image that is squared to the thumbnail size.
// If transparentBorder is non-zero, a transparent border of the given size will be added around the edges of the thumbnail. (Adding a transparent border of at least one pixel in size has the side-effect of antialiasing the edges of the image when rotating it using Core Animation.)
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality {

    UIImage *resizedImage = [self resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                                       bounds:CGSizeMake(thumbnailSize, thumbnailSize)
                                         interpolationQuality:quality];
    

    // Crop out any part of the image that's larger than the thumbnail size
    // The cropped rect must be centered on the resized image
    // Round the origin points so that the size isn't altered when CGRectIntegral is later invoked
    CGRect cropRect = CGRectMake(round((resizedImage.size.width - thumbnailSize) / 2),
                                 round((resizedImage.size.height - thumbnailSize) / 2),
                                 thumbnailSize,
                                 thumbnailSize);
    UIImage *croppedImage = [resizedImage croppedImage:cropRect];
    
    UIImage *transparentBorderImage = borderSize ? [croppedImage transparentBorderImage:borderSize] : croppedImage;
    
    return [transparentBorderImage roundedCornerImage:cornerRadius borderSize:borderSize];
}

// Returns a rescaled copy of the image, taking into account its orientation
// The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    if (self.imageOrientation == UIImageOrientationUp)
        return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

// Resizes the image according to the given content mode, taking into account the image's orientation
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality {
    CGFloat horizontalRatio = bounds.width / self.size.width;
    CGFloat verticalRatio = bounds.height / self.size.height;
    CGFloat ratio;
    
    switch (contentMode) {
        case UIViewContentModeScaleAspectFill:
            ratio = MAX(horizontalRatio, verticalRatio);
            break;
            
        case UIViewContentModeScaleAspectFit:
            ratio = MIN(horizontalRatio, verticalRatio);
            break;
            
        default:
            [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %d", contentMode];
    }
    
    CGSize newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);
    
    return [self resizedImage:newSize interpolationQuality:quality];
}

#pragma mark -
#pragma mark Private helper methods

// Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
// The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
// If the new size is not integral, it will be rounded up
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality {
    CGFloat scale = MAX(1.0f, self.scale);
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width*scale, newSize.height*scale));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    // Fix for a colorspace / transparency issue that affects some types of 
    // images. See here: http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/comment-page-2/#comment-39951
        
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmap = CGBitmapContextCreate(
                                                NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                8, /* bits per channel */
                                                (newRect.size.width * 4), /* 4 channels per pixel * numPixels/row */
                                                colorSpace,
                                                (CGBitmapInfo)kCGImageAlphaPremultipliedLast
                                                );
    CGColorSpaceRelease(colorSpace);
	
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:self.scale orientation:UIImageOrientationUp];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}

// Returns an affine transform that takes into account the image orientation when drawing a scaled image
- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    return transform;
}


-(UIImage*) compressImage
{
    UIImage * imgResult=[self resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(960, 960) interpolationQuality:kCGInterpolationLow];
    NSData * imgData=UIImageJPEGRepresentation(imgResult, 0.3);
    imgResult=[UIImage imageWithData:imgData];
    return  imgResult;
}


-(UIImage*) compressImage1
{
    UIImage * imgResult=[self resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(960, 960) interpolationQuality:kCGInterpolationMedium];
    NSData * imgData=UIImageJPEGRepresentation(imgResult, 0.8);
    imgResult=[UIImage imageWithData:imgData];
    return  imgResult;
}



-(UIImage*) compressSmallImage
{
    UIImage * imgResult=[self resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(150, 150) interpolationQuality:kCGInterpolationLow];
    NSData * imgData=UIImageJPEGRepresentation(imgResult, 1);
    imgResult=[UIImage imageWithData:imgData];
    return  imgResult;
}


-(UIImage*)compressImageSize {
    UIImage * imgResult=[self resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:self.size interpolationQuality:kCGInterpolationLow];
    NSData * imgData=UIImageJPEGRepresentation(imgResult, 0.3);
    imgResult=[UIImage imageWithData:imgData];
    return  imgResult;
}

-(UIImage*)compressImageSize960x672 {
    CGFloat compression = 1.0;
    UIImage * imgResult=[self scaleToSize:CGSizeMake(960, 672)];
    NSData *data = UIImageJPEGRepresentation(imgResult, compression);
    CGFloat kbSize = data.length / 1024;
    if (kbSize > 80) {
        compression = compression * (80 / kbSize);
        NSData * imgData = UIImageJPEGRepresentation(imgResult,compression);
        imgResult=[UIImage imageWithData:imgData];
    }
    return  imgResult;
}

- (UIImage *)compressImageMaxLength960{
    CGFloat compression = 1.0;
    
    UIImage *imgResult;
    if (self.size.width > self.size.height) {
        imgResult =[self scaleToSize:CGSizeMake(960, 960 * self.size.height / self.size.width)];
    } else {
        imgResult =[self scaleToSize:CGSizeMake(960 * self.size.height / self.size.width, 960)];
    }
    
    NSData *data = UIImageJPEGRepresentation(imgResult, compression);
    CGFloat kbSize = data.length / 1024;
    if (kbSize > 400) {
        compression = compression * (400 / kbSize);
        NSData * imgData = UIImageJPEGRepresentation(imgResult, compression);
        imgResult=[UIImage imageWithData:imgData];
    }
    return  imgResult;
}


@end
