//
//  CardFormat.m
//  CLWiFiDemo
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "CardFormat.h"

@implementation CardFormat

- (instancetype)initWithData:(NSData *)responseData
{
    
    if (self = [super init]) {
        
        uint8_t state;
        [responseData getBytes:&state length:1];
        
        self.formatstate = @(state);
        
    }
    
    return self;
    
}

@end
