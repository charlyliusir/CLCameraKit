//
//  CameraFiles.h
//  CLCameraKit
//
//  Created by apple on 16/7/6.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "CLQueue.h"
#import "CamertConst.h"
#import "ADNSCameraFile.h"
typedef NS_ENUM(NSInteger, FileDownloadState) {
    FileDownloadStateNono,
    FileDownloadStateProgress,
    FileDownloadStateEnd
};

@interface CameraFile : CLQueue

@property (nonatomic, assign)CameraFileType fileType; // 文件类型
@property (nonatomic, assign)FileSourceType fileSourceType; // 文件源地址
@property (nonatomic, assign)CellState cameraCellState;
@property (nonatomic, copy)NSString *fileURL; // 下载地址
@property (nonatomic, copy)NSString *fileNailURL; // 缩略图下载地址
@property (nonatomic, copy)NSString *filePath; // 用以删除文件
@property (nonatomic, copy)NSString *fileDate; // 时间
@property (nonatomic, copy)NSString *fileTime; // 时间
@property (nonatomic, copy)NSNumber *fileSize; // 大小
@property (nonatomic, strong)ADNSCameraFile *cameraFile; // ADNS 文件对象

@property (nonatomic, assign)FileDownloadState download;

@end

