//
//  CLDownloadQueue.m
//  CLDownloadManager
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "CLDownloadQueue.h"

@interface CLDownloadQueue ()

@property (nonatomic, strong)CLLinkQueue *head; // 头指针
@property (nonatomic, strong)CLLinkQueue *rear; // 当前指向指针

@end

@implementation CLDownloadQueue

- (instancetype)init
{
    if (self = [super init]) {
        
        self.head = NULL;
        self.rear = NULL;
        self.length = 0;
        
    }
    
    return self;
}

/**
 *  进队操作
 *
 *  @param linkQueue 加入队列的对象
 */
- (void)EnQueue:(CLQueue *)queue
{
    
    CLLinkQueue *linkQueue = [CLLinkQueue createLinkQueue:queue];
    
    self.length ++;
    
    if (self.head==NULL) {
        
        self.head = linkQueue;
        self.rear = linkQueue;
        
    } else {
        
        self.rear.nextQueue = linkQueue;
        self.rear = linkQueue;
        
    }
    
    NSLog(@"obj number : %d", self.length);
}
/**
 *  出队操作
 *
 *  @return 出对的对象
 */
- (CLQueue *)DeQueue
{
    
    if ([self IsEmpty]) {
        
        return NULL;
        
    } else {
        
        self.length --;
        
        self.head = self.head.nextQueue;
        
        NSLog(@"obj number : %d", self.length);
        
        return self.head.dataQueue;
        
    }
    
}
- (CLQueue *)DeQueue:(int)index
{
    
    if ([self IsEmpty]) {
        
        return NULL;
        
    } else {
        
        if (index==0) {
            
            return [self DeQueue];
            
        } else {
            
            self.length --;
            
            CLLinkQueue *pQueue = self.head;
            CLLinkQueue *cQueue = NULL;
            CLLinkQueue *nQueue = NULL;
            
            while (index > 1) {
                
                pQueue = pQueue.nextQueue;
                index --;
                
            }
            
            cQueue = pQueue.nextQueue;
            nQueue = cQueue.nextQueue;
            pQueue.nextQueue = nQueue;
            
            NSLog(@"obj number : %d", self.length);
            
            return cQueue.dataQueue;
            
        }
        
    }
    
}
/**
 *  获取队列当前对象
 *
 *  @return 当前对象
 */
- (CLQueue *)OutPutQueue
{
    if ([self IsEmpty]) {
        
        return NULL;
        
    } else {
        
        return self.head.dataQueue;
        
    }
}
/**
 *  获取队列长度
 *
 *  @return 队列长度
 */
- (int)GetLength
{
    return self.length;
}
/**
 *  判断队列是否为空
 *
 *  @return 判断队列是否为空
 */
- (BOOL)IsEmpty
{
    return self.length==0;
}

- (int)containerQueue:(CLQueue *)queue
{
    
    if ([self IsEmpty]) {
        
        return -1;
        
    }
    int index = 0;
    CLLinkQueue *linkQueue = self.head;
    
    while (linkQueue) {
        
        if ([linkQueue.dataQueue isEqual:queue]) {
            
            return index;
            
        } else {
            
            linkQueue = linkQueue.nextQueue;
            index ++;
            
        }
        
    }
    
    return -1;
    
}

@end
