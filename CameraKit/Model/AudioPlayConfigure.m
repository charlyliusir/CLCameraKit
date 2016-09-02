//
//  AudioPlayConfigure.m
//  CLWiFiDemo
//
//  Created by apple on 16/6/13.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "AudioPlayConfigure.h"

@implementation AudioPlayConfigure

- (instancetype)initWithData:(NSData *)responseData
{
    
    if (self = [super init]) {
        
        struct tAckGetAudioPlayCfg audioplaycfg;
        [responseData getBytes:&audioplaycfg length:responseData.length];
        
        self.ucSystemVolume = @(audioplaycfg.ucSystemVolume);
        self.ucPowerStateEnable = @(audioplaycfg.ucPowerStateEnable);
        self.ucEventRecordEnable = @(audioplaycfg.ucEventRecordEnable);
        self.ucPhotographyEnable = @(audioplaycfg.ucPhotographyEnable);
        self.ucAdasWarningEnable = @(audioplaycfg.ucAdasWarningEnable);
        
    }
    
    return self;
    
}

- (NSData *)getDataInfo
{
    
    struct tAckGetAudioPlayCfg audioplaycfg;
    
    audioplaycfg.ucSystemVolume = [self.ucSystemVolume unsignedCharValue];
    audioplaycfg.ucPowerStateEnable = [self.ucPowerStateEnable unsignedCharValue];
    audioplaycfg.ucEventRecordEnable = [self.ucEventRecordEnable unsignedCharValue];
    audioplaycfg.ucPhotographyEnable = [self.ucPhotographyEnable unsignedCharValue];
    audioplaycfg.ucAdasWarningEnable = [self.ucAdasWarningEnable unsignedCharValue];
    
    return [NSData dataWithBytes:&audioplaycfg length:5];
    
}

@end
