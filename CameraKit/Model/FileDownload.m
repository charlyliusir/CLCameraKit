//
//  FileDownload.m
//  WiFiDemo
//
//  Created by apple on 16/4/28.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "FileDownload.h"

@implementation FileDownload

- (instancetype)initWithData:(NSData *)responseData
{
    
    if (self = [super initWithData:responseData]) {
        
        struct tAckReqFileDownload download;
        [[responseData subdataWithRange:NSMakeRange(4, responseData.length-4)] getBytes:&download length:responseData.length-4];
        
        // revice property
        self.uiTotalSize   = @(download.uiTotalSize);
        self.uiCurrentSize = @(download.uiCurrentSize);
        self.uiRemainSize  = @(download.uiRemainSize);
        self.uiDataPosition= @(download.uiDataPosition);
        self.ucData = [NSData dataWithBytes:&download.ucData length:download.uiCurrentSize];
        
    }
    
    return self;
}

- (NSData *)getDataInfo
{
    
    NSMutableData *data = [[NSMutableData alloc] init];
    
    uint32_t errorCode = 00000000;
    uint32_t totalSize = [self.uiTotalSize unsignedIntValue];
    uint32_t currentSize = [self.uiCurrentSize unsignedIntValue];
    uint32_t remainSize = [self.uiRemainSize unsignedIntValue];
    uint32_t positionSize = [self.uiDataPosition unsignedIntValue];
    uint32_t datas = 00000000;
    
    [data appendBytes:&errorCode length:4];
    [data appendBytes:&totalSize length:4];
    [data appendBytes:&currentSize length:4];
    [data appendBytes:&remainSize length:4];
    [data appendBytes:&positionSize length:4];
    [data appendBytes:&datas length:4];
    
    return data.copy;
    
}

- (NSData *)getDownloadRequest
{
    NSMutableData *data = [[NSMutableData alloc] init];
    
    uint32_t fileIndex = [self.usFileIndex unsignedIntValue];
    uint32_t fileType  = [self.usDataType unsignedIntValue];
    uint32_t positionSize = [self.uiDataPosition unsignedIntValue];
    
    [data appendBytes:&fileIndex length:2];
    [data appendBytes:&fileType length:2];
    [data appendBytes:&positionSize length:4];
    
    return data.copy;
}

@end
