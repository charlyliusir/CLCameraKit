//
//  AITCameraCommand.m
//  WiFiCameraViewer
//
//  Created by Clyde on 2013/11/8.
//  Copyright (c) 2013年 a-i-t. All rights reserved.
//

#import "AITCameraCommand.h"
#import "CameraTools.h"
@interface AITCameraCommand()

@end

@implementation AITCameraCommand
static NSString *IP = @"192.72.1.1";
static NSString *CGI_PATH = @"/cgi-bin/Config.cgi" ;
static NSString *ACTION_SET = @"set" ;
static NSString *ACTION_GET = @"get" ;
static NSString *ACTION_DEL = @"del" ;
static NSString *ACTION_LS = @"dir" ;
static NSString *ACTION_PLAY = @"play";
static NSString *ACTION_SETCAMID = @"setcamid" ;


static NSString *PROPERTY = @"property";
static NSString *PROPERTY_NET = @"Net" ;
static NSString *PROPERTY_SSID = @"Net.WIFI_AP.SSID" ;
static NSString *PROPERTY_CAMERA_RTSP = @"Camera.Preview.RTSP.av" ;
static NSString *PROPERTY_ENCRYPTION_KEY = @"Net.WIFI_AP.CryptoKey" ;
static NSString *PROPERTY_DCIM = @"DCIM" ;
static NSString *PROPERTY_PHOTO = @"Photo";
static NSString *PROPERTY_VIDEO = @"Video" ;
static NSString *PROPERTY_QUERY_RECORD = @"Camera.Preview.MJPEG.status.record" ;
static NSString *PROPERTY_QUERY_PREVIEW_STATUS = @"Camera.Preview.*" ;
static NSString *PROPERTY_DATETIME = @"TimeSettings";
static NSString *PROPERTY_CAMERAID = @"Camera.Preview.Source.1.Camid";
static NSString *PROPERTY_FORMAT = @"SD0";
static NSString *PROPERTY_RESET = @"FactoryReset";
static NSString *PROPERTY_CHECK_SDCARD = @"Camera.Menu.SDIsExist";
static NSString *PROPERTY_SDCARD_TOTAL = @"Camera.Menu.SDTotalSpace";
static NSString *PROPERTY_SDCARD_FREE = @"Camera.Menu.SDFreeSpace";
static NSString *PROPERTY_Device_SSID = @"Net.WIFI_AP.SSID";
static NSString *PROPERTY_Device_PWD = @"Net.WIFI_AP.CryptoKey";
static NSString *PROPERTY_AUTO_RECORDING = @"Camera.Menu.MuteStatus";
static NSString *VALUE = @"value" ;
static NSString *COMMAND_FIND_CAMERA = @"findme" ;
static NSString *COMMAND_RESET = @"reset" ;
static NSString *COMMAND_CAPTURE = @"capture" ;
static NSString *COMMAND_RECORD = @"record" ;
static NSString *COMMAND_MUTE = @"mute" ;
static NSString *FORMAT = @"format" ;
static NSString *FORMAT_CAMERA = @"Camera" ;
static NSString *FORMAT_AVI = @"avi" ;
static NSString *FORMAT_JPEG = @"jpeg" ;
static NSString *FORMAT_ALL = @"all" ;
static NSString *FORMAT_MOV = @"mov" ;

static NSString *COUNT = @"count" ;
static int COUNT_MAX = 500 ;
static int COUNT_MIN = 1 ;

static NSString *FROM = @"from" ;

static NSString *CAMERA_SETTINGS = @"Camera.Menu.*";
static NSString *PROPERTY_AWB = @"AWB";
static NSString *PROPERTY_EV = @"EV";
static NSString *PROPERTY_FLICKER = @"Flicker";
static NSString *PROPERTY_FWversion = @"FWversion";
static NSString *PROPERTY_MTD = @"MTD";
static NSString *PROPERTY_IMAGERES = @"Imageres";
static NSString *PROPERTY_ISSTREAMING = @"IsStreaming";
static NSString *PROPERTY_VIDEORES= @"Videores";
//
static NSString *CAMERA_GetTIME = @"TimeSettings";
static NSString *CAMERA_SetTIME = @"Camera.Preview.MJPEG.TimeStamp";

+ (NSString *) PROPERTY_SSID
{
    return PROPERTY_SSID ;
}

