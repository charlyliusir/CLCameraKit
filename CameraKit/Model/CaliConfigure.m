//
//  CaliConfigure.m
//  CLWiFiDemo
//
//  Created by apple on 16/6/13.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "CaliConfigure.h"

@implementation CaliConfigure

- (instancetype)initWithData:(NSData *)responseData
{
    
    if (self = [super init]) {
        
        struct tCmdExecuteCalibration calibration;
        [responseData getBytes:&calibration length:responseData.length];
        
        self.uiVehicleID = @(calibration.uiVehicleID);
        self.uiCameraHeight = @(calibration.uiCameraHeight);
        self.iFrontAxisOffset = @(calibration.iFrontAxisOffset);
        self.uiHeadOffset = @(calibration.uiHeadOffset);
        self.uiLeftWheelOffset = @(calibration.uiLeftWheelOffset);
        self.uiRightWheelOffset = @(calibration.uiRightWheelOffset);
        self.uiCrossPositionX = @(calibration.uiCrossPositionX);
        self.uiCrossPositionY = @(calibration.uiCrossPositionY);
        self.BottomLineY = @(calibration.BottomLineY);
    }
    
    return self;
    
}


- (NSData *)getDataInfo
{
    NSMutableData *data = [[NSMutableData alloc] init];
    struct tCmdExecuteCalibration calibration;
    
    calibration.uiVehicleID = [self.uiVehicleID unsignedShortValue];
    calibration.uiCameraHeight = [self.uiCameraHeight unsignedShortValue];
    calibration.iFrontAxisOffset  = [self.iFrontAxisOffset shortValue];
    calibration.uiHeadOffset = [self.uiHeadOffset unsignedShortValue];
    calibration.uiLeftWheelOffset = [self.uiLeftWheelOffset unsignedShortValue];
    calibration.uiRightWheelOffset = [self.uiRightWheelOffset unsignedShortValue];
    calibration.uiCrossPositionX = [self.uiCrossPositionX unsignedShortValue];
    calibration.uiCrossPositionY = [self.uiCrossPositionY unsignedShortValue];
    calibration.BottomLineY = [self.BottomLineY unsignedShortValue];
    
    [data appendBytes:&calibration.uiVehicleID length:2];
    [data appendBytes:&calibration.uiCameraHeight length:2];
    [data appendBytes:&calibration.iFrontAxisOffset length:2];
    [data appendBytes:&calibration.uiHeadOffset length:2];
    [data appendBytes:&calibration.uiLeftWheelOffset length:2];
    [data appendBytes:&calibration.uiRightWheelOffset length:2];
    [data appendBytes:&calibration.uiCrossPositionX length:2];
    [data appendBytes:&calibration.uiCrossPositionY length:2];
    [data appendBytes:&calibration.BottomLineY length:2];
    
    return data;
    
}
@end
