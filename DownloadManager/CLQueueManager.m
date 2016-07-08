//
//  CLQueueManager.m
//  CLDownloadManager
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "CLQueueManager.h"

typedef NS_ENUM(NSInteger, QueueState) {
    QueueStateStop,
    QueueStateStart,
    QueueStatePasue
};

@interface CLQueueManager ()

@property (nonatomic, assign)QueueState state;
@property (nonatomic, strong)NSURLSessionDownloadTask *task;

@end

@implementation CLQueueManager

- (instancetype)init
{
    
    if (self = [super init]) {
        
        self->_downloadQueue = [[CLDownloadQueue alloc] init];
        self->_downloadingQueueList = @[].mutableCopy;
        self->_downloadQueueList    = @[].mutableCopy;
        
    }
    
    return self;
    
}

+ (instancetype)defalutQueueManager
{
    
    static CLQueueManager *queueManager = NULL;
    static dispatch_once_t t;
    
    dispatch_once(&t, ^{
       
        queueManager = [[CLQueueManager alloc] init];
        
    });
    
    return queueManager;
    
}

- (void)EnQueue:(CLQueue *)queue
{
    if ([self->_downloadQueue containerQueue:queue]==-1) {
        
        [self->_downloadQueue EnQueue:queue];
        [self->_downloadingQueueList addObject:queue];
        
        if (self.state==QueueStateStop) {
            // 开始下载
            self.state = QueueStateStart;
            
            if (_delegate && [_delegate respondsToSelector:@selector(startDownload:)])
            {
                [_delegate startDownload:queue];
            }
            
            [self downloadWithLinkQueue];
            
        }
        
    }
        
}

- (void)DeQueue:(int)index
{
    if ([self.downloadQueue IsEmpty])
    {
        return;
    }
    
    if (index==0)
    {
        [self.task cancel];
        CLQueue *queue = [self->_downloadQueue OutPutQueue];
        [self->_downloadingQueueList removeObject:queue];
        [self reInitQueue:queue];
        [self->_downloadQueue DeQueue];
        [self downloadWithLinkQueue];
        
    }else
    {
        [self->_downloadQueue DeQueue:index];
    }
}

- (void)DeQueue
{
    if ([self.downloadQueue IsEmpty])
    {
        return;
    }
    
    CLQueue *queue = [self->_downloadQueue OutPutQueue];
    [self->_downloadingQueueList removeObject:queue];
    [self->_downloadQueue DeQueue];
    [self downloadWithLinkQueue];
    
}

- (int)containerQueue:(CLQueue *)queue
{
    
    return [self->_downloadQueue containerQueue:queue];
    
}

- (void)downloadWithLinkQueue
{
    
    if ([self.downloadQueue IsEmpty])
    {
        self.state = QueueStateStop;
        NSLog(@"stop");
        [self->_downloadQueueList removeAllObjects];
        [self->_downloadingQueueList removeAllObjects];
        if (_delegate &&[_delegate respondsToSelector:@selector(stopDownload:)]) {
            [_delegate stopDownload:self];
        }
        return;
    }
    
    CLQueue *queue = self.downloadQueue.OutPutQueue;
    
    self.task = [CLNetworkingKit DownloadWithURL:queue.url cachepath:queue.path progress:^(NSProgress *downloadProgress) {
        
//        uint64_t completed = downloadProgress.completedUnitCount;
//        uint64_t total     = downloadProgress.totalUnitCount;
//        queue.progress = (completed*1.0f)/(total*1.0f);
        
        if(downloadProgress.fractionCompleted-queue.progress>0.02f)
        {
            queue.progress = downloadProgress.fractionCompleted;
            [self notifyProgress:queue];
        }
        
    } responseblock:^(id responseObj, BOOL success, NSError *error) {
        
        if (error) {
            
            queue.progress = 0.0f;
            [self DeQueue];
//            NSLog(@"error : %@", error);
//            // -999 取消网络请求  -1002 不支持的URL
//            if (error.code!=-999&&error.code!=-1002)
//            {
//                [self downloadWithLinkQueue];
//            }
            
        } else
        {
            queue.progress = 1.0f;
            [self notifyProgress:queue];
            [self->_downloadQueueList addObject:queue];
            if (_delegate && [_delegate respondsToSelector:@selector(loadOneFile:queueManager:)]) {
                [_delegate loadOneFile:queue queueManager:self];
            }
            
            [self DeQueue];
        }
        
    }];
    
}

- (void)reInitQueue:(CLQueue *)queue
{
    queue.progress = 0;
    
    [self notifyProgress:queue];
    
}

- (void)notifyProgress:(CLQueue *)queue
{
    if (_progress)
    {
        self.progress(self, queue);
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(updateProgress:queueManager:)])
    {
        [_delegate updateProgress:queue queueManager:self];
    }
}

@end
