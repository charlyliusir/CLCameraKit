//
//  PacketCMD.m
//  CLWiFiDemo
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "PacketCMD.h"
#import "FileDownload.h"

@implementation PacketCMD

+ (BaseModel *)packetdata:(struct message_info)info
{
    
    BaseModel *model = nil;
    NSString *modelName = @"BaseModel";
    
    NSData *infoData = [NSData dataWithBytes:info.data length:info.len-2];
    
    switch (info.cmd) {
        case CONNECTION:
        {
            switch (info.sub)
            {
                case HANDSHAKE:
                {
                    modelName = @"HandShake";
                }
                    
                    break;
                case HEARTBEAT:
                {
                    modelName = @"HeartBeat";
                }
                    
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case UI_CONTROL:
        {
            modelName = @"BaseModel";
        }
            break;
        case FAST_CONTROL:
        {
            switch (info.sub) {
                case FAST_CYCLE_RECORD:
                {
                    modelName = @"BaseModel";
                }
                    break;
                case FAST_EMERGE:
                {
                    modelName = @"Emerge";
                }
                    break;
                case FAST_PHOTOGRAPHY:
                {
                    modelName = @"Photography";
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case FILE_CONTROL:
        {
            
            switch (info.sub) {
                case GET_SDCARD_STATUS:
                {
                    modelName = @"CardState";
                }
                    break;
                case GET_FILE_LIST:
                {
                    modelName = @"FileList";
                }
                    break;
                case REQ_FILE_DOWNLOAD:
                {
                    modelName = @"FileDownload";
                }
                    break;
                default:
                {
                    modelName = @"BaseModel";
                }
                    break;
            }
            
        }
            break;
        case CONFIG_GET:
        {
            switch (info.sub) {
                case GET_RECORD_CFG:
                {
                    modelName = @"RecordConfigure";
                }
                    break;
                case GET_WIFI_CFG:
                {
                    modelName = @"WiFiConfigure";
                }
                    break;
                case GET_AUDIO_PLAY_CFG:
                {
                    modelName = @"AudioPlayConfigure";
                }
                    break;
                case GET_GSENSOR_CFG:
                {
                    modelName = @"GsensorConfigure";
                }
                    break;
                case GET_ADAS_CFG:
                {
                    modelName = @"AdasConfigure";
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case CONFIG_SET:
        {
            switch (info.sub) {
                case SDCARD_FORMATTING:
                {
                    modelName = @"CardFormat";
                }
                    break;
                default:
                {
                    modelName = @"BaseModel";
                }
                    break;
            }
        }
            break;
        case CAMERA_CALI:
        {
            switch (info.sub) {
                case GET_CALI_PARAM:
                {
                    modelName = @"CaliConfigure";
                }
                    break;
                case EXECUTE_CALIBRATION:
                {
                    modelName = @"BaseModel";
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            //        case UPGRADE:
            //            break;
        default:
            break;
    }
    
    model = [[NSClassFromString(modelName) alloc] initWithData:infoData];
    
    return model;
    
}

@end
