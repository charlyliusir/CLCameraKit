//
//  WiFiCameraCommand.h
//  WiFiDemo
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "BaseCamera.h"
#import "CommandQueue.h"
#import "FileDownload.h"

@interface WiFiCameraCommand : BaseCamera
// ui 状态
@property (nonatomic, assign) int uiState;
// 自动录音
@property (nonatomic, assign) BOOL autoRecord;
// 声音
@property (nonatomic, assign) int  systemVolume;
// 分辨率
@property (nonatomic, assign) MOVIE_SIZE movieResolution;
// 灵敏度设置
@property (nonatomic, assign) GSENSOR    gsensor;

@end
