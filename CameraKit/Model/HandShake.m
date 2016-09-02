//
//  HandShack.m
//  CLWiFiDemo
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "HandShake.h"

@implementation HandShake

- (instancetype)initWithData:(NSData *)responseData
{
    
    if (self = [super init]) {
        
        struct tCmdHeartBeat handshake;
        [responseData getBytes:&handshake length:responseData.length];
        
        self.TpVersion = @(handshake.ucUIRequest);
        
    }
    
    return self;
    
}

- (NSData *)getDataInfo
{
    uint8_t version = [self.TpVersion unsignedCharValue];
    
    return [NSData dataWithBytes:&version length:1];
}

+ (NSData *)sendTpVersion:(NSString *)tpVersion
{
    return [NSData convetWithString:tpVersion];
}

@end
