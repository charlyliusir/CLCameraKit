//
//  WiFiCMD.h
//  CLWiFiDemo
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#ifndef WiFiCMD_h
#define WiFiCMD_h

static NSString *const HOST = @"192.168.42.1";
static int const PORT = 2000;

#define WIFI_DOWNLOAD_MAX_SIZE  (500 * 1024)
#define WIFI_CFG_SSID_LEN       50
#define WIFI_CFG_PSWD_LEN       50

typedef unsigned int   ER_RESULT;                /* Error result type */

#define ER_OK          (ER_RESULT)(0x00000000U)  /* OK, no error */
#define ER_PARA_CONST  (ER_RESULT)(0x00000001U)  /* Parameter loaded from NVM error */
#define ER_PARA_RANGE  (ER_RESULT)(0x00000002U)  /* Parameter out of range */
#define ER_PARA_VALUE  (ER_RESULT)(0x00000004U)  /* Parameter of incorrect value */
#define ER_OVERTIME    (ER_RESULT)(0x00000008U)  /* Wait overtime */
#define ER_BUSY        (ER_RESULT)(0x00000010U)  /* Device of Module is busy */
#define ER_NOT_INIT    (ER_RESULT)(0x00000020U)  /* Device of Module has not been init */
#define ER_NOT_SUPPORT (ER_RESULT)(0x00000040U)  /* Request not support */
#define ER_BUFF_EMPTY  (ER_RESULT)(0x00000080U)  /* Buffer is empty */
#define ER_BUFF_FULL   (ER_RESULT)(0x00000100U)  /* Buffer is full */
#define ER_HW_PER      (ER_RESULT)(0x00000200U)  /* Internal peripherals error */
#define ER_HW_IC       (ER_RESULT)(0x00000400U)  /* External IC error */
#define ER_ACCESS      (ER_RESULT)(0x00000800U)  /* Can not access to the desire area */
#define ER_CHECK       (ER_RESULT)(0x00001000U)  /* Value Check Error */
#define ER_BUS_OFF     (ER_RESULT)(0x00002000U)  /* CAN bus-off */
#define ER_ABORT       (ER_RESULT)(0x00004000U)  /* Process has been aborted */
#define ER_OVERFLOW    (ER_RESULT)(0x00008000U)  /* Data overflow */
#define ER_UNKNOW      (ER_RESULT)(0x80000000U)  /* Unknown*/

// CMD
static const uint8_t CONNECTION = 0x00;
static const uint8_t UI_CONTROL = 0x01;
static const uint8_t FAST_CONTROL = 0x02;
static const uint8_t FILE_CONTROL = 0x10;
static const uint8_t CONFIG_GET = 0x11;
static const uint8_t CONFIG_SET = 0x12;
static const uint8_t CAMERA_CALI = 0x13;
//static const uint8_t UPGRADE = 0x12;

// CONNECTION SUBCMD
static const uint8_t HANDSHAKE = 0x00; /*--握手信号,可以用于通讯测试--*/
static const uint8_t HEARTBEAT = 0x10; /*--心跳包--*/

// FAST_CONTROL
static const uint8_t FAST_CYCLE_RECORD = 0x00; /*--临时开启或关闭循环录制,下次开启默认开启--*/
static const uint8_t FAST_EMERGE = 0x10; /*--执行一次紧急录制--*/
static const uint8_t FAST_PHOTOGRAPHY = 0x11; /*--执行一次拍照--*/

// FILE_CONTROL
static const uint8_t GET_SDCARD_STATUS = 0x00; /*--SD卡状态--*/
static const uint8_t GET_FILE_LIST = 0x01; /*--获取文档信息列表--*/
static const uint8_t REQ_VIDEO_PLAYBACK = 0x10; /*--在线回放指定视频--*/
static const uint8_t REQ_FILE_DOWNLOAD = 0x20; /*--下载指定视频文件--*/
static const uint8_t REQ_FILE_DELETE = 0x21; /*--删除指定文件--*/

// CONFIG_GET
static const uint8_t GET_RECORD_CFG = 0x00; /*--查询视频信息设置--*/
static const uint8_t GET_WIFI_CFG = 0x01; /*--查询SSID和Password--*/
static const uint8_t GET_AUDIO_PLAY_CFG = 0x10; /*--查询播放信息设置--*/
static const uint8_t GET_GSENSOR_CFG = 0x11; /*--查询传感器设置--*/
static const uint8_t GET_ADAS_CFG = 0x12; /*--查询ADAS设置--*/
static const uint8_t GET_VERSION = 0x20; /*--查询ADAS设置--*/

