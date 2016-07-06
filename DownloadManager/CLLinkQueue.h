//
//  CLLinkQueue.h
//  CLDownloadManager
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLQueue.h"

@interface CLLinkQueue : NSObject

@property (nonatomic, strong)CLLinkQueue *nextQueue; // 下一个链
@property (nonatomic, strong)CLQueue     *dataQueue; // 对应的Model数据

+ (instancetype)createLinkQueue:(CLQueue *)dataQueue;

@end
