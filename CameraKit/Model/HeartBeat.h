//
//  HeartBet.h
//  CLWiFiDemo
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "BaseModel.h"

@interface HeartBeat : BaseModel

@property (nonatomic, strong)NSNumber * ucUIStatus;           /* 0-preview, 1-files, 2-config, 3-calibration. */
@property (nonatomic, strong)NSNumber * ucCycleRecordStatus;  /* 0-stop, 1-starting, 2-start, 3-stopping. */
@property (nonatomic, strong)NSNumber * ucEventRecordStatus;  /* 0-stop, 1-starting, 2-start, 3-stopping. */
@property (nonatomic, strong)NSNumber * ucr;  /* 0-stop, 1-starting, 2-start, 3-stopping. */
@property (nonatomic, strong)NSNumber * usCycleRecordTimer;   /* unit seconds */
@property (nonatomic, strong)NSNumber * usEventRecordTimer;   /* unit seconds */
@property (nonatomic, strong)NSNumber * ucAudioRecordStatus;  /* 0-close, 1-open */
@property (nonatomic, strong)NSNumber * ucSystemVolume;       /* unit %.(0-close all system audio playing) */
@property (nonatomic, strong)NSNumber * ucHdrStatus;          /* 0-close, 1-open, 2-error */
@property (nonatomic, strong)NSNumber * ucAdasStatus;         /* 0-not calibratted, 1-not init, 2-running, 3-calibrating. */
@property (nonatomic, strong)NSNumber * ucGSensorStatus;      /* 0-normal, 1-error. */
@property (nonatomic, strong)NSNumber * ucGpsStatus;          /* 0-normal, 1-disconnect, 2-signal error. */
@property (nonatomic, strong)NSNumber * ucBlueToothStatus;    /* 0-normal(close), 1-noraml(open-silence), 2-normal(open-transmitting), 3-error. */
@property (nonatomic, strong)NSNumber * ucSdcardStatus;       /* 0-normal, 1-not insert, 2-format error, 3-space too small, 4-write failed, 5-formatting. */
@property (nonatomic, strong)NSNumber * ucCameraStatus;       /* 0-normal, 1-disconnect. */
@property (nonatomic, strong)NSNumber * ucBatteryStatus;      /* 0-normal, 1-low, 2-too low */
@property (nonatomic, strong)NSNumber * ucExtPowerStatus;     /* 0-access, 1-not access. */
@property (nonatomic, strong)NSNumber * ucAudioChipStatus;    /* 0-normal, 1-error. */
@property (nonatomic, strong)NSNumber * ucSystemMode;         /* 0-normal,1-userkey,2-vehiclestop,3-shutdownprotect*/

- (NSData *)getSendData;
- (int)getCameraState;
- (int)getCameraSDCardState;

@end
