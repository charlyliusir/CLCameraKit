//
//  AITCameraCommand.h
//  WiFiCameraViewer
//
//  Created by Clyde on 2013/11/8.
//  Copyright (c) 2013年 a-i-t. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AITCameraCommand : NSObject

// Set property
+ (NSString*) setProperty:(NSString*)prop Value:(NSString*)val;
//修改ssid和encryptionKey
+ (NSString*) commandUpdateUrl: (NSString *) ssid EncryptionKey: (NSString *) encryptionKey ;
+ (NSString *) commandUpdateSSID:(NSString *)ssid;
+ (NSString *) commandUpdateEncryptionKey:(NSString *)encryptionKey;
//查找camera
+ (NSString*) commandFindCameraUrl ;
//拍照
+ (NSString*) commandCameraSnapshotUrl;
//录像
+ (NSString*) commandCameraRecordUrl;
//在线预览状态
+ (NSString*) commandQueryPreviewStatusUrl;
//前置后置摄像头
+ (NSString*) commandGetCameraidUrl;
//设置前置/后置摄像头
+ (NSString*) commandSetCameraidUrl:(NSString *) camid;
//获取当前录制状态
+ (NSString*) commandQueryCameraRecordUrl;
//重新激活
+ (NSString*) commandReactivateUrl ;
//获取wifi信息
+ (NSString*) commandWifiInfoUrl ;
//文件列表
+ (NSString*) commandListFileUrl: (int) count  From: (int) from;
+ (NSString*) commandListJPEGFileUrl: (int)count;
+ (NSString*) commandListMOVFileUrl: (int)count;
//回看
+ (NSString *) commandPlayBackFileUrl: (NSString *)fileName;
//删除文件
+ (NSString*) commandDelFileUrl: (NSString *) fileName;
//menu
+ (NSString*) commandQuerySettings;
//设置视频大小
+ (NSString*) commandSetVideoRes: (NSString*) nsRes;
//设置图片大小
+ (NSString*) commandSetImageRes: (NSString*) nsRes;
//设置刷新频率
+ (NSString*) commandSetFlicker: (NSString*) nsHz;
//设置曝光率
+ (NSString*) commandSetEV: (NSString*) nsEvlabel;
//碰撞灵敏度
+ (NSString*) commandSetMTD: (NSString*) nsmtd;
//白平衡
+ (NSString*) commandSetAWB: (NSString*) nsawb;
//设置时间
+ (NSString*) commandSetDateTime: (NSString *) datetime;
//menu XML
+ (NSString*) commandGetCamMenu;
//格式化SD卡
+ (NSString *) commandFormat;
//恢复出厂设置
+ (NSString *) commandReset;
//检测SD卡是否存在
+ (NSString *) commandCheckSDCard;
//检测SD卡容量
+ (NSString *) commandGetSDCardInfoTotal;
+ (NSString *) commandGetSDCardInfoFree;
//改变自动录音状态
+ (NSString *) commandSetAutoRecoding;
+ (NSString *) commandGetAutoRecoding;
//解析数据
+ (NSDictionary*) buildResultDictionary:(NSString*)result;

+ (NSString *) PROPERTY_SSID ;
+ (NSString *) PROPERTY_ENCRYPTION_KEY ;
+ (NSString *) PROPERTY_CAMERA_RTSP;
+ (NSString *) PROPERTY_QUERY_RECORD;
+ (NSString *) PROPERTY_CAMERAID;

+ (NSString *) PROPERTY_awb;
+ (NSString *) PROPERTY_ev;
+ (NSString *) PROPERTY_mtd;
+ (NSString *) PROPERTY_ImageRes;
+ (NSString *) PROPERTY_Flicker;
+ (NSString *) PROPERTY_VideoRes;
+ (NSString *) PROPERTY_IsStreaming;
+ (NSString *) PROPERTY_FWversion;
+ (NSString *) PROPERTY_DATETIME;
+ (NSString *) PROPERTY_AUTOVOLUE;
+ (NSString *) PROPERTY_SDCARD_TOTAL;
+ (NSString *) PROPERTY_SDCARD_FREE;
+ (NSString *) CAMERA_IP;

@end
