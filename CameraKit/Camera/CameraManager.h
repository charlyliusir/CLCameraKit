//
//  CameraManager.h
//  Cheche
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCamera.h"
#import "CLQueueManager.h"

#define USERDEFAULT_CAMERA_AUTO_SAVE @"AutoSave"
#define USERDEFAULT_CAMERA_AUTO_SAVEVIDEO @"AutoSaveVideo"

@interface CameraManager : NSObject

// 文件下载管理
@property (nonatomic, strong)CLQueueManager *fileQueueManager;
// 缩略图下载管理
@property (nonatomic, strong)CLQueueManager *nailQueueManager;

@property (nonatomic, assign) BOOL Ping;

/***** 属性 *****/
@property (nonatomic, readonly, getter=cameraBrand)CameraBrand brand; // 行车记录仪品牌
@property (nonatomic, readonly, getter=cameraState)CameraState state; // 行车记录仪连接状态
//@property (nonatomic, strong) NSMutableArray *cameraDownloadList;
@property (nonatomic, assign) BOOL cancelRequest;

- (void)GetPreViewURL:(void(^)(NSString * previewURL))previewURLBlock;

- (BOOL)pingIP;
/***** 方法 *****/
+ (id)sharedCameraManager;    // 单例
// 控制命令
- (void)ConnectCamera:(TypeResponse)response;  // 连接
- (void)setRecordStatus:(BOOL)recordStatus response:(BoolenResponse)response;      // 录制
- (void)changeMovieModel:(WIFI_APP_MODE_CMD)model response:(BoolenResponse)response;// 修改播放模式
- (void)TakeCapture:(DataResponse)response;     // 拍照

// 设置命令
- (void)setSystemDate:(BoolenResponse)response; // 设置系统时间
- (void)getSystemDate:(BoolenResponse)response; // 获取系统时间
- (void)resetSystem:(BoolenResponse)response;   // 恢复出厂设置


- (void)setAutoRecording:(BOOL)autoRecording response:(BoolenResponse)response;      // 设置自动录音
- (void)getAutoRecording:(TypeResponse)response; // 获取自动录音状态

- (void)setAutoRecord:(BOOL)autoRecord response:(BoolenResponse)response;      // 设置自动录制
- (void)getAutoRecord:(TypeResponse)response; // 获取自动录制状态

- (void)setRecordSize:(MOVIE_SIZE)recordSize response:(BoolenResponse)response;      // 设置录制分辨率
- (void)getRecordSize:(TypeResponse)response;  // 获取录制分辨率

- (void)setLiveSize:(MOVIE_LIVE_SIZE)liveSize response:(BoolenResponse)response;         // 设置预览分辨率
- (void)getLiveSize:(TypeResponse)response;    // 获取预览分辨率

- (void)setPhotoSize:(PHOTO_SIZE)photoSize response:(BoolenResponse)response;        // 设置图片分辨率
- (void)getPhotoSize:(TypeResponse)response;   // 获取图片分辨率

- (void)setSensititySize:(GSENSOR)sensititySize response:(BoolenResponse)response;             // 设置灵敏度
- (void)getSensititySize:(TypeResponse)response;               // 获取灵敏度

- (void)setExposureSize:(EXPOSURE)exposureSize response:(BoolenResponse)response;             // 设置曝光率
- (void)getExposureSize:(TypeResponse)response;               // 获取曝光率

- (void)setSSIDandPWD:(CameraInfo *)ssidAndPwd response:(BoolenResponse)response;
- (void)getSSIDandPWD:(DataResponse)response;

- (void)getDiskFreeSpace:(DataResponse)response;


// 文档命令
- (void)getFileList:(DataResponse)response;      // 获取文件列表
- (void)deleteFile:(CameraFile *)file response:(BoolenResponse)response;      // 获取文件列表
- (void)deleteFileList:(BoolenResponse)response; // 删除所有文件

// 设备状态命令
- (void)getCardState:(TypeResponse)response;   // 获取SD卡状态
- (void)removeUser:(BoolenResponse)response;
- (void)resetCard:(BoolenResponse)response;      // 格式化SD卡
- (void)getRecordState:(TypeResponse)response; // 获取录制状态
// 版本信息命令
- (void)getVersion:(DataResponse)response;     // 版本号
- (void)updateVersion:(DataResponse)response;  // 更新版本

@end
