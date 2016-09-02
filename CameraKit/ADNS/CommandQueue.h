//
//  CommandQueue.h
//  WIFIDemo
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CamertConst.h"
@interface CommandQueue : NSObject

+ (instancetype)QueueWithCMD:(Byte)cmdByte sub:(Byte)subByte  boolBlock:(BoolenResponse)block;
+ (instancetype)QueueWithCMD:(Byte)cmdByte sub:(Byte)subByte  dataBlock:(DataResponse)block;
+ (instancetype)QueueWithCMD:(Byte)cmdByte sub:(Byte)subByte  typeBlock:(TypeResponse)block;
+ (instancetype)QueueWithCMD:(Byte)cmdByte sub:(Byte)subByte data:(NSData *)cmdData boolBlock:(BoolenResponse)block;
+ (instancetype)QueueWithCMD:(Byte)cmdByte sub:(Byte)subByte data:(NSData *)cmdData dataBlock:(DataResponse)block;
+ (instancetype)QueueWithCMD:(Byte)cmdByte sub:(Byte)subByte data:(NSData *)cmdData typeBlock:(TypeResponse)block;
+ (instancetype)QueueWithCMD:(Byte)cmdByte sub:(Byte)subByte data:(NSData *)cmdData download:(DownloadResponese)block;

@property (nonatomic, assign)Byte       cmdByte;
@property (nonatomic, assign)Byte       subByte;
@property (nonatomic, copy)  BoolenResponse boolenBlock;
@property (nonatomic, copy)  TypeResponse   typeBlock;
@property (nonatomic, copy)  DataResponse   dataBlock;
@property (nonatomic, copy)  DownloadResponese downloadBlock;
@property (nonatomic, strong)NSData    *cmdData;

@end
