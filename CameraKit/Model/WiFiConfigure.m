//
//  WiFiConfigure.m
//  CLWiFiDemo
//
//  Created by apple on 16/6/13.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "WiFiConfigure.h"

@implementation WiFiConfigure

- (instancetype)initWithData:(NSData *)responseData
{
    
    if (self = [super init]) {
        
        struct tAckGetWifiCfg wificgf;
        [responseData getBytes:&wificgf length:responseData.length];
        
        NSData *dataSSID = [NSData dataWithBytes:&wificgf.ucSSID length:50];
        NSData *dataPSWD = [NSData dataWithBytes:&wificgf.ucPSWD length:50];
        self.ucSSID = [[NSString alloc] initWithData:dataSSID encoding:NSUTF8StringEncoding];
        self.ucPSWD = [[NSString alloc] initWithData:dataPSWD encoding:NSUTF8StringEncoding];
        
    }
    
    return self;
    
}


- (NSData *)getDataInfo
{
//    NSArray *pswdArray = [self.ucPSWD characterAtIndex:<#(NSUInteger)#>]
    struct tAckGetWifiCfg wificgf;
    for (int i = 0; i < self.ucPSWD.length; i++) {
        wificgf.ucPSWD[i] = [self.ucPSWD characterAtIndex:i];
    }
    for (int i = 0; i < self.ucSSID.length; i++) {
        wificgf.ucSSID[i] = [self.ucSSID characterAtIndex:i];
    }
    
    NSMutableData *mudata = [[NSMutableData alloc] init];
    
    [mudata appendBytes:&wificgf length:100];
    
    return mudata;
    
}

@end
