//
//  NSObject+UIImageExt.h
//  Ming
//
//  Created by Apple on 9/26/14.
//  Copyright (c) 2014 Twilit Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageExt)
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
@end
