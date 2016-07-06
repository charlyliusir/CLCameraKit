
//
//  NSString+Empty.m
//  CameraKitDemo
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "NSString+CLEmpty.h"

@implementation NSString (CLEmpty)

- (BOOL)isNotEmpty
{
    
    if (self==NULL) {
        return NO;
    }
    
    if ([self isEqualToString:@""]) {
        return NO;
    }
    
    if ([self isEqualToString:@" "]) {
        return NO;
    }
    
    if ([self isEqualToString:@"\n"]) {
        return NO;
    }
    if ([self containsString:@"\n    "]) {
        return NO;
    }
    
    return YES;
    
}

@end
