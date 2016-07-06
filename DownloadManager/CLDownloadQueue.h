//
//  CLDownloadQueue.h
//  CLDownloadManager
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//


//
//  CLDownloadQueue类，是一个管理下载队列
//  CLDownloadQueue是一个单链队列
//  包括:NextQueue、DataQueue
//

#import <Foundation/Foundation.h>
#import "CLLinkQueue.h"
@interface CLDownloadQueue : NSObject

@property (nonatomic, assign)int              length;    // 队列长度

#pragma mark - 队列方法
/**
 *  进队操作
 *
 *  @param linkQueue 加入队列的对象
 */
- (void)EnQueue:(CLQueue *)queue;
/**
 *  出队操作
 *
 *  @return 出对的对象
 */
- (CLQueue *)DeQueue;
/**
 *  出队操作
 *
 *  @return 出对的对象
 */
- (CLQueue *)DeQueue:(int)index;
/**
 *  获取队列当前对象
 *
 *  @return 当前对象
 */
- (CLQueue *)OutPutQueue;
/**
 *  获取队列长度
 *
 *  @return 队列长度
 */
- (int)GetLength;
/**
 *  判断队列是否为空
 *
 *  @return 判断队列是否为空
 */
- (BOOL)IsEmpty;

/**
 *  队列中是否存在
 *
 *  @param queue 判断的Queue
 *
 *  @return 返回当前位置,如果不存在返回-1
 */
- (int)containerQueue:(CLQueue *)queue;

@end
