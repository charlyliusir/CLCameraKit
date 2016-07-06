//
//  CameraFiles.h
//  CLCameraKit
//
//  Created by apple on 16/7/6.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "CLQueue.h"
#import "CamertConst.h"

@interface CameraFile : CLQueue

@property (nonatomic, assign)CameraFileType fileType; // 文件类型
@property (nonatomic, assign)FileSourceType fileSourceType; // 文件源地址
@property (nonatomic, copy)NSString *fileURL; // 下载地址
@property (nonatomic, copy)NSString *fileNailURL; // 缩略图下载地址
@property (nonatomic, copy)NSString *fileDate; // 时间
@property (nonatomic, copy)NSString *fileTime; // 时间
@property (nonatomic, copy)NSNumber *fileSize; // 大小

@property (nonatomic, assign)BOOL download;

@end

