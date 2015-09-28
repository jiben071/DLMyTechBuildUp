//
//  UploadImageInfo.m
//  Diver
//
//  Created by Tony on 14-8-6.
//  Copyright (c) 2014年 Tentinet. All rights reserved.
//

#import "UploadImageInfo.h"

@implementation UploadImageInfo
@synthesize thumbnail,isUploadSuccess,urlFromServer,index,fullResolutionImage,assets;



- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.thumbnail = [UIImage imageWithData:[aDecoder decodeObjectForKey:@"thumbnail"]];
        self.fullResolutionImage = [UIImage imageWithData:[aDecoder decodeObjectForKey:@"fullResolutionImage"]];
        self.isUploadSuccess = [aDecoder decodeBoolForKey:@"isUploadSuccess"];
        self.urlFromServer = [aDecoder decodeObjectForKey:@"urlFromServer"];
        self.index = [aDecoder decodeIntegerForKey:@"index"];
        //self.assets = [aDecoder decodeObjectForKey:@"assets"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    NSData *thumbnailData = UIImageJPEGRepresentation(self.thumbnail, 1.0);
    [aCoder encodeObject:thumbnailData forKey:@"thumbnail"];
    NSData *fullResolutionImageData = UIImageJPEGRepresentation(fullResolutionImage, 1.0);
    [aCoder encodeObject:fullResolutionImageData forKey:@"fullResolutionImage"];
    [aCoder encodeBool:self.isUploadSuccess forKey:@"isUploadSuccess"];
    [aCoder encodeObject:self.urlFromServer forKey:@"urlFromServer"];
    [aCoder encodeInteger:self.index forKey:@"index"];
   // [aCoder encodeObject:assets forKey:@"assets"];
}
@end
