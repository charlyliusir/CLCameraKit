//
//  CameraTools.h
//  Cheche
//
//  Created by apple on 16/3/30.
//  Copyright © 2016年 apple. All rights reserved.
//

// Camera 辅助工具类

#import <Foundation/Foundation.h>
#import "CamertConst.h"
#import "CameraFile.h"

@interface CameraTools : NSObject

+ (NSString *)getCameraAddress;
// 本地缩略图文件地址
+ (NSString *)localNailFilePath:(CameraFileType)fileType;

// 本地文件地址
+ (NSString *)localFilePath:(CameraFileType)fileType;

// 记录仪图片
+ (NSDictionary *)cameraPhotoList:(NSArray *)fileList downloadFile:(NSArray *)localFileList;
+ (NSArray *)cameraPhotoDataRows:(NSDictionary *)photoList;

// 记录仪视频
+ (NSArray *)cameraMovieList:(NSArray *)fileList downloadFile:(NSArray *)localFileList;

// 获取本地图片列表
+ (NSDictionary *)localPhotoList;

// 获取本地视频列表
+ (NSArray *)localMovieList;

+ (NSArray *)localDataList:(CameraFileType)fileType;

// 换算内存大小
+ (NSString *)memoryWithSize:(NSNumber *)memorySize;

+(void)deleteFile:(CameraFileType)fileType Objects:(NSArray *)Objects;


+ (NSString *)covertDateWithString:(NSString *)dataString;
+ (NSString *)covertTimeWithString:(NSString *)timeString;

+ (NSURL *)movieURLPath:(CameraFile *)file;
+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

// 将下载的视频合成缩略图
+ (BOOL)saveFileNailWithType:(CameraFileType )type
                        NailUrl:(NSURL *)nailurl
                     FileUrl:(NSURL *)fileUrl;


@end
