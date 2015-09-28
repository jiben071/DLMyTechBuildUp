//
//  UploadImageInfo.h
//  Diver
//
//  Created by Tony on 14-8-6.
//  Copyright (c) 2014年 Tentinet. All rights reserved.
//

#import "BaseModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface UploadImageInfo : BaseModel

@property (nonatomic, strong) UIImage *thumbnail;           //缩略图
@property (nonatomic, assign) BOOL isUploadSuccess;     //上传是否成功
@property (nonatomic, strong) NSString *urlFromServer;  //上传成功后，服务端返回的地址
@property (nonatomic, assign) NSInteger index;          //标记图片的索引
@property (nonatomic,copy) UIImage *fullResolutionImage;//上传的图片
@property (nonatomic) ALAsset *assets;
@end