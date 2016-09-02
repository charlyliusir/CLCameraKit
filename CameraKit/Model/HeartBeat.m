//
//  HeartBet.m
//  CLWiFiDemo
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "HeartBeat.h"

@implementation HeartBeat

- (instancetype)initWithData:(NSData *)responseData
{
    
    if (self = [super init]) {
        
        struct tAckHeartBeat heartbeat;
        [responseData getBytes:&heartbeat length:responseData.length];
        
        self.ucUIStatus = @(heartbeat.ucUIStatus);
        self.ucCycleRecordStatus = @(heartbeat.ucCycleRecordStatus);
        self.ucEventRecordStatus = @(heartbeat.ucEventRecordStatus);
        self.ucr = @(heartbeat.ucr);
        self.usCycleRecordTimer = @(heartbeat.usCycleRecordTimer);
        self.usEventRecordTimer = @(heartbeat.usEventRecordTimer);
        self.ucAudioRecordStatus = @(heartbeat.ucAudioRecordStatus);
        self.ucSystemVolume = @(heartbeat.ucSystemVolume);
        self.ucHdrStatus = @(heartbeat.ucHdrStatus);
        self.ucAdasStatus = @(heartbeat.ucAdasStatus);
        self.ucGSensorStatus = @(heartbeat.ucGSensorStatus);
        self.ucGpsStatus = @(heartbeat.ucGpsStatus);
        self.ucBlueToothStatus = @(heartbeat.ucBlueToothStatus);
        self.ucSdcardStatus = @(heartbeat.ucSdcardStatus);
        self.ucCameraStatus = @(heartbeat.ucCameraStatus);
        self.ucBatteryStatus = @(heartbeat.ucBatteryStatus);
        self.ucExtPowerStatus = @(heartbeat.ucExtPowerStatus);
        self.ucAudioChipStatus = @(heartbeat.ucAudioChipStatus);
        self.ucSystemMode = @(heartbeat.ucSystemMode);
        
    }
    
    return self;
    
}


- (NSData *)getDataInfo
{
    
    struct tAckHeartBeat heartbeat;
    
    heartbeat.ucUIStatus = [self.ucUIStatus unsignedCharValue];
    heartbeat.ucCycleRecordStatus = [self.ucCycleRecordStatus unsignedCharValue];
    heartbeat.ucEventRecordStatus = [self.ucEventRecordStatus unsignedCharValue];
    heartbeat.ucr = [self.ucr unsignedCharValue];
    heartbeat.usCycleRecordTimer = [self.usCycleRecordTimer unsignedShortValue];
    heartbeat.usEventRecordTimer = [self.usEventRecordTimer unsignedShortValue];
    heartbeat.ucAudioRecordStatus = [self.ucAudioRecordStatus unsignedCharValue];
    heartbeat.ucSystemVolume = [self.ucSystemVolume unsignedCharValue];
    heartbeat.ucHdrStatus = [self.ucHdrStatus unsignedCharValue];
    heartbeat.ucAdasStatus = [self.ucAdasStatus unsignedCharValue];
    heartbeat.ucGSensorStatus = [self.ucGSensorStatus unsignedCharValue];
    heartbeat.ucGpsStatus = [self.ucGpsStatus unsignedCharValue];
    heartbeat.ucBlueToothStatus = [self.ucBlueToothStatus unsignedCharValue];
    heartbeat.ucSdcardStatus = [self.ucSdcardStatus unsignedCharValue];
    heartbeat.ucCameraStatus = [self.ucCameraStatus unsignedCharValue];
    heartbeat.ucBatteryStatus = [self.ucBatteryStatus unsignedCharValue];
    heartbeat.ucExtPowerStatus = [self.ucExtPowerStatus unsignedCharValue];
    heartbeat.ucAudioChipStatus = [self.ucAudioChipStatus unsignedCharValue];
    heartbeat.ucSystemMode = [self.ucSystemMode unsignedCharValue];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    [data appendBytes:&heartbeat.ucUIStatus length:1];
    [data appendBytes:&heartbeat.ucCycleRecordStatus length:1];
    [data appendBytes:&heartbeat.ucEventRecordStatus length:1];
    [data appendBytes:&heartbeat.ucr length:1];
    [data appendBytes:&heartbeat.usCycleRecordTimer length:2];
    [data appendBytes:&heartbeat.usEventRecordTimer length:2];
    [data appendBytes:&heartbeat.ucAudioRecordStatus length:1];
    [data appendBytes:&heartbeat.ucSystemVolume length:1];
    [data appendBytes:&heartbeat.ucHdrStatus length:1];
    [data appendBytes:&heartbeat.ucAdasStatus length:1];
    [data appendBytes:&heartbeat.ucGSensorStatus length:1];
    [data appendBytes:&heartbeat.ucGpsStatus length:1];
    [data appendBytes:&heartbeat.ucBlueToothStatus length:1];
    [data appendBytes:&heartbeat.ucSdcardStatus length:1];
    [data appendBytes:&heartbeat.ucCameraStatus length:1];
    [data appendBytes:&heartbeat.ucBatteryStatus length:1];
    [data appendBytes:&heartbeat.ucExtPowerStatus length:1];
    [data appendBytes:&heartbeat.ucAudioChipStatus length:1];
    [data appendBytes:&heartbeat.ucSystemMode length:1];
 
    return data;
    
}

- (int)getCameraState
{
    if ([self.ucCameraStatus isEqualToNumber:@(0)]) {
        if ([self.ucCycleRecordStatus isEqualToNumber:@(0)]||[self.ucCycleRecordStatus isEqualToNumber:@(3)]) {
            return 1;
        }else{
            return 2;
        }
    }else if ([self.ucCameraStatus isEqualToNumber:@(1)]){
        return 0;
    }else{
        return 0;
    }
}
- (int)getCameraSDCardState
{
    if ([self.ucSdcardStatus isEqualToNumber:@(0)]) {
        return 2;
    }else{
        return 1;
    }
}

- (NSData *)getSendData
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd-HH-mm-ss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSArray *dateArr = [dateString componentsSeparatedByString:@"-"];
    
    struct tCmdHeartBeat heartBeat;
    
    heartBeat.ucUIRequest = 0;
    heartBeat.reserved[0] = 0;
    heartBeat.reserved[1] = 0;
    heartBeat.reserved[2] = 0;
    heartBeat.year   = [@([dateArr[0] intValue]) unsignedShortValue];
    heartBeat.month  = [@([dateArr[1] intValue]) unsignedShortValue];
    heartBeat.day    = [@([dateArr[2] intValue]) unsignedShortValue];
    heartBeat.hour   = [@([dateArr[3] intValue]) unsignedShortValue];
    heartBeat.minute = [@([dateArr[4] intValue]) unsignedShortValue];
    heartBeat.second = [@([dateArr[5] intValue]) unsignedShortValue];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    [data appendBytes:&heartBeat.ucUIRequest length:1];
    [data appendBytes:&heartBeat.reserved length:3];
    [data appendBytes:&heartBeat.year length:2];
    [data appendBytes:&heartBeat.month length:2];
    [data appendBytes:&heartBeat.day length:2];
    [data appendBytes:&heartBeat.hour length:2];
    [data appendBytes:&heartBeat.minute length:2];
    [data appendBytes:&heartBeat.second length:2];
    
    return data;
}

@end