+ (NSString *) PROPERTY_ENCRYPTION_KEY
{
    return PROPERTY_ENCRYPTION_KEY ;
}

+ (NSString *) PROPERTY_CAMERA_RTSP
{
    return PROPERTY_CAMERA_RTSP;
}

+ (NSString *) PROPERTY_QUERY_RECORD
{
    return PROPERTY_QUERY_RECORD;
}

+ (NSString *) PROPERTY_CAMERAID
{
    return PROPERTY_CAMERAID;
}

+ (NSString *) PROPERTY_awb
{
    return PROPERTY_AWB;
}

+ (NSString *) PROPERTY_ev
{
    return PROPERTY_EV;
}

+ (NSString *) PROPERTY_mtd;
{
    return PROPERTY_MTD;
}

+ (NSString *) PROPERTY_ImageRes
{
    return PROPERTY_IMAGERES;
}

+ (NSString *) PROPERTY_Flicker
{
    return PROPERTY_FLICKER;
}

+ (NSString *) PROPERTY_VideoRes
{
    return PROPERTY_VIDEORES;
}

+ (NSString *) PROPERTY_IsStreaming
{
    return PROPERTY_ISSTREAMING;
}

+ (NSString *) PROPERTY_FWversion
{
    return PROPERTY_FWversion;
}

+(NSString *) PROPERTY_DATETIME
{
    return PROPERTY_DATETIME;
}

+ (NSString *) PROPERTY_AUTOVOLUE
{
    return PROPERTY_AUTO_RECORDING;
}

+ (NSString *)PROPERTY_SDCARD_TOTAL
{
    return PROPERTY_SDCARD_TOTAL;
}

+ (NSString *)PROPERTY_SDCARD_FREE
{
    return PROPERTY_SDCARD_FREE;
}


+ (NSString *) CAMERA_IP
{
    return IP;
}



+ (NSString *) buildKeyValuePair:(NSString*) key Value:(NSString *) value
{
    if(value != nil)
        return [NSString stringWithFormat:@"%@=%@", key, value] ;
    else
        return [NSString stringWithFormat:@"%@", key] ;
}

+ (NSString *) buildProperty:(NSString *) property Value: (NSString *) value
{
    return [NSString stringWithFormat:@"%@&%@", [AITCameraCommand buildKeyValuePair:PROPERTY Value:property], [AITCameraCommand buildKeyValuePair:VALUE Value:value]] ;
}

+ (NSString *) buildProperty:(NSString *) property
{
    return [NSString stringWithFormat:@"%@", [AITCameraCommand buildKeyValuePair:PROPERTY Value:property]] ;
}

+ (NSString *) buildArgumentList: (NSArray *) arguments
{
    NSString *argumentList = @"" ;
    
    for (NSString *argument in arguments) {
    
        if (argument) {
        
            argumentList = [argumentList stringByAppendingFormat: @"&%@", argument] ;
        }
    }
    return argumentList ;
}

+ (NSString*) buildRequestUrl: (NSString *) path Action: (NSString *) action ArgumentList: (NSString *) argumentList
{
    NSString *cameraIp = [CameraTools getCameraAddress];

    NSString *url = [NSString stringWithFormat:@"http://%@%@?action=%@%@", cameraIp, path, action, argumentList];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString*) commandUpdateUrl: (NSString *) ssid EncryptionKey: (NSString *) encryptionKey
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_SSID Value: ssid]] ;
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_ENCRYPTION_KEY Value: encryptionKey]] ;
    
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_SET ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}

+ (NSString *) commandUpdateSSID:(NSString *)ssid
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_SSID Value: ssid]] ;
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_SET ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}
+ (NSString *) commandUpdateEncryptionKey:(NSString *)encryptionKey
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_ENCRYPTION_KEY Value: encryptionKey]] ;
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_SET ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}

+ (NSString*) commandFindCameraUrl
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_NET Value: COMMAND_FIND_CAMERA]] ;
    
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_SET ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}
//PROPERTY_CAMERAID
+ (NSString*) commandGetCameraidUrl
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_CAMERAID]] ;
    
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_GET ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}

+ (NSString*) commandSetCameraidUrl: (NSString *) camid
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_CAMERAID Value:camid]] ;
    
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_SETCAMID ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}

