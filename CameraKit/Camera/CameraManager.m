//
//  CameraManager.m
//  Cheche
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CameraManager.h"
#import "AFNetworking.h"

#define NOVATE_PLAY_URL @"rtsp://192.168.1.254/xxxx.mp4"
#define AIT_PLAY_URL @"rtsp://192.72.1.1/liveRTSP/av1"
@interface CameraManager ()<CLQueueManagerDelegate>
@property (nonatomic, copy)NSArray *ips;
@property (nonatomic, copy)NSArray *classes;
@property (nonatomic, assign)NSInteger currentItem;
@property (nonatomic, strong)BaseCamera *camera;
@property (nonatomic, strong)NSMutableArray *cmdRequests;

@end

@implementation CameraManager

- (instancetype)init
{
    if (self = [super init]) {
        
        self.currentItem = 0;
        self.ips = @[@"192.168.1.254",@"192.72.1.1"];
        self.classes = @[@"NovatekCamera",@"AitCamera"];
        self.cmdRequests = [[NSMutableArray alloc] init];
//        self.cameraDownloadList = [[NSMutableArray alloc] init];
        
        self.fileQueueManager = [[CLQueueManager alloc] init];
        self.nailQueueManager = [[CLQueueManager alloc] init];
        [self.nailQueueManager setDelegate:self];

        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeNetWorking:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
        
//        [[Reachability reachabilityForLocalWiFi] startNotifier];
        
    }
    return self;
}

#pragma mark - nailQueueManager delegate
- (void)loadOneFile:(CLQueue *)linkQueue
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITY_INIT_DOWNLOAD object:nil];
    
}

- (void)startDownload
{
    
}
- (void)stopDownload
{
    
}
- (void)updateProgress:(CLQueue *)linkQueue queueManager:(id)queueManager
{
    
}
- (void)loadOneFile:(CLQueue *)linkQueue queueManager:(id)queueManager
{
    
}



- (void)ChangeNetWorking:(NSNotification *)notification
{
    
    if (_Ping) {
        
        BOOL connected = [self pingIP];
        self->_state   = connected;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CAMERA_CHANGESTATE object:@(connected)];
        
    }
    
}

- (void)GetPreViewURL:(void(^)(NSString * previewURL))previewURLBlock
{
    switch (self.brand) {
        case CameraBrandNovate:
             previewURLBlock(NOVATE_PLAY_URL);
             break;
        case CameraBrandAIT:
        {
            [self.camera getPerViewURL:^(NSString * previewURL) {
                previewURLBlock(previewURL);
            } AddressURL:self.ips[self.brand-1]];
        }
        default:
            break;
    }
}

- (BOOL)pingIP
{
    
    NSString *wifiName = [CameraTools getCameraAddress];
    
    if ([self.ips containsObject:wifiName]) {
        
        NSInteger ipCount = [self.ips indexOfObject:wifiName];
        
        [self disConnect];
        
        _Ping = YES;
        
        self.camera = [[[(BaseCamera *)NSClassFromString(self.classes[ipCount]) class] alloc] init];
        self->_brand = ipCount+1;
        [self.camera connectSocket];
        
        return YES;
        
    } else {
        
        NSLog(@"ERROR WIFI IP : %@", wifiName);
        
        return NO;
    }
    
}


- (void)disConnect
{
    
    self.currentItem = 0;
    self.camera  = nil;
    self->_brand = CameraBrandNono;
    self->_state = CameraStateDisConnected;
    
}

/***** 方法 *****/
+ (id)sharedCameraManager
{
    static CameraManager *manager = nil;
    static dispatch_once_t t;
    dispatch_once(&t, ^{
        manager = [[CameraManager alloc] init];
    });
    return manager;
}

#pragma mark - device control cmd
- (void)ConnectCamera:(TypeResponse)response{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, -1, CameraStateDisConnected);
        return;
    }
    
    [self.camera ConnectCamera:^(BOOL success, int type, CameraState eyeState) {
        self->_state = eyeState;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CAMERA_CHANGESTATE object:@(eyeState)];
            
        });
        
        if (response&&!self.cancelRequest) {
            response(success, type, eyeState);
        }
    }];
}

