//
//  AdasConfigure.m
//  CLWiFiDemo
//
//  Created by apple on 16/6/13.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "AdasConfigure.h"

@implementation AdasConfigure

- (instancetype)initWithData:(NSData *)responseData
{
    
    if (self = [super init]) {
        
        struct tAckGetAdasCfg adascfg;
        [responseData getBytes:&adascfg length:responseData.length];
        
        self.ucAdasEnable = @(adascfg.ucAdasEnable);
        self.ucLdwSensitivity = @(adascfg.ucLdwSensitivity);
        self.ucHwwSensitivity = @(adascfg.ucHwwSensitivity);
        self.ucFcwSensitivity = @(adascfg.ucFcwSensitivity);
        self.ucVehicleStartEnable = @(adascfg.ucVehicleStartEnable);
        
    }
    
    return self;
    
}

- (NSData *)getDataInfo
{
    
    struct tAckGetAdasCfg adascfg;
    
    adascfg.ucAdasEnable = [self.ucAdasEnable unsignedCharValue];
    adascfg.ucLdwSensitivity = [self.ucLdwSensitivity unsignedCharValue];
    adascfg.ucHwwSensitivity = [self.ucHwwSensitivity unsignedCharValue];
    adascfg.ucFcwSensitivity = [self.ucFcwSensitivity unsignedCharValue];
    adascfg.ucVehicleStartEnable = [self.ucVehicleStartEnable unsignedCharValue];
    
    return [NSData dataWithBytes:&adascfg length:5];
    
}

@end
