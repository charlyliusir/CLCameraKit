//
//  NovatekCameraConst.h
//  Cheche
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#ifndef NovatekCameraConst_h
#define NovatekCameraConst_h

#define CUSTOM @"1"
/*
 *  Notify:通知
 */
#define WIFIAPP_RET_RECORD_STARTED 1
#define WIFIAPP_RET_RECORD_STOPPED 2

/*
 *  HFS upload file
 */
#define CYG_HFS_UPLOAD_OK 0
// upload file ok
#define CYG_HFS_UPLOAD_FAIL_FILE_EXIST -1
// upload file fail because of file exist
#define CYG_HFS_UPLOAD_FAIL_RECEIVE_ERROR -2
// receive data has some error
#define CYG_HFS_UPLOAD_FAIL_WRITE_ERROR -3
// write file has some error
#define CYG_HFS_UPLOAD_FAIL_FILENAME_EMPTY -4
// file name is emtpy

/*
 *  Command:命令
 */

/*--------------Photo----------------*/
#define WIFIAPP_CMD_CAPTURE @"1001"
#define WIFIAPP_CMD_CAPTURESIZE @"1002"
#define WIFIAPP_CMD_FREE_PIC_NUM @"1003"

/*--------------movie----------------*/
#define WIFIAPP_CMD_RECORD @"2001"
#define WIFIAPP_CMD_MOVIE_REC_SIZE @"2002"
#define WIFIAPP_CMD_CYCLIC_REC @"2003"
#define WIFIAPP_CMD_MOVIE_HDR @"2004"
#define WIFIAPP_CMD_MOVIE_EV @"2005"
#define WIFIAPP_CMD_MOTION_DET @"2006"
#define WIFIAPP_CMD_MOVIE_AUDIO @"2007"
#define WIFIAPP_CMD_DATEIMPRINT @"2008"
#define WIFIAPP_CMD_MAX_RECORD_TIME @"2009"
#define WIFIAPP_CMD_MOVIE_LIVEVIEW_SIZE @"2010"
#define WIFIAPP_CMD_MOVIE_GSENSOR_SENS @"2011"
#define WIFIAPP_CMD_SET_AUTO_RECORDING @"2012"
#define WIFIAPP_CMD_MOVIE_REC_BITRATE @"2013"
#define WIFIAPP_CMD_MOVIE_LIVEVIEW_BITRATE @"2014"
#define WIFIAPP_CMD_MOVIE_LIVEVIEW_START @"2015"
#define WIFIAPP_CMD_MOVIE_RECORDING_TIME @"2016"
#define WIFIAPP_CMD_MOVIE_TRIGGER_RAW @"2017"
#define WIFIAPP_CMD_MOVIE_GET_RAW @"2018"

/*--------------setup----------------*/
#define WIFIAPP_CMD_MODECHANGE @"3001"
#define WIFIAPP_CMD_QUERY @"3002"
#define WIFIAPP_CMD_SET_SSID @"3003"
#define WIFIAPP_CMD_SET_PASSPHRASE @"3004"
#define WIFIAPP_CMD_SET_DATE @"3005"
#define WIFIAPP_CMD_SET_TIME @"3006"
#define WIFIAPP_CMD_POWEROFF @"3007"
#define WIFIAPP_CMD_LANGUAGE @"3008"
#define WIFIAPP_CMD_TVFORMAT @"3009"
#define WIFIAPP_CMD_FORMAT @"3010"
#define WIFIAPP_CMD_SYSRESET @"3011"
#define WIFIAPP_CMD_VERSION @"3012"
#define WIFIAPP_CMD_FWUPDATE @"3013"
#define WIFIAPP_CMD_QUERY_CUR_STATUS @"3014"
#define WIFIAPP_CMD_FILELIST @"3015"
#define WIFIAPP_CMD_HEARTBEAT @"3016"
#define WIFIAPP_CMD_DISK_FREE_SPACE @"3017"
#define WIFIAPP_CMD_RECONNECT_WIFI @"3018"
#define WIFIAPP_CMD_GET_BATTERY @"3019"
#define WIFIAPP_CMD_NOTIFY_STATUS @"3020"
#define WIFIAPP_CMD_SAVE_MENUINFO @"3021"
#define WIFIAPP_CMD_GET_HW_CAP @"3022"
#define WIFIAPP_CMD_REMOVE_USER @"3023"
#define WIFIAPP_CMD_GET_CARD_STATUS @"3024"
#define WIFIAPP_CMD_GET_DOWNLOAD_URL @"3025"
#define WIFIAPP_CMD_GET_UPDATEFW_PATH @"3026"
#define WIFIAPP_CMD_UPLOAD_FILE @"3027"
#define WIFIAPP_CMD_LIST_CAMERE @"3029"

