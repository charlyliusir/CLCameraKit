//
//  NSData+Convert.m
//  CLWiFiDemo
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "NSData+Convert.h"

@implementation NSData (Convert)
+ (NSData *)convetWithString:(NSString *)string
{
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSArray *bytes = [string componentsSeparatedByString:@" "];
    
    for (NSString *byte in bytes) {
        
        unsigned int i;
        
        NSScanner *scanner = [[NSScanner alloc] initWithString:byte];
        
        [scanner scanHexInt:&i];
        
        [data appendBytes:&i length:sizeof(i)];
        
    }
    
    return data.copy;
}
@end
