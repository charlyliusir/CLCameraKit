//
//  Photography.m
//  CLWiFiDemo
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "Photography.h"

@implementation Photography

- (instancetype)initWithData:(NSData *)responseData
{
    self = [super initWithData:responseData];
    
    if (self) {
        
        struct tCmdReqTakePhoto takePhoto;
        [responseData getBytes:&takePhoto range:NSMakeRange(4, 6)];
        
        self.fileindex = @(takePhoto.usFileIndex);
        self.filedate  = @(takePhoto.uiDate);
        
    }
    
    return self;
}

- (NSData *)getDataInfo
{
    
    uint16_t index = [self.fileindex unsignedShortValue];
    uint32_t uidate= [self.filedate unsignedIntValue];
    NSMutableData *data = [super getDataInfo].mutableCopy;
    [data appendBytes:&index length:2];
    [data appendBytes:&uidate length:4];
    
    return data;
}

@end
