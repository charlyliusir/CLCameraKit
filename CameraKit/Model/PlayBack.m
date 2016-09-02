//
//  PlayBack.m
//  CLWiFiDemo
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "PlayBack.h"

@implementation PlayBack

- (instancetype)initWithData:(NSData *)responseData
{
    
    if (self = [super init]) {
        
        struct tCmdReqVideoPlayback placback;
        [responseData getBytes:&placback length:responseData.length];
        
        self.usFileIndex = @(placback.usFileIndex);
        self.usCommand = @(placback.usCommand);
        self.uiLocateTime = @(placback.uiLocateTime);
        
    }
    
    return  self;
    
}

- (NSData *)getDataInfo
{
    
    struct tCmdReqVideoPlayback placback;
    
    placback.usFileIndex  = [self.usFileIndex unsignedShortValue];
    placback.usCommand    = [self.usCommand unsignedShortValue];
    placback.uiLocateTime = [self.uiLocateTime unsignedIntValue];
    
    
    return [NSData dataWithBytes:&placback length:8];
    
}

@end
