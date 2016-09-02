//
//  Emerge.m
//  CLWiFiDemo
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "Emerge.h"

@implementation Emerge

- (instancetype)initWithData:(NSData *)responseData
{
    self = [super initWithData:responseData];
    
    if (self) {
        
        uint16_t fileindex;
        [responseData getBytes:&fileindex range:NSMakeRange(4, 2)];
        
        self.fileindex = @(fileindex);
        
    }
    
    return self;
}

- (NSData *)getDataInfo
{
    
    uint16_t index = [self.fileindex unsignedShortValue];
    NSMutableData *data = [super getDataInfo].mutableCopy;
    [data appendBytes:&index length:2];
    
    return data;
}

@end
