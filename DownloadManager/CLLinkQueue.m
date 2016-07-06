//
//  CLLinkQueue.m
//  CLDownloadManager
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "CLLinkQueue.h"

@implementation CLLinkQueue

+ (instancetype)createLinkQueue:(CLQueue *)dataQueue
{
    CLLinkQueue *linkQueue = [[CLLinkQueue alloc] init];
    linkQueue.dataQueue    = dataQueue;
    linkQueue.nextQueue    = NULL;
    return linkQueue;
}

@end