- (void)setRecordStatus:(BOOL)recordStatus response:(BoolenResponse)response{
    
    if(self.cameraBrand==CameraBrandNono){
        response(NO, CameraStateDisConnected);
        return;
    }
    SEL selector[1];
    selector[0] = @selector(setRecordStatus:response:);
    
    [self.camera setRecordStatus:recordStatus response:^(BOOL success, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, eyeState);
        }
    }];
}
- (void)changeMovieModel:(WIFI_APP_MODE_CMD)model response:(BoolenResponse)response{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, CameraStateDisConnected);
        return;
    }
    [self.camera changeMovieModel:model response:^(BOOL success, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, eyeState);
        }
    }];
}
- (void)TakeCapture:(DataResponse)response{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, NULL, CameraStateDisConnected);
        return;
    }
    [self.camera TakeCapture:^(BOOL success, id obj, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, obj, eyeState);
        }
    }];
}

#pragma mark - device setting cmd
- (void)setSystemDate:(BoolenResponse)response{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, CameraStateDisConnected);
        return;
    }
    [self.camera setSystemDate:^(BOOL success, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, eyeState);
        }
    }];
}
- (void)getSystemDate:(BoolenResponse)response{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, CameraStateDisConnected);
        return;
    }
    [self.camera getSystemDate:^(BOOL success, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, eyeState);
        }
    }];
}
- (void)resetSystem:(BoolenResponse)response{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, CameraStateDisConnected);
        return;
    }
    [self.camera resetSystem:^(BOOL success, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, eyeState);
        }
    }];
}

- (void)setAutoRecording:(BOOL)autoRecording response:(BoolenResponse)response{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, CameraStateDisConnected);
        return;
    }
    [self.camera setAutoRecording:autoRecording response:^(BOOL success, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, eyeState);
        }
    }];
}
- (void)getAutoRecording:(TypeResponse)response{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, -1, CameraStateDisConnected);
        return;
    }
    [self.camera getAutoRecording:^(BOOL success, int type, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, type, eyeState);
        }
    }];
}

- (void)setAutoRecord:(BOOL)autoRecord response:(BoolenResponse)response{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, CameraStateDisConnected);
        return;
    }
    [self.camera setAutoRecord:autoRecord response:^(BOOL success, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, eyeState);
        }
    }];
}
- (void)getAutoRecord:(TypeResponse)response{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, -1, CameraStateDisConnected);
        return;
    }
    [self.camera getAutoRecord:^(BOOL success, int type, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, type, eyeState);
        }
    }];
}

- (void)setRecordSize:(MOVIE_SIZE)recordSize response:(BoolenResponse)response{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, CameraStateDisConnected);
        return;
    }
    [self.camera setRecordSize:recordSize response:^(BOOL success, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, eyeState);
        }
    }];
}
- (void)getRecordSize:(TypeResponse)response{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, -1, CameraStateDisConnected);
        return;
    }
    [self.camera getRecordSize:^(BOOL success, int type, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, type, eyeState);
        }
    }];
}

- (void)setLiveSize:(MOVIE_LIVE_SIZE)liveSize response:(BoolenResponse)response{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, CameraStateDisConnected);
        return;
    }
    [self.camera setLiveSize:liveSize response:^(BOOL success, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, eyeState);
        }
    }];
}
- (void)getLiveSize:(TypeResponse)response{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, -1, CameraStateDisConnected);
        return;
    }
    [self.camera getLiveSize:^(BOOL success, int type, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, type, eyeState);
        }
    }];
}

- (void)setPhotoSize:(PHOTO_SIZE)photoSize response:(BoolenResponse)response{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, CameraStateDisConnected);
        return;
    }
    [self.camera setPhotoSize:photoSize response:^(BOOL success, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, eyeState);
        }
    }];
}
- (void)getPhotoSize:(TypeResponse)response{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, -1, CameraStateDisConnected);
        return;
    }
    [self.camera getPhotoSize:^(BOOL success, int type, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, type, eyeState);
        }
    }];
}

- (void)setSensititySize:(GSENSOR)sensititySize response:(BoolenResponse)response{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, CameraStateDisConnected);
        return;
    }
    [self.camera setSensititySize:sensititySize response:^(BOOL success, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, eyeState);
        }
    }];
}
- (void)getSensititySize:(TypeResponse)response{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, -1, CameraStateDisConnected);
        return;
    }
    [self.camera getSensititySize:^(BOOL success, int type, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, type, eyeState);
        }
    }];
}

