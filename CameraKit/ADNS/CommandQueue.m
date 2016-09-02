//
//  CommandQueue.m
//  WIFIDemo
//
//  Created by apple on 16/8/26.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "CommandQueue.h"

@implementation CommandQueue

+ (instancetype)QueueWithCMD:(Byte)cmdByte sub:(Byte)subByte  boolBlock:(BoolenResponse)block
{
    return [self QueueWithCMD:cmdByte sub:subByte data:nil boolBlock:block];
}
+ (instancetype)QueueWithCMD:(Byte)cmdByte sub:(Byte)subByte  dataBlock:(DataResponse)block
{
    return [self QueueWithCMD:cmdByte sub:subByte data:nil dataBlock:block];
}
+ (instancetype)QueueWithCMD:(Byte)cmdByte sub:(Byte)subByte  typeBlock:(TypeResponse)block
{
    return [self QueueWithCMD:cmdByte sub:subByte data:nil typeBlock:block];
}
+ (instancetype)QueueWithCMD:(Byte)cmdByte sub:(Byte)subByte data:(NSData *)cmdData boolBlock:(BoolenResponse)block
{
    CommandQueue *queue = [[CommandQueue alloc] init];
    queue.cmdByte = cmdByte;
    queue.subByte = subByte;
    queue.cmdData = cmdData;
    queue.boolenBlock = block;
    return queue;
}
+ (instancetype)QueueWithCMD:(Byte)cmdByte sub:(Byte)subByte data:(NSData *)cmdData dataBlock:(DataResponse)block
{
    CommandQueue *queue = [[CommandQueue alloc] init];
    queue.cmdByte = cmdByte;
    queue.subByte = subByte;
    queue.dataBlock = block;
    queue.cmdData   = cmdData;
    return queue;
}
+ (instancetype)QueueWithCMD:(Byte)cmdByte sub:(Byte)subByte data:(NSData *)cmdData typeBlock:(TypeResponse)block
{
    CommandQueue *queue = [[CommandQueue alloc] init];
    queue.cmdByte = cmdByte;
    queue.subByte = subByte;
    queue.typeBlock = block;
    queue.cmdData   = cmdData;
    return queue;
}
+ (instancetype)QueueWithCMD:(Byte)cmdByte sub:(Byte)subByte data:(NSData *)cmdData download:(DownloadResponese)block
{
    CommandQueue *queue = [[CommandQueue alloc] init];
    queue.cmdByte = cmdByte;
    queue.subByte = subByte;
    queue.downloadBlock = block;
    queue.cmdData       = cmdData;
    return queue;
}

@end