+ (NSString*) commandCameraSnapshotUrl
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_VIDEO Value: COMMAND_CAPTURE]] ;
    
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_SET ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}

+ (NSString*) commandCameraRecordUrl
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_VIDEO Value: COMMAND_RECORD]] ;
    
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_SET ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}

+ (NSString*) commandQueryPreviewStatusUrl
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_QUERY_PREVIEW_STATUS]] ;
    
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_GET ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}

+(NSString*) commandQuerySettings
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    [arguments addObject: [AITCameraCommand buildProperty:CAMERA_SETTINGS]] ;
    
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_GET ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
    
}

+ (NSString*) commandQueryCameraRecordUrl
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_QUERY_RECORD]] ;
    
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_GET ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}

+ (NSString*) commandReactivateUrl
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_NET Value: COMMAND_RESET]] ;
    
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_SET ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}

+ (NSString*) commandWifiInfoUrl
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_SSID]] ;
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_ENCRYPTION_KEY]] ;
    
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_GET ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}

+ (NSString*) commandListFileUrl: (int) count From: (int) from
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_PHOTO]] ;
    [arguments addObject: [AITCameraCommand buildKeyValuePair:FORMAT Value:FORMAT_ALL]] ;
    
    count = count > COUNT_MAX ? COUNT_MAX : count ;
    count = count < COUNT_MIN ? COUNT_MIN : count ;
    
    [arguments addObject: [AITCameraCommand buildKeyValuePair:COUNT Value:[NSString stringWithFormat:@"%d", count]]] ;
    [arguments addObject: [AITCameraCommand buildKeyValuePair:FROM Value:[NSString stringWithFormat:@"%d", from]]] ;

    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_LS ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}
+ (NSString*) commandListJPEGFileUrl: (int)count
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_PHOTO]] ;
    [arguments addObject: [AITCameraCommand buildKeyValuePair:FORMAT Value:FORMAT_JPEG]] ;
    
    count = count > COUNT_MAX ? COUNT_MAX : count ;
    count = count < COUNT_MIN ? COUNT_MIN : count ;
    
    [arguments addObject: [AITCameraCommand buildKeyValuePair:COUNT Value:[NSString stringWithFormat:@"%d", count]]] ;
    
    [arguments addObject: [AITCameraCommand buildKeyValuePair:FROM Value:@"0"]] ;
    
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_LS ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}
+ (NSString*) commandListMOVFileUrl: (int)count
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_DCIM]] ;
    [arguments addObject: [AITCameraCommand buildKeyValuePair:FORMAT Value:FORMAT_MOV]] ;
    
    count = count > COUNT_MAX ? COUNT_MAX : count ;
    count = count < COUNT_MIN ? COUNT_MIN : count ;
    
    [arguments addObject: [AITCameraCommand buildKeyValuePair:COUNT Value:[NSString stringWithFormat:@"%d", count]]] ;
    
    [arguments addObject: [AITCameraCommand buildKeyValuePair:FROM Value:@"0"]] ;
    
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_LS ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}
+ (NSString *) commandPlayBackFileUrl: (NSString *)fileName
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    [arguments addObject: [AITCameraCommand buildProperty:[NSString stringWithFormat:@"%@", fileName]]] ;
    
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_PLAY ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}


+ (NSString*) commandDelFileUrl: (NSString *) fileName
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    //[arguments addObject: [AITCameraCommand buildProperty:[NSString stringWithFormat:@"%@%@", PROPERTY_DCIM_DEL, fileName]]] ;
    [arguments addObject: [AITCameraCommand buildProperty:[NSString stringWithFormat:@"%@", fileName]]] ;
    
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_DEL ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}

+ (NSString*) commandSetVideoRes: (NSString*) nsRes
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_VIDEORES Value: [NSString stringWithFormat:@"%@", nsRes]]] ;
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_SET ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}

+ (NSString*) commandSetImageRes: (NSString*) nsRes
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_IMAGERES Value: [NSString stringWithFormat:@"%@", nsRes]]] ;
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_SET ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}
/*
 * Set Flicker
 * cgi-bin/Config.cgi?action=set&property=Flicker&value=[50Hz|60Hz]
 */