// CONFIG_SET
static const uint8_t SET_RESOLUTION = 0x00; /*--分辨率--*/
static const uint8_t SET_DURATION = 0x01; /*--录制时间--*/
static const uint8_t SET_AUDIO_RECORD = 0x02; /*----*/
static const uint8_t SET_HDR = 0x03;
static const uint8_t SET_OSD = 0x04;
static const uint8_t SET_SSID = 0x05; /*--设置SSID--*/
static const uint8_t SET_PSWD = 0x06; /*--设置PSWD--*/
static const uint8_t SET_AUDIO_PLAY_CFG = 0x10; /*--播放信息设置--*/
static const uint8_t SET_GSENSOR_CFG = 0x11; /*--敏感度设置--*/
static const uint8_t SET_ADAS_CFG = 0x12; /*--ADAS设置--*/
static const uint8_t SDCARD_FORMATTING = 0x20; /*--格式化SD卡--*/
static const uint8_t FACTORY_RESET = 0x21; /*--恢复出厂设置--*/

// CAMERA_CALI
static const uint8_t GET_CALI_PARAM = 0x00;
static const uint8_t EXECUTE_CALIBRATION = 0x01;

// UPGRADE

struct message_info{
    uint8_t head[2];
    uint32_t len;
    uint8_t cmd;
    uint8_t sub;
    uint8_t * data;
    uint32_t crc;
};

// Connect
struct tCmdHeartBeat
{
    uint8_t ucUIRequest;                  /* 0-preview, 1-files, 2-config, 3-calibration. */
    uint8_t	reserved[3];
    uint16_t	year;
    uint16_t	month;
    uint16_t	day;
    uint16_t	hour;
    uint16_t	minute;
    uint16_t	second;
};

struct tAckHeartBeat
{
    uint8_t ucUIStatus;                   /* 0-preview, 1-files, 2-config, 3-calibration. */
    uint8_t ucCycleRecordStatus;          /* 0-stop, 1-starting, 2-start, 3-stopping. */
    uint8_t ucEventRecordStatus;          /* 0-stop, 1-starting, 2-start, 3-stopping. */
    uint8_t ucr;          /* 0-stop, 1-starting, 2-start, 3-stopping. */
    uint16_t usCycleRecordTimer;          /* unit seconds */
    uint16_t usEventRecordTimer;          /* unit seconds */
    uint8_t ucAudioRecordStatus;          /* 0-close, 1-open */
    uint8_t ucSystemVolume;               /* unit %.(0-close all system audio playing) */
    uint8_t ucHdrStatus;                  /* 0-close, 1-open, 2-error */
    uint8_t ucAdasStatus;                 /* 0-not calibratted, 1-not init, 2-running, 3-calibrating. */
    uint8_t ucGSensorStatus;              /* 0-normal, 1-error. */
    uint8_t ucGpsStatus;                  /* 0-normal, 1-disconnect, 2-signal error. */
    uint8_t ucBlueToothStatus;            /* 0-normal(close), 1-noraml(open-silence), 2-normal(open-transmitting), 3-error. */
    uint8_t ucSdcardStatus;               /* 0-normal, 1-not insert, 2-format error, 3-space too small, 4-write failed, 5-formatting. */
    uint8_t ucCameraStatus;               /* 0-normal, 1-disconnect. */
    uint8_t ucBatteryStatus;              /* 0-normal, 1-low, 2-too low */
    uint8_t ucExtPowerStatus;             /* 0-access, 1-not access. */
    uint8_t ucAudioChipStatus;            /* 0-normal, 1-error. */
    uint8_t ucSystemMode;                 /* 0-normal,1-userkey,2-vehiclestop,3-shutdownprotect*/
};

// Control
struct tAckGetSdcardStatus
{
    uint8_t  ucSdcardStatus;              /* 0-normal, 1-not insert, 2-format error, 3-space too small, 4-write failed, 5-formatting. */
    uint8_t  ucSdcardFormat;              /* 0-FAT32, 1-exFAT, others-not support. */
    uint16_t usReserved;                  /*  */
    uint32_t uiTotal;                     /* uint KB */
    uint32_t uiTotalUsed;                 /* uint KB */
    uint32_t uiTotalFree;                 /* uint KB */
    uint32_t uiCycleUsed;                 /* uint KB */
    uint32_t uiEventUsed;                 /* uint KB */
    uint32_t uiImageUsed;                 /* uint KB */
    uint8_t  ucCyclePercent;              /* uint % */
    uint8_t  ucEventPercent;              /* uint % */
    uint8_t  ucImagePercent;              /* uint % */
};

struct tAckFileInfo
{
    uint16_t usIndex;                     /* 1 ~ 65535 */
    uint8_t  ucType;                      /* 0-video, 1-image. */
    uint8_t  ucAttr;                      /* 0-not protect, 1-protectted. */
    uint32_t uiSize;                      /* unit uint8_ts. */
    uint32_t uiDate;                      /* File create time from 1970/1/1 0:0:0, unit seconds. */
};

