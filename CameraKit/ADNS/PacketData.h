//
//  PacketData.h
//  WiFiDemo
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PacketCMD.h"
static Byte MessageHEAD[2];
static Byte MessageCMD;
static Byte MessageSUB;
static Byte MessageLEN[4];
static NSData * MessageData;
static NSData * CrcData;
static NSData * MessageCRCData;

@interface PacketData : NSObject

+ (uint32_t)CRC32Data:(NSData *)CrcData;
+ (BaseModel *)unPacket:(NSData *)data;
+ (NSData *)CommandWithCMD:(Byte)cmd SUB:(Byte)sub DATA:(NSData *)data;

+ (NSData *)CommandWithCMDs:(Byte)cmd SUB:(Byte)sub DATA:(NSData *)data;
//- (NSData *)CommandWithType:(Byte)type SubType:(Byte)subType MessageData:(Byte[255])data;
+ (BOOL)dataComplition:(NSData *)data;

@end
