//
//  CRC32Data.h
//  WiFiDemo
//
//  Created by apple on 16/6/6.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRC32Data : NSObject

+ (UInt32)getCRC32Data:(uint8_t const *)pucMemAddr Len:(uint32_t)uiMenLen oldCrc32:(uint32_t)uiOldCrc32;

@end