struct tCmdReqVideoPlayback
{
    uint16_t usFileIndex;                 /* 1 ~ 65535. */
    uint16_t usCommand;                   /* 0-play(normal speed), 1-stop, 2-pause, 3-locate, 4-fast forward, 5-fast backward. */
    uint32_t uiLocateTime;                /* Locate time from video beginning, unit seconds. */
};

struct tCmdReqTakePhoto
{
    uint16_t usFileIndex;                 /* 1 ~ 65535. */
    uint32_t uiDate;                /* Locate time from video beginning, unit seconds. */
};

struct tCmdReqFileDownload
{
    uint16_t usFileIndex;                 /* 1 ~ 65535 */
    uint16_t usDataType;                  /* 0-data of video or image, 1-thumbnail of video */
    uint32_t uiDataPosition;              /* Data start position  */
} ;

struct tAckReqFileDownload
{
    uint32_t uiTotalSize;                 /* Total size of Thumbnail , unit uint8_ts */
    uint32_t uiCurrentSize;               /* Current size in this transmition, unit uint8_ts, max 500KB */
    uint32_t uiRemainSize;                /* Remain size witch has not be transmitted, unit uint8_ts */
    uint32_t uiDataPosition;              /* Data start position(according to the received value) */
    uint8_t  ucData[WIFI_DOWNLOAD_MAX_SIZE];/* Data of the thumbnail, witch start from the "DataPosition", max 500KB */
} ;


// Get
struct tAckGetRecordCfg
{
    uint8_t ucResolution;                 /* 0-1080P, 1-720P */
    uint8_t ucDuration;                   /* Cycle recording duration, uint minutes. */
    uint8_t ucAudioRecordEnable;          /* 0-disable, 1-enable. */
    uint8_t ucHdrEnable;                  /* 0-disable, 1-enable. */
    uint8_t ucOsdEnable;                  /* 0-disable, 1-enable. */
} ;

struct tAckGetWifiCfg
{
    uint8_t ucSSID[WIFI_CFG_SSID_LEN];    /* name of this device */
    uint8_t ucPSWD[WIFI_CFG_PSWD_LEN];    /* password of wifi-connecting */
} ;

struct tAckGetAudioPlayCfg
{
    uint8_t ucSystemVolume;	            /* unit % (0-close all system audio playing) */
    uint8_t ucPowerStateEnable;	        /* 0-disable, 1-enable. */
    uint8_t ucEventRecordEnable;	        /* 0-disable, 1-enable. */
    uint8_t ucPhotographyEnable;	        /* 0-disable, 1-enable. */
    uint8_t ucAdasWarningEnable;	        /* 0-disable, 1-enable. */
} ;

struct tAckGetGsensorCfg
{
    uint8_t ucWakeupSensitivity;	        /* 0-close, 1-low(°¿0.6g), 2-middle(°¿0.8g), 3-high(°¿1.0g) */
    uint8_t ucEmergeSensitivity;	        /* 0-close, 1-low(°¿1.5g), 2-middle(°¿2.0g), 3-high(°¿2.5g) */
} ;

struct tAckGetAdasCfg
{
    uint8_t ucAdasEnable;	                /* 0-disable, 1-enable. */
    uint8_t ucLdwSensitivity;	            /* 0-close, 1-low, 2-middle, 3-high */
    uint8_t ucHwwSensitivity;	            /* 0-close, 1-low, 2-middle, 3-high */
    uint8_t ucFcwSensitivity;	            /* 0-close, 1-low, 2-middle, 3-high */
    uint8_t ucVehicleStartEnable;         /* 0-disable, 1-enable. */
} ;

struct tAckGetVersionCgf
{
    uint8_t	ucsoftwareVersion[10];
    uint8_t	uchdrdwareVersion[10];
};

struct tCmdExecuteCalibration
{
    uint16_t	uiVehicleID;                /* Current vehicle ID */
    uint16_t	uiCameraHeight;	            /* Camera height to the ground, unit cm, 100 ~ 300 */
    short		iFrontAxisOffset;	        /* Camere offset to the front-axis, unit cm, -300 ~ 300 */
    uint16_t	uiHeadOffset;	            /* Camere offset to the head of car, unit cm, 0 ~ 300 */
    uint16_t	uiLeftWheelOffset;	        /* Camere offset to the left-wheel, unit cm, 50 ~ 150 */
    uint16_t	uiRightWheelOffset;	        /* Camere offset to the right-wheel, unit cm, 50 ~ 150 */
    uint16_t	uiCrossPositionX;	        /* Cross position of x-axis, unit pixels, 360 ~ 1560[TBD] */
    uint16_t	uiCrossPositionY;	        /* Cross position of y-axis, unit pixels, 240 ~ 840[TBD] */
    uint16_t	BottomLineY;
} ;

#endif /* WiFiCMD_h */
