//
//  AudioPlayConfigure.h
//  CLWiFiDemo
//
//  Created by apple on 16/6/13.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "BaseModel.h"

@interface AudioPlayConfigure : BaseModel

@property (nonatomic, strong)NSNumber * ucSystemVolume;	      /* unit % (0-close all system audio playing) */
@property (nonatomic, strong)NSNumber * ucPowerStateEnable;	  /* 0-disable, 1-enable. */
@property (nonatomic, strong)NSNumber * ucEventRecordEnable;  /* 0-disable, 1-enable. */
@property (nonatomic, strong)NSNumber * ucPhotographyEnable;  /* 0-disable, 1-enable. */
@property (nonatomic, strong)NSNumber * ucAdasWarningEnable;  /* 0-disable, 1-enable. */

@end
