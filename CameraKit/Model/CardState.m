//
//  CardState.m
//  CLWiFiDemo
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "CardState.h"

@implementation CardState

- (instancetype)initWithData:(NSData *)responseData
{
    
    if (self = [super init]) {
        
        
        struct tAckGetSdcardStatus cardstatus;
        [responseData getBytes:&cardstatus length:responseData.length];
        
        self.ucSdcardStatus = @(cardstatus.ucSdcardStatus);
        self.ucSdcardFormat = @(cardstatus.ucSdcardFormat);
        self.usReserved = @(cardstatus.usReserved);
        self.uiTotal = @(cardstatus.uiTotal);
        self.uiTotalUsed = @(cardstatus.uiTotalUsed);
        self.uiTotalFree = @(cardstatus.uiTotalFree);
        self.uiCycleUsed = @(cardstatus.uiCycleUsed);
        self.uiEventUsed = @(cardstatus.uiEventUsed);
        self.uiImageUsed = @(cardstatus.uiImageUsed);
        self.ucCyclePercent = @(cardstatus.ucCyclePercent);
        self.ucEventPercent = @(cardstatus.ucEventPercent);
        self.ucImagePercent = @(cardstatus.ucImagePercent);
    }
    
    return self;
    
}

- (NSData *)getDataInfo
{
    NSMutableData *data = [[NSMutableData alloc] init];
    struct tAckGetSdcardStatus cardstatus;
    cardstatus.ucSdcardStatus = [self.ucSdcardStatus unsignedCharValue];
    cardstatus.ucSdcardFormat = [self.ucSdcardFormat unsignedCharValue];
    cardstatus.usReserved = [self.usReserved unsignedShortValue];
    cardstatus.uiTotal = [self.uiTotal unsignedIntValue];
    cardstatus.uiTotalUsed = [self.uiTotalUsed unsignedIntValue];
    cardstatus.uiTotalFree = [self.uiTotalFree unsignedIntValue];
    cardstatus.uiCycleUsed = [self.uiCycleUsed unsignedIntValue];
    cardstatus.uiEventUsed = [self.uiEventUsed unsignedIntValue];
    cardstatus.uiImageUsed = [self.uiImageUsed unsignedIntValue];
    cardstatus.ucCyclePercent = [self.ucCyclePercent unsignedCharValue];
    cardstatus.ucEventPercent = [self.ucEventPercent unsignedCharValue];
    cardstatus.ucImagePercent = [self.ucImagePercent unsignedCharValue];
    
    [data appendBytes:&cardstatus.ucSdcardStatus length:1];
    [data appendBytes:&cardstatus.ucSdcardFormat length:1];
    [data appendBytes:&cardstatus.usReserved length:2];
    [data appendBytes:&cardstatus.uiTotal length:4];
    [data appendBytes:&cardstatus.uiTotalUsed length:4];
    [data appendBytes:&cardstatus.uiTotalFree length:4];
    [data appendBytes:&cardstatus.uiCycleUsed length:4];
    [data appendBytes:&cardstatus.uiEventUsed length:4];
    [data appendBytes:&cardstatus.uiImageUsed length:4];
    [data appendBytes:&cardstatus.ucCyclePercent length:1];
    [data appendBytes:&cardstatus.ucEventPercent length:1];
    [data appendBytes:&cardstatus.ucImagePercent length:1];
    
    
    return data;
    
}

@end
