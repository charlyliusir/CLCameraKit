//
//  GsensorConfigure.m
//  CLWiFiDemo
//
//  Created by apple on 16/6/13.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "GsensorConfigure.h"

@implementation GsensorConfigure

- (instancetype)initWithData:(NSData *)responseData
{
    
    if (self = [super init]) {
        
        struct tAckGetGsensorCfg gsensorcfg;
        [responseData getBytes:&gsensorcfg length:responseData.length];
        
        self.ucWakeupSensitivity = @(gsensorcfg.ucWakeupSensitivity);
        self.ucEmergeSensitivity = @(gsensorcfg.ucEmergeSensitivity);
        
    }
    
    return self;
    
}

- (NSData *)getDataInfo
{
    
    struct tAckGetGsensorCfg gsensorcfg;
    
    gsensorcfg.ucWakeupSensitivity = [self.ucWakeupSensitivity unsignedCharValue];
    gsensorcfg.ucEmergeSensitivity = [self.ucEmergeSensitivity unsignedCharValue];
    
    return [NSData dataWithBytes:&gsensorcfg length:2];
}

@end
