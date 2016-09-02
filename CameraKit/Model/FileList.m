//
//  FileList.m
//  WiFiDemo
//
//  Created by apple on 16/4/28.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "FileList.h"

@implementation FileList

- (instancetype)initWithData:(NSData *)responseData
{
    
    if (self = [super init]) {
        
        NSMutableArray *filelistArray = [[NSMutableArray alloc] init];
        
        uint32_t totalIndex;
        [responseData getBytes:&totalIndex length:4];
        
        self.totalIndex = @(totalIndex);
        
        while (totalIndex!=0) {
            
            NSData *filedata = [responseData subdataWithRange:NSMakeRange(4+12*filelistArray.count, 12)];
            ADNSCameraFile *file = [[ADNSCameraFile alloc] initWithData:filedata];
            [filelistArray addObject:file];
            
            totalIndex --;
            
        }
        
        self.filelist = filelistArray.copy;
        
    }
    
    return self;
    
}

- (NSData *)getDataInfo
{
    
    NSMutableData *data = [[NSMutableData alloc] init];
    
    uint32_t total = 10;
    
    [data appendBytes:&total length:4];
    
    for (int i = 0; i < total; i ++) {
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        uint16_t index = i+1;
        uint8_t type = i%2==0?0:1;
        uint8_t attr = i%2==0?1:0;
        uint32_t size = 875421;
        uint32_t date = time;
        
        [data appendBytes:&index length:2];
        [data appendBytes:&type length:1];
        [data appendBytes:&attr length:1];
        [data appendBytes:&size length:4];
        [data appendBytes:&date length:4];
    }
    
    return data.copy;
}

@end
