//
//  RecordConfigure.m
//  CLWiFiDemo
//
//  Created by apple on 16/6/13.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "RecordConfigure.h"

@implementation RecordConfigure

- (instancetype)initWithData:(NSData *)responseData
{
    
    if (self = [super init]) {
        
        struct tAckGetRecordCfg recordcgf;
        [responseData getBytes:&recordcgf length:responseData.length];
        
        self.ucResolution = @(recordcgf.ucResolution);
        self.ucDuration = @(recordcgf.ucDuration);
        self.ucAudioRecordEnable = @(recordcgf.ucAudioRecordEnable);
        self.ucHdrEnable = @(recordcgf.ucHdrEnable);
        self.ucOsdEnable = @(recordcgf.ucOsdEnable);
        
    }
    
    return  self;
    
}

- (NSData *)getDataInfo
{
    struct tAckGetRecordCfg recordcgf;
    recordcgf.ucResolution = [self.ucResolution unsignedCharValue];
    recordcgf.ucDuration = [self.ucDuration unsignedCharValue];
    recordcgf.ucAudioRecordEnable = [self.ucAudioRecordEnable unsignedCharValue];
    recordcgf.ucHdrEnable = [self.ucHdrEnable unsignedCharValue];
    recordcgf.ucOsdEnable = [self.ucOsdEnable unsignedCharValue];
    
    return [NSData dataWithBytes:&recordcgf length:5];
}

@end