/*--------------playback----------------*/
#define WIFIAPP_CMD_THUMB @"4001"
#define WIFIAPP_CMD_SCREEN @"4002"
#define WIFIAPP_CMD_DELETE_ONE @"4003"
#define WIFIAPP_CMD_DELETE_ALL @"4004"

/*--------------POWEROFF SETTINGE----------------*/
typedef enum POWEROFF_SETTING{
    POWER_ON = 0,
    POWER_3MIN,
    POWER_5MIN,
    POWER_10MIN,
    POWEROFF_SETTING_MAX
}POWEROFF_SETTING;

/*--------------SETTINGE LANGUAGE----------------*/
typedef enum _LANGUAGE {
    LANG_EN,
    LANG_FR,
    LANG_ES,
    LANG_PO,
    LANG_DE,
    LANG_IT,
    LANG_SC,
    LANG_TC,
    LANG_RU,
    LANG_JP,
    LANG_ID_MAX
}_LANGUAGE;

/*--------------SETTINGE LANGUAGE----------------*/
typedef enum _TV_MODE
{
    TV_MODE_NTSC,
    TV_MODE_PAL,
    TV_MODE_ID_MAX
}_TV_MODE;

/*--------------BATTERY STATUS----------------*/
typedef enum BATTERY_STATUS{
    BATTERY_FULL = 0,
    BATTERY_MED,
    BATTERY_LOW,
    BATTERY_EMPTY,
    BATTERY_EXHAUSTED,
    BATTERY_CHARGE,
    BATTERY_STATUS_TOTAL_NUM
} BATTERY_STATUS;

/*--------------CARD STATUS----------------*/
typedef enum CARD_STATUS{
    CARD_UNKNOW = 0,
    CARD_REMOVED,
    CARD_INSERTED,
    CARD_LOCKED
} CARD_STATUS;

/*--------------Error code list----------------*/
typedef NS_ENUM(NSInteger, ERROR_LIST){
    ERROR_LIST_OK = 0, // 成功
    ERROR_LIST_RECORD_STATE_STARTED, // 开始录制
    ERROR_LIST_RECORD_STATE_STOPPED, // 停止录制
    ERROR_LIST_DISCONNECT, // 断开WI-FI连接
    ERROR_LIST_MIC_ON, // 麦克风开启
    ERROR_LIST_MIC_OFF, // 麦克风关闭
    ERROR_LIST_POWER_OFF, // 行车记录仪断开电源
    ERROR_LIST_REMOVE_BY_USER, // 行车记录仪断开,由于其他新用户连接
    ERROR_LIST_NOFILE = -1, // 没有文件
    ERROR_LIST_EXIF_ERR = -2, // 文件错误
    ERROR_LIST_NOBUF = -3, //
    ERROR_LIST_FILE_LOCKED = -4, // 只读文件
    ERROR_LIST_FILE_ERROR = -5, // 文件删除失败
    ERROR_LIST_DELETE_FAILED = -6, // 删除失败
    ERROR_LIST_MOVIE_FULL = -7, // 存储已满
    ERROR_LIST_MOVIE_WR_ERROR = -8,
    ERROR_LIST_MOVIE_SLOW = -9,
    ERROR_LIST_BATTERY_LOW = -10, // 电量过低
    ERROR_LIST_STORAGE_FULL = -11,
    ERROR_LIST_FOLDER_FULL = -12,
    ERROR_LIST_FAIL = -13,
    ERROR_LIST_FW_WRITE_CHK_ERR = -14,
    ERROR_LIST_FW_READ2_ERR = -15,
    ERROR_LIST_FW_WRITE_ERR = -16,
    ERROR_LIST_FW_READ_CHK_ERR = -17,
    ERROR_LIST_FW_READ_ERR = -18,
    ERROR_LIST_FW_INVALID_STG = -19,
    ERROR_LIST_FW_OFFSET = -20,
    ERROR_LIST_PAR_ERR = -21,
    ERROR_LIST_CMD_NOTFOUND = -256
};

#endif /* NovatekCameraConst_h */
