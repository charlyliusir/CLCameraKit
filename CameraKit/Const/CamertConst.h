//
//  CamertConst.h
//  Cheche
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#ifndef CamertConst_h
#define CamertConst_h

#import "NovatekCameraConst.h"

#define SSID_STRING_VALUE @"ssid"
#define PWD_STRING_VALUE  @"passphrase"

#define NovatekIP @"http://192.168.1.254"
#define NovatekClass @"NovatekCamera"

#define TakeCutURL @"/?custom=1&cmd=2018"

#define UPLOAD_VIDEO_URLS @"http://autobot.im/server/autobot/video/detail/"

#define NOTIFITY_INIT_DOWNLOAD @"InitProgress"
#define USERDEFAULT_CAMERA_PIC_SIZE @"PicSize"
#define USERDEFAULT_CAMERA_MOVIE_SIZE @"MovieSize"

#define LOCAL_NAIL_PHTOT_FILE_NAME @"PhotoNail"
#define LOCAL_NAIL_Movie_FILE_NAME @"MovieNail"
#define LOCAL_PHTOT_FILE_NAME @"Photo"
#define LOCAL_Movie_FILE_NAME @"Movie"

#define LOCAL_NAIL_FILE_LIST @[LOCAL_NAIL_PHTOT_FILE_NAME, LOCAL_NAIL_Movie_FILE_NAME]
#define LOCAL_FILE_LIST @[LOCAL_PHTOT_FILE_NAME, LOCAL_Movie_FILE_NAME]

/*--------------PHOTO SIZE----------------*/
// 行车记录仪品牌
typedef NS_ENUM(NSInteger, CameraBrand) {
    CameraBrandNono,          // ping ip 不通过, 无设备连接
    CameraBrandNovate,         // 联咏
    CameraBrandAIT,              // AIT
};

// 连接状态
typedef NS_ENUM(NSInteger, CameraState) {
    CameraStateDisConnected,  // 未连接
    CameraStateConnected,     // 已连接
    CameraStateRecord         // 正在录制
};

typedef enum PHOTO_SIZE
{
    PHOTO_SIZE_12M,
    PHOTO_SIZE_10M,
    PHOTO_SIZE_8M,
    PHOTO_SIZE_5M,
    PHOTO_SIZE_3M,
    PHOTO_SIZE_2MHD,
    PHOTO_SIZE_VGA,
    PHOTO_SIZE_1M,
    PHOTO_SIZE_ID_MAX
}PHOTO_SIZE;

/*--------------MOVIE RECORD SIZE----------------*/
typedef enum MOVIE_SIZE
{
    MOVIE_SIZE_1080P,   //  (1920*1080)
    MOVIE_SIZE_720P,
    MOVIE_SIZE_WVGA,
    MOVIE_SIZE_VGA,
    MOVIE_SIZE_1440P    //  (1440*1080)
}MOVIE_SIZE;

/*--------------MOVIE LIVE SIZE----------------*/
typedef enum MOVIE_LIVE_SIZE
{
    MOVIE_LIVE_SIZE_720P,
    MOVIE_LIVE_SIZE_WVGA,
    MOVIE_LIVE_SIZE_VGA,
    MOVIE_LIVE_SIZE_360P,
    MOVIE_LIVE_SIZE_QVGA
}MOVIE_LIVE_SIZE;

/*--------------MOVIE CYCLICREC----------------*/
typedef enum MOVIE_CYCLICREC
{
    MOVIE_CYCLICREC_OFF,
    MOVIE_CYCLICREC_3MIN,
    MOVIE_CYCLICREC_5MIN,
    MOVIE_CYCLICREC_10MIN,
    MOVIE_CYCLICREC_ID_MAX
}MOVIE_CYCLICREC;

/*--------------EXPOSURE----------------*/
typedef enum EXPOSURE {
    EV_P20,
    EV_P16,
    EV_P13,
    EV_P10,
    EV_P06,
    EV_P03,
    EV_00,
    EV_N03,
    EV_N06,
    EV_N10,
    EV_N13,
    EV_N16,
    EV_N20,
    EV_SETTING_MAX
}EXPOSURE;

/*--------------GSENSOR----------------*/
typedef enum GSENSOR {
    GSENSOR_OFF = 0,
    GSENSOR_LOW,
    GSENSOR_MED,
    GSENSOR_HIGH,
//    GSENSOR_ID_MAX
}GSENSOR;

typedef enum WIFI_APP_MODE_CMD{
    WIFI_APP_MODE_PHOTO = 0,
    WIFI_APP_MODE_MOVIE,
    WIFI_APP_MODE_PLAYBACK,
    ENUM_DUMMY4WORD
} WIFI_APP_MODE_CMD;

typedef enum WIFI_APP_CARD_STATE{
    WIFI_APP_CARD_STATE_REMOVED = 0,
    WIFI_APP_CARD_STATE_INSERTED,
    WIFI_APP_CARD_STATE_LOCKED
} WIFI_APP_CARD_STATE;

typedef enum CarState{
    CarStateNon = -1,
    CarStateNot = 0,
    CarStateHave
} CarState;

// 列表页
typedef NS_ENUM(NSInteger, CameraFileType) {
    CameraFileTypePhoto,
    CameraFileTypeMovie,
};

typedef NS_ENUM(NSInteger, FileSourceType){
    FileSourceTypeCamera,
    FileSourceTypeLocation
};

typedef NS_ENUM(NSInteger, CellState) {
    CellStateNone,
    CellStateEdit,
    CellStateDownload,
    CellStateProgress,
};

// 无数据返回类型 (是否成功)
typedef void(^BoolenResponse)(BOOL success,CameraState eyeState);
// 无数据多类型返回类型 (例如：连接状态)
// 当 success 为 NO时, type 为 -1
typedef void(^TypeResponse)(BOOL success , int type,CameraState eyeState);
// 有数据返回类型 (例如：获取文件列表)
typedef void(^DataResponse)(BOOL success, id obj, CameraState eyeState);
// 下载数据返回类型 (下载图片和视频)
typedef void(^DownloadResponese)(BOOL success, id obj, float progress);

#endif /* CamertConst_h */