- (void)setExposureSize:(EXPOSURE)exposureSize response:(BoolenResponse)response{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, CameraStateDisConnected);
        return;
    }
    [self.camera setExposureSize:exposureSize response:^(BOOL success, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, eyeState);
        }
    }];
}
- (void)getExposureSize:(TypeResponse)response{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, -1, CameraStateDisConnected);
        return;
    }
    [self.camera getExposureSize:^(BOOL success, int type, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, type, eyeState);
        }
    }];
}

- (void)setSSIDandPWD:(CameraInfo *)ssidAndPwd response:(BoolenResponse)response
{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, CameraStateDisConnected);
        return;
    }
    [self.camera setSSIDandPWD:ssidAndPwd response:^(BOOL success, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, eyeState);
        }
    }];
}
- (void)getSSIDandPWD:(DataResponse)response{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, NULL, CameraStateDisConnected);
        return;
    }
    [self.camera getSSIDandPWD:^(BOOL success, id obj, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, obj, eyeState);
        }
    }];
}

- (void)getDiskFreeSpace:(DataResponse)response
{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, NULL, CameraStateDisConnected);
        return;
    }
    [self.camera getDiskFreeSpace:^(BOOL success, id obj, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, obj, eyeState);
        }
    }];
}

#pragma mark - device document cmd
- (void)getFileList:(DataResponse)response{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, NULL, CameraStateDisConnected);
        return;
    }
    [self.camera getFileList:^(BOOL success, id obj, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            
            NSArray *objArray        = (NSArray *)obj;
            
            NSMutableArray *dataList = [[NSMutableArray alloc] init];
            
            for (CameraFile *file in objArray) {
                
                BOOL      isEqul   = NO;
                NSString *fileName = file.name;
                
                for (CameraFile *downloadFiel in self.fileQueueManager.downloadingQueueList) {
                    
                    if ([fileName isEqualToString:downloadFiel.name]) {
                        
                        isEqul = YES;
                        
                    }
                    
                }
                
                if (isEqul==NO) {
                    
                    [dataList addObject:file];
                    
                }
                
            }
            
            [dataList addObjectsFromArray:self.fileQueueManager.downloadingQueueList];
            
            response(success, dataList, eyeState);
        }
    }];
}
- (void)deleteFile:(CameraFile *)file response:(BoolenResponse)response{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, CameraStateDisConnected);
        return;
    }
    [self.camera deleteFile:file response:^(BOOL success, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, eyeState);
        }
    }];
}
- (void)deleteFileList:(BoolenResponse)response{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, CameraStateDisConnected);
        return;
    }
    [self.camera deleteFileList:^(BOOL success, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, eyeState);
        }
    }];
}

#pragma mark - device state cmd
- (void)getCardState:(TypeResponse)response{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, -1, CameraStateDisConnected);
        return;
    }
    [self.camera getCardState:^(BOOL success, int type, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, type, eyeState);
        }
    }];
}

- (void)removeUser:(BoolenResponse)response
{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, CameraStateDisConnected);
        return;
    }
    [self.camera removeUser:^(BOOL success, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, eyeState);
        }
    }];
}

- (void)resetCard:(BoolenResponse)response{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, CameraStateDisConnected);
        return;
    }
    [self.camera resetCard:^(BOOL success, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, eyeState);
        }
    }];
}
- (void)getRecordState:(TypeResponse)response{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, -1, CameraStateDisConnected);
        return;
    }
    [self.camera getRecordSize:^(BOOL success, int type, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, type, eyeState);
        }
    }];
}
- (void)getVersion:(DataResponse)response{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, NULL, CameraStateDisConnected);
        return;
    }
    [self.camera getVersion:^(BOOL success, id obj, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, obj, eyeState);
        }
    }];
}
- (void)updateVersion:(DataResponse)response{
    if(self.cameraBrand==CameraBrandNono){
        response(NO, NULL, CameraStateDisConnected);
        return;
    }
    [self.camera updateVersion:^(BOOL success, id obj, CameraState eyeState) {
        if (response&&!self.cancelRequest) {
            response(success, obj, eyeState);
        }
    }];
}

@end
