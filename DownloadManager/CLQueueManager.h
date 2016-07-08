//
//  CLQueueManager.h
//  CLDownloadManager
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLDownloadQueue.h"
#import "CLNetworkingKit.h"

@protocol CLQueueManagerDelegate <NSObject>
/**
 *  开始下载
 */
- (void)startDownload:(id)queueManager;
/**
 *  结束下载
 */
- (void)stopDownload:(id)queueManager;
/**
 *  更新下载进度
 */
- (void)updateProgress:(CLQueue *)linkQueue queueManager:(id)queueManager;
/**
 *  成功下载一个文件
 *
 *  @param linkQueue
 */
- (void)loadOneFile:(CLQueue *)linkQueue queueManager:(id)queueManager;

@end

// 下载管理类,可以实现队列下载【单个任务单个任务下载】
typedef void(^QueueManagerProgress)(id queueManager, CLQueue *linkQueue);

@interface CLQueueManager : NSObject

@property (nonatomic, strong, readonly)NSMutableArray  *downloadingQueueList; // 正在下载队列
@property (nonatomic, strong, readonly)NSMutableArray  *downloadQueueList;    // 已下载完成队列

@property (nonatomic, strong, readonly)CLDownloadQueue *downloadQueue; // 下载队列
@property (nonatomic, assign)id <CLQueueManagerDelegate>delegate;      // 下载代理
@property (nonatomic, copy  )QueueManagerProgress progress;            // 下载信息block回调

/**
 *  单例方法
 *
 *  @return CLQueueMananger
 */
+ (instancetype)defalutQueueManager;
/**
 *  进队，添加方法
 *
 *  @param queue 下载对象
 */
- (void)EnQueue:(CLQueue *)queue;
/**
 *  出队，删除方法
 *
 *  @param index
 */
- (void)DeQueue:(int)index;
//- (void)DeQueue;

- (int)containerQueue:(CLQueue *)queue;

@end
