//
//  PacketData.m
//  WiFiDemo
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "PacketData.h"
#import "CRC32Data.h"

@interface PacketData ()

@end

@implementation PacketData

+ (NSData *)CommandWithCMDs:(Byte)cmd SUB:(Byte)sub DATA:(NSData *)data
{
    MessageHEAD[0] = 0xEE;
    MessageHEAD[1] = 0xaa;
    
    MessageCMD = cmd;
    MessageSUB = sub;
    
    MessageData = data;
    
    [PacketData CommandData];
    
    NSMutableData *commandData = [[NSMutableData alloc] init];
    
    [commandData appendBytes:&MessageHEAD length:2];
    [commandData appendData:CrcData];
    [commandData appendData:MessageCRCData];
    
    return commandData;
}

+ (void)covertIntToHex:(NSInteger)size
{

    if (size > 255*255*255) {
        
        MessageLEN[0] = 0xff;
        MessageLEN[1] = 0xff;
        MessageLEN[2] = 0xff;
        MessageLEN[3] = size-255*255*255;
        
    } else if (size > 255*255) {
        
        MessageLEN[0] = 0xff;
        MessageLEN[1] = 0xff;
        MessageLEN[2] = size - 255*255;
        MessageLEN[3] = 0x00;
        
    } else if (size > 255) {
        
        MessageLEN[0] = 0xff;
        MessageLEN[1] = size - 255;
        MessageLEN[2] = 0x00;
        MessageLEN[3] = 0x00;
        
    } else {
        
        MessageLEN[0] = size;
        MessageLEN[1] = 0x00;
        MessageLEN[2] = 0x00;
        MessageLEN[3] = 0x00;
        
    }
    
}

+ (void)CommandData
{
    NSMutableData *crcData = [[NSMutableData alloc] init];
    NSMutableData *lenData = [[NSMutableData alloc] init];
    [lenData appendBytes:&MessageCMD length:1];
    [lenData appendBytes:&MessageSUB length:1];
    [lenData appendData:MessageData];

    [PacketData covertIntToHex:lenData.length];

    [crcData appendBytes:&MessageLEN length:4];
    [crcData appendData:lenData];

    CrcData = crcData;

    // 操作Crc32
    uint32_t crcdata = [PacketData CRC32Data:CrcData];
    
    MessageCRCData = [NSData dataWithBytes:&crcdata length:4];

}

+ (uint32_t)CRC32Data:(NSData *)CrcData
{
    
    uint8_t *bytes = (uint8_t *)[CrcData bytes];
    
    uint32_t crc32data = [CRC32Data getCRC32Data:bytes Len:(UInt32)CrcData.length oldCrc32:0];
    
    NSLog(@"crc32data ==== %d", crc32data);
    
    return crc32data;
    
}

+ (uint32_t)getMessageCRC:(struct message_info)info dataLen:(uint32_t)datalen
{
    
    NSMutableData *crcData = [[NSMutableData alloc] init];
    [crcData appendBytes:&info.len length:4];
    [crcData appendBytes:&info.cmd length:1];
    [crcData appendBytes:&info.sub length:1];
    [crcData appendBytes:info.data length:datalen];
    
    return [self CRC32Data:crcData];
    
}

+ (uint32_t)getMessageLEN:(struct message_info)info dataLen:(uint32_t)datalen
{
    
    uint32_t len = 0;
    
    len += sizeof(info.cmd);
    len += sizeof(info.sub);
    len += datalen;
    
    return len;
    
}

+ (NSData *)CommandWithCMD:(Byte)cmd SUB:(Byte)sub DATA:(NSData *)data
{
    
    uint32_t datalen = 0;
    
    struct message_info info;
    
    if (data) {
        
//        [data getBytes:info.data length:data.length];
        info.data = (uint8_t *)data.bytes;
        datalen = (uint32_t)data.length;
        
    }
    
    info.head[0] = 0xee;
    info.head[1] = 0xaa;
    
    info.cmd = cmd;
    info.sub = sub;
    
    info.len = [self getMessageLEN:info dataLen:datalen];
    info.crc = [self getMessageCRC:info dataLen:datalen];
    
    NSMutableData *commandData = [[NSMutableData alloc] init];
    [commandData appendBytes:&info.head length:2];
    [commandData appendBytes:&info.len length:4];
    [commandData appendBytes:&info.cmd length:1];
    [commandData appendBytes:&info.sub length:1];
    [commandData appendBytes:info.data length:datalen];
    [commandData appendBytes:&info.crc length:4];
//    [commandData appendBytes:&info length:8];
    
    return commandData;
    
}

+ (BaseModel *)unPacket:(NSData *)data
{
    struct message_info info;
    [data getBytes:&info.head range:NSMakeRange(0, 2)];
    [data getBytes:&info.len range:NSMakeRange(2, 4)];
    [data getBytes:&info.cmd range:NSMakeRange(6, 1)];
    [data getBytes:&info.sub range:NSMakeRange(7, 1)];
    info.data = (uint8_t *)[[data subdataWithRange:NSMakeRange(8, data.length-12)] bytes];
    [data getBytes:&info.crc range:NSMakeRange(data.length-4, 4)];
    
    if (info.head[0]==0xee&&info.head[1]==0xaa) {
        
        uint32_t crc = [self getMessageCRC:info dataLen:info.len-2];
        
        if (crc==info.crc) {
            
            return [PacketCMD packetdata:info];
            
        } else{
            
            NSLog(@"crc 校验错误");
            
        }
        
    }
    
    return nil;
}

+ (BOOL)dataComplition:(NSData *)data
{
    struct message_info info;
    [data getBytes:&info.head range:NSMakeRange(0, 2)];
    [data getBytes:&info.len range:NSMakeRange(2, 4)];
    [data getBytes:&info.cmd range:NSMakeRange(6, 1)];
    [data getBytes:&info.sub range:NSMakeRange(7, 1)];
    if (data.length!=info.len+10) {
        return NO;
    }
    
    return YES;
}


@end