+ (NSString*) commandSetFlicker: (NSString*) nsHz
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_FLICKER Value: [NSString stringWithFormat:@"%@", nsHz]]] ;
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_SET ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}
/*
 * Set EV (exposure)
 * cgi-bin/Config.cgi?action=set&property=Exposure&value=[EVN200|EVN167|EVN133|EVN100|EVN067|EVN033|
 *                                                        EV0|
 *                                                        EVP033|EVP067|EVP100|EVP133|EVP167|EVP200]
 */
+ (NSString*) commandSetEV: (NSString*) nsEvlabel
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    [arguments addObject: [AITCameraCommand buildProperty:@"Exposure" Value: [NSString stringWithFormat:@"%@", nsEvlabel]]] ;
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_SET ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}
/*
 * Set MTD off, dull, middle, keen
 * cgi-bin/Config.cgi?action=set&property=MTD&value=[Off|Low|Middle|High]
 */
+ (NSString*) commandSetMTD: (NSString*) nsmtd
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_MTD Value: [NSString stringWithFormat:@"%@", nsmtd]]] ;
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_SET ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}
/*
 * Set AWB auto, daylight, cloudy
 * cgi-bin/Config.cgi?action=set&property=AWB&value=[Auto|Daylight|Cloudy]
 *
 * TODO: there are 7 items to select, but the UI onle support 3 items
 */
+ (NSString*) commandSetAWB: (NSString*) nsawb
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_AWB Value: [NSString stringWithFormat:@"%@", nsawb]]] ;
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_SET ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}

+ (NSString*) commandSetDateTime: (NSString *) datetime
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_DATETIME Value: datetime]] ;
    
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_SET ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;

}

/*
 * Get cammenu.xml
 * http://AIT.camera.dev/cdv/cammenu.xml
 */
+ (NSString*) commandGetCamMenu
{
    NSString *cameraIp = [CameraTools getCameraAddress] ;
    NSString *cammenu  = @"/cdv/cammenu.xml";
    
    NSString *url = [NSString stringWithFormat:@"http://%@%@", cameraIp, cammenu] ;
    return [[NSString alloc] initWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSString *) commandFormat
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_FORMAT Value: FORMAT]] ;
    
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_SET ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}

+ (NSString *) commandReset
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_RESET Value: FORMAT_CAMERA]] ;
    
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_SET ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}

+ (NSString *) commandCheckSDCard
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_CHECK_SDCARD]] ;
    
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_GET ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}

//+ (NSString *) commandGetSDCardInfo
//{
//    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
//    
//    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_SDCARD_INFO]] ;
//    
//    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_GET ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
//}

+ (NSString *) commandGetSDCardInfoTotal
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_SDCARD_TOTAL]] ;
    
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_GET ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}
+ (NSString *) commandGetSDCardInfoFree
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_SDCARD_FREE]] ;
    
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_GET ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}

+ (NSString *) commandSetAutoRecoding
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_VIDEO Value:COMMAND_MUTE]] ;
    
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_SET ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}

+ (NSString *) commandGetAutoRecoding
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init] ;
    
    [arguments addObject: [AITCameraCommand buildProperty:PROPERTY_AUTO_RECORDING]] ;
    
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_GET ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}

+ (NSDictionary*) buildResultDictionary:(NSString*)result
{
    NSMutableArray *keyArray;
    NSMutableArray *valArray;
    NSArray *lines;
        
    keyArray = [[NSMutableArray alloc] init];
    valArray = [[NSMutableArray alloc] init];
    lines = [result componentsSeparatedByString:@"\n"];
    for (NSString *line in lines) {
        NSArray *state = [line componentsSeparatedByString:@"="];
        if ([state count] != 2)
            continue;
        [keyArray addObject:[[state objectAtIndex:0] copy]];
        [valArray addObject:[[state objectAtIndex:1] copy]];
    }
    if ([keyArray count] == 0)
        return nil;
    return [NSDictionary dictionaryWithObjects:valArray forKeys:keyArray];
}

+ (NSString*) setProperty:(NSString*)prop Value:(NSString*)val
{
    NSMutableArray * arguments = [[NSMutableArray alloc] init];
    
    [arguments addObject: [AITCameraCommand buildProperty:prop Value: val]] ;
    
    return [AITCameraCommand buildRequestUrl:CGI_PATH Action: ACTION_SET ArgumentList: [AITCameraCommand buildArgumentList:arguments]] ;
}


@end
