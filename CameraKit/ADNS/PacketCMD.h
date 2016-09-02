//
//  PacketCMD.h
//  CLWiFiDemo
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface PacketCMD : NSObject

+ (BaseModel *)packetdata:(struct message_info)info;

@end
