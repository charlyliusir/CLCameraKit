//
//  WiFiCameraCommand.m
//  WiFiDemo
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "WiFiCameraCommand.h"
#import "PacketData.h"
#import "SocketServer.h"
#import "HeartBeat.h"
#import "FileList.h"
#import "Photography.h"
#import "GsensorConfigure.h"
#import "RecordConfigure.h"
#import "AudioPlayConfigure.h"

@interface WiFiCameraCommand () <SocketConnectionDelegate>

@property (nonatomic, strong)SocketServer *socketServer;

// 当前请求队列
@property (nonatomic, strong)CommandQueue *cmdQueue;
// 请求列表
@property (nonatomic, strong)NSMutableArray *cmdQueueList;
// 命令执行标示
@property (nonatomic, assign)BOOL cmdRunning;
// 下载文件
@property (nonatomic, strong)FileDownload *downloadFile;
// 结束数据
@property (nonatomic, strong)NSMutableData*receiveData;

@end


@implementation WiFiCameraCommand

- (NSString *)filePath
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    path = [path stringByAppendingString:@"/File"];
    return path;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        self.socketServer = [[SocketServer alloc] init];
        /*** 测试 10.0.1.17 9999 ***/
        /*** 正式 192.168.42.1 2000 ***/
        [self.socketServer connectWithHost:@"10.0.1.17" port:9999];
        self.socketServer.delegate = self;
    }
    
    return self;
}

- (NSMutableArray *)cmdQueueList
{
    if (_cmdQueueList==nil) {
        _cmdQueueList = [NSMutableArray array];
    }
    
    return _cmdQueueList;
}

- (void)connectCameraHost:(NSString *)host port:(int)port
{
    [self disConnect];
    if (!host||[host isEqualToString:@""]||port==0) {
        /*** 测试 10.0.1.20 9999 ***/
        /*** 正式 192.168.42.1 2000 ***/
        [self.socketServer connectWithHost:@"10.0.1.17" port:9999];
        self.socketServer.delegate = self;
    }else{
        [self.socketServer connectWithHost:host port:port];
        self.socketServer.delegate = self;
    }
}

- (void)disConnect
{
    
    [self.socketServer disconnect];
    self.socketServer.delegate = nil;
    
}

- (void)clearQueueList
{
    self.cmdRunning   = NO;
    self.cmdQueue     = nil;
    self.cmdQueueList = @[].mutableCopy;
}

- (NSData *)CommandData:(Byte)byte
{
    
    return [NSData dataWithBytes:&byte length:1];
    
}

/**
 *  获取摄像机状态(心跳包)
 *
 *  @param complition
 */
- (void)ConnectCamera:(TypeResponse)response
{
    HeartBeat *heartBeat = [[HeartBeat alloc] init];
    
    CommandQueue *queue = [CommandQueue QueueWithCMD:CONNECTION sub:HEARTBEAT data:[heartBeat getSendData] typeBlock:response];
    [self EnQueueList:queue order:0];
    
}

/**
 *  切换录制模式
 *
 *  @param record     录制状态
 *  @param complition
 */
- (void)setRecordStatus:(BOOL)recordStatus
               response:(BoolenResponse)response
{
    // 1. 切换 preview状态 [changeControl:0]
    CommandQueue *queue = [CommandQueue QueueWithCMD:FAST_CONTROL sub:FAST_CYCLE_RECORD data:[NSData dataWithBytes:&recordStatus length:1]  boolBlock:response];
    [self EnQueueList:queue order:0];
    
}

/**
 *  切换控制状态
 *
 *  @param control    切换控制状态
 *  @param complition
 */
- (void)changeControl:(Byte)control
             response:(BoolenResponse)response
{
    
    CommandQueue *queue = [CommandQueue QueueWithCMD:UI_CONTROL sub:control boolBlock:response];
    [self EnQueueList:queue order:0];
    
}
/**
 *  执行一次快速录屏
 *
 *  @param complition
 */
- (void)makeShortMovie:(BoolenResponse)response
{
    // 1. 切换 preview状态 [changeControl:0]
    CommandQueue *queue = [CommandQueue QueueWithCMD:FAST_CONTROL sub:FAST_EMERGE boolBlock:response];
    [self EnQueueList:queue order:0];
    
}

/**
 *  执行一次拍照
 *
 *  @param complition
 */
- (void)TakeCapture:(DataResponse)response
{
    // 1. 切换 preview状态 [changeControl:0]
    CommandQueue *queue = [CommandQueue QueueWithCMD:FAST_CONTROL sub:FAST_PHOTOGRAPHY dataBlock:response];
    [self EnQueueList:queue order:0];
    
}
/**
 *  获取SD卡状态
 *
 *  @param complition
 */
- (void)getDiskFreeSpace:(DataResponse)response
{
    // 1. 切换 file状态 [changeControl:1]
    CommandQueue *queue = [CommandQueue QueueWithCMD:FILE_CONTROL sub:GET_SDCARD_STATUS dataBlock:response];
    [self EnQueueList:queue order:0];
    
}

/**
 *  获取文件列表
 *
 *  @param complition
 */
- (void)getFileList:(DataResponse)response
{
    // 1. 切换 file状态 [changeControl:1]
    CommandQueue *queue = [CommandQueue QueueWithCMD:FILE_CONTROL sub:GET_FILE_LIST dataBlock:response];
    [self EnQueueList:queue order:0];
    
}
/**
 *  在线回放视频
 *
 *  @param movieObject 视频文件
 *  @param complition
 */
- (void)playbackMoive:(NSData *)movieObject
           response:(BoolenResponse)response
{
    // 1. 切换 file状态 [changeControl:1]
    
    CommandQueue *queue = [CommandQueue QueueWithCMD:FILE_CONTROL sub:REQ_VIDEO_PLAYBACK data:movieObject boolBlock:response];
    [self EnQueueList:queue order:0];
    
}

/**
 *  下载文件
 *
 *  @param FileObject 下载文件
 *  @param complition
 */
- (void)downloadFile:(FileDownload *)FileObject
          response:(DownloadResponese)response
{
    // 1. 切换 file状态 [changeControl:1]
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[self filePath]]) {
        [fileManager createDirectoryAtPath:[self filePath] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    CommandQueue *queue = [CommandQueue QueueWithCMD:FILE_CONTROL sub:REQ_FILE_DOWNLOAD data:[FileObject getDownloadRequest] download:response];
    self.downloadFile = FileObject;
    [self EnQueueList:queue order:0];
    
}

/**
 *  删除文件
 *
 *  @param fileIndex  文件标示6
 *  @param complition
 */
- (void)deleteFile:(CameraFile *)file
          response:(BoolenResponse)response
{
    // 1. 切换 file状态 [changeControl:1]
    CommandQueue *queue = [CommandQueue QueueWithCMD:FILE_CONTROL sub:REQ_FILE_DELETE data:nil boolBlock:response];
    [self EnQueueList:queue order:0];
    
}
/**
 *  获取视频设置信息（需要切换状态)
 *
 *  @param complition
 */
- (void)getRecordState:(DataResponse)response
{
    // 1. 切换 config状态 [changeControl:2]
    
    CommandQueue *queue = [CommandQueue QueueWithCMD:CONFIG_GET sub:GET_RECORD_CFG dataBlock:response];
    [self EnQueueList:queue order:0];
    
}
- (void)getAutoRecording:(TypeResponse)response
{
    // 1. 切换 config状态 [changeControl:2]
    // 2. 判断是否保存自动录制状态
    
    response(YES, self.autoRecord, self.state);
}
/**
 *  获取自动录制状态
 *
 *  @param response
 */
- (void)getAutoRecord:(TypeResponse)response
{
    // 没有这个选择项
}
/**
 *  获取录制分辨率
 *
 *  @param response
 */
- (void)getRecordSize:(TypeResponse)response
{
    // 1. 切换 config状态 [changeControl:2]
    // 2. 判断是否保存分辨率状态
    if (self.movieResolution!=MOVIE_SIZE_NOT_REQUEST) {
        response(YES, self.movieResolution, self.state);
    }else{
        [self getRecordState:^(BOOL success, id obj, CameraState eyeState) {
            // 3. 解析保存分辨率
            if (success) {
                response(YES, self.movieResolution, self.state);
            }else{
                response(NO, MOVIE_SIZE_NOT_REQUEST, self.state);
            }
            
        }];
    }
}
/**
 *  获取视频设置信息 (不需要切换状态)
 *
 *  @param complition
 */
- (void)getAudioRecordState:(DataResponse)response
{
    // 1. 切换 config状态 [changeControl:2]
    
    CommandQueue *queue = [CommandQueue QueueWithCMD:CONFIG_GET sub:GET_AUDIO_PLAY_CFG dataBlock:response];
    [self EnQueueList:queue order:0];
    
}
/**
 *  获取行车记录仪名称和密码
 *
 *  @param complition
 */
- (void)getSSIDandPWD:(DataResponse)response
{
    // 1. 切换 config状态 [changeControl:2]
    
    CommandQueue *queue = [CommandQueue QueueWithCMD:CONFIG_GET sub:GET_WIFI_CFG dataBlock:response];
    [self EnQueueList:queue order:0];
    
}
/**
 *  获取灵敏度信息
 *
 *  @param complition
 */
- (void)getSensititySize:(TypeResponse)response
{
    // 1. 切换 config状态 [changeControl:2]
    if (self.gsensor!=GSENSOR_NOT_REQUEST) {
        response(YES, self.gsensor, self.state);
    }else{
        CommandQueue *queue = [CommandQueue QueueWithCMD:CONFIG_GET sub:GET_GSENSOR_CFG typeBlock:response];
        [self EnQueueList:queue order:0];
    }
}
/**
 *   获取曝光率
 *
 *  @param response
 */
- (void)getExposureSize:(TypeResponse)response
{
    // 1. 切换 config状态 [changeControl:2]
    // ADNS 不支持设置曝光
    response(NO, 0, self.state);
}

/**
 *  获取Adas信息
 *
 *  @param complition
 */
- (void)getAdasState:(DataResponse)response
{
    // 1. 切换 config状态 [changeControl:2]
    
    CommandQueue *queue = [CommandQueue QueueWithCMD:CONFIG_GET sub:GET_ADAS_CFG dataBlock:response];
    [self EnQueueList:queue order:0];
    
}
/**
 *  获取版本信息
 *
 *  @param response
 */
- (void)getVersion:(DataResponse)response
{
    // 1. 切换 config状态 [changeControl:2]
    
    CommandQueue *queue = [CommandQueue QueueWithCMD:CONFIG_GET sub:GET_VERSION dataBlock:response];
    [self EnQueueList:queue order:0];
}

- (void)getCardState:(TypeResponse)response
{
    // 1.直接获取当前保存状态
    response(YES, self.cardState, self.state);
}

/**
 *  设置分辨率
 *
 *  @param resolution 设置参数
 *  @param complition
 */
- (void)setRecordSize:(MOVIE_SIZE)recordSize
             response:(BoolenResponse)response
{
    // 1. 切换 config状态 [changeControl:2]
    
    CommandQueue *queue = [CommandQueue QueueWithCMD:CONFIG_SET sub:SET_RESOLUTION data:[NSData dataWithBytes:&recordSize length:1] boolBlock:response];
    [self EnQueueList:queue order:0];
    
}

/**
 *  设置循环录制时间
 *
 *  @param duration   循环时间
 *  @param complition
 */
- (void)setDuration:(Byte)duration
           response:(BoolenResponse)response
{
    // 1. 切换 config状态 [changeControl:2]
    
    CommandQueue *queue = [CommandQueue QueueWithCMD:CONFIG_SET sub:SET_DURATION data:[self CommandData:duration] boolBlock:response];
    [self EnQueueList:queue order:0];
    
}

/**
 *  设置是否自动录制
 *
 *  @param audioRecord 是否自动录制
 *  @param complition
 */
- (void)setAutoRecording:(BOOL)autoRecord
                response:(BoolenResponse)response
{
    // 1. 切换 config状态 [changeControl:2]
    
    CommandQueue *queue = [CommandQueue QueueWithCMD:CONFIG_SET sub:SET_AUDIO_RECORD data:[NSData dataWithBytes:&autoRecord length:1] boolBlock:response];
    [self EnQueueList:queue order:0];
    
}

/**
 *  设置是否开启HDR
 *
 *  @param hdr        是否开启
 *  @param complition
 */
- (void)setHDR:(Byte)hdr
      response:(BoolenResponse)response
{
    // 1. 切换 config状态 [changeControl:2]
    
    CommandQueue *queue = [CommandQueue QueueWithCMD:CONFIG_SET sub:SET_HDR data:[self CommandData:hdr] boolBlock:response];
    [self EnQueueList:queue order:0];
    
}

/**
 *  设置是否开启OSD
 *
 *  @param osd
 *  @param complition
 */
- (void)setOSD:(Byte)osd
      response:(BoolenResponse)response
{
    // 1. 切换 config状态 [changeControl:2]
    
    CommandQueue *queue = [CommandQueue QueueWithCMD:CONFIG_SET sub:SET_OSD data:[self CommandData:osd] boolBlock:response];
    [self EnQueueList:queue order:0];
    
}

/**
 *  设置设备名
 *
 *  @param ssid
 *  @param complition
 */
- (void)setSSIDandPWD:(CameraInfo *)ssidAndPwd
             response:(BoolenResponse)response
{
    // 1. 切换 config状态 [changeControl:2]
    // 合并CameraInfo 旧版行车记录仪和新版ADNS
    CommandQueue *queue = [CommandQueue QueueWithCMD:CONFIG_SET sub:SET_SSID data:nil boolBlock:response];
    [self EnQueueList:queue order:0];
    
}

/**
 *  提示声音设置
 *
 *  @param audioPlayObject 设置
 *  @param complition
 */
- (void)setAudioPlay:(NSData *)audioPlayObject
            response:(BoolenResponse)response
{
    // 1. 切换 config状态 [changeControl:2]
    
    CommandQueue *queue = [CommandQueue QueueWithCMD:CONFIG_SET sub:SET_AUDIO_PLAY_CFG data:audioPlayObject boolBlock:response];
    [self EnQueueList:queue order:0];
    
}

/**
 *  设置灵敏度
 *
 *  @param gsensorObject
 *  @param complition
 */
- (void)setSensititySize:(GSENSOR)sensititySize
                response:(BoolenResponse)response
{
    // 1. 切换 config状态 [changeControl:2]
    // 根据传来gsensor 拼接 gsensordata
    CommandQueue *queue = [CommandQueue QueueWithCMD:CONFIG_SET sub:SET_GSENSOR_CFG data:nil boolBlock:response];
    [self EnQueueList:queue order:0];
    
}
/**
 *  设置摄像曝光
 *
 *  @param exposureSize 曝光值
 *  @param response
 */
- (void)setExposureSize:(EXPOSURE)exposureSize response:(BoolenResponse)response
{
    // ANDS 不支持设置曝光
    response(NO, self.state);
}

/**
 *  设置ADAS
 *
 *  @param adasObject
 *  @param complition
 */
- (void)setAdas:(NSData *)adasObject
       response:(BoolenResponse)response
{
    // 1. 切换 config状态 [changeControl:2]
    
    CommandQueue *queue = [CommandQueue QueueWithCMD:CONFIG_SET sub:SET_ADAS_CFG data:adasObject boolBlock:response];
    [self EnQueueList:queue order:0];
    
}

/**
 *  初始化SD卡
 *
 *  @param complition
 */
- (void)resetCard:(BoolenResponse)response
{
    // 1. 切换 config状态 [changeControl:2]
    CommandQueue *queue = [CommandQueue QueueWithCMD:CONFIG_SET sub:SDCARD_FORMATTING boolBlock:response];
    [self EnQueueList:queue order:0];
    
}
/**
 *  恢复出厂设置
 *
 *  @param complition
 */
- (void)resetSystem:(BoolenResponse)response
{
    // 1. 切换 config状态 [changeControl:2]
    CommandQueue *queue = [CommandQueue QueueWithCMD:CONFIG_SET sub:FACTORY_RESET boolBlock:response];
    [self EnQueueList:queue order:0];
    
}

/**
 *  获取标定数据
 *
 *  @param complition
 */
- (void)getCaliParamComplition:(DataResponse)response
{
    // 1. 切换 calibration状态 [changeControl:3]
    CommandQueue *queue = [CommandQueue QueueWithCMD:CAMERA_CALI sub:GET_CALI_PARAM dataBlock:response];
    [self EnQueueList:queue order:0];
    
}

/**
 *  设置标定数据
 *
 *  @param caliObject
 *  @param complition
 */
- (void)setCaliParam:(NSData *)caliObject
            response:(BoolenResponse)response
{
    // 1. 切换 calibration状态 [changeControl:2]
    CommandQueue *queue = [CommandQueue QueueWithCMD:CAMERA_CALI sub:EXECUTE_CALIBRATION data:caliObject boolBlock:response];
    [self EnQueueList:queue order:0];
    
}

- (void)UnQueue
{
    [self.cmdQueueList removeObject:self.cmdQueue];
    self.cmdRunning = NO;
    self.cmdQueue   = nil;
}

- (void)Finish
{
    [self UnQueue];
    if (self.cmdQueueList.count>0) {
        [self sendData:[self.cmdQueueList firstObject]];
    }
}

- (void)EnQueueDownloadFile:(CommandQueue *)cmdQueue
{
    [self UnQueue];
    [self EnQueueList:cmdQueue order:1];
}

- (void)EnQueueList:(CommandQueue *)cmdQueue order:(int)order
{
    if (order==0) {
        [self.cmdQueueList addObject:cmdQueue];
    }else{
        [self.cmdQueueList insertObject:cmdQueue atIndex:0];
    }
    
    if (!self.cmdRunning) {
        [self sendData:[self.cmdQueueList firstObject]];
    }
    
}

// send cmd to socket
- (void)sendData:(CommandQueue *)cmdQueue
{
    
    self.cmdQueue   = cmdQueue;
    self.cmdRunning = YES;
    
    NSData *data = [PacketData CommandWithCMD:self.cmdQueue.cmdByte SUB:self.cmdQueue.subByte DATA:self.cmdQueue.cmdData];
    
    NSLog(@"cmd data === %@", data);
    
    // 发送命令
    [self.socketServer writeData:data timeout:10 tag:1];
    [self.socketServer readDataWithTimeout:-1 tag:1];
    
}

- (void)didDisconnectWithError:(NSError *)error
{
    NSLog(@"didDisconnectWithError:%@", error);
}

/**
 *  和socket服务器连接成功的回调方法
 *
 *  @param host 连接成功的服务器地址ip
 *  @param port 连接成功的服务器端口port
 */
- (void)didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"didConnectToHost:%@------port:%d", host, port);
}

/**
 *  接收到从socket服务器推送下来的下行数据回调方法
 *
 *  @param data 推送过来的下行数据
 *  @param tag  数据tag标记，和readDataWithTimeout:tag/writeData:timeout:tag:中的tag对应。
 */
- (void)didReceiveData:(NSData *)data tag:(long)tag
{
    NSData *receiveData = data;
    if (self.receiveData) {
        [self.receiveData appendData:data];
        receiveData = self.receiveData.copy;
    }
    BOOL complition = [PacketData dataComplition:receiveData];
    if (!self.receiveData&&!complition) {
        self.receiveData = data.mutableCopy;
    }
    
    if (complition) {
        self.receiveData = nil;
        BaseModel*datas  = [PacketData unPacket:receiveData];
        if ([datas isKindOfClass:[NSClassFromString(@"FileDownload") class]]) {
            
            // fileDownload 下载下面的数据
            FileDownload *fileDownload = (FileDownload *)datas;
            fileDownload.usFileIndex   = self.downloadFile.usFileIndex;
            fileDownload.usDataType    = self.downloadFile.usDataType;
            NSString *fileName = [NSString stringWithFormat:@"%@.%@", fileDownload.usDataType,[fileDownload.usDataType intValue]==0?@"mp4":@"png"];
            NSString *filePath = [[self filePath] stringByAppendingFormat:@"/%@", fileName];
            [fileDownload.ucData writeToFile:filePath options:NSDataWritingWithoutOverwriting error:nil];
            
            if ([fileDownload.uiRemainSize intValue]!=0) {
                
                NSLog(@"download progress - %.2f", [fileDownload.uiDataPosition floatValue]/[fileDownload.uiTotalSize floatValue]);
                
                fileDownload.uiDataPosition = @([fileDownload.uiCurrentSize intValue]+[fileDownload.uiDataPosition intValue]);
                fileDownload.uiCurrentSize  = fileDownload.uiDataPosition;
                
                if (self.cmdQueue.downloadBlock) {
                    // 返回下载进度
//                    self.cmdQueue.downloadBlock();
                }
                
                CommandQueue *queue = [CommandQueue QueueWithCMD:FILE_CONTROL sub:REQ_FILE_DOWNLOAD data:[fileDownload getDownloadRequest] download:self.cmdQueue.downloadBlock];
                
                [self EnQueueDownloadFile:queue];
            }else{
                
                self.downloadFile = nil;
                
            }
            
        }else{
            
            NSNumber *a = @(100);
            unsigned short n = [a unsignedShortValue];
            NSData *testData = [NSData dataWithBytes:&n length:1];
            NSLog(@"==========testData :: %@ ===========", testData);
            
            [datas getDictionary];
            // 判断block类型，返回对应的block
            if (self.cmdQueue.boolenBlock) {
                
                if ([datas.errorCode isEqualToNumber:@(0)]) {
                    self.cmdQueue.boolenBlock(YES, self.cameraState);
                }else{
                    self.cmdQueue.boolenBlock(NO, self.cameraState);
                }
                
            }else if (self.cmdQueue.typeBlock){
                // 回调为Type格式，则通过对应的方法解析
                [self unPacketTypeBlock:datas];
            }else if (self.cmdQueue.dataBlock){
                // 回调为Data格式，通过对应的方法解析
                [self unPacketDataBlock:datas];
            }else{
                // 如果没有回调，有可能是每5s发送一次的心跳包
                if ([datas isKindOfClass:[HeartBeat class]]) {
                    [self unPacketHeartBeat:(HeartBeat *)datas];
                }
                
            }
            
            [self Finish];
            
        }
        
    }
    
}

- (void)unPacketDataBlock:(BaseModel *)model
{
    if ([model isKindOfClass:[ADNSCameraFile class]]) {
        // recordState
        CameraFile *file = [self createCameraFile:(ADNSCameraFile *)model];
        self.cmdQueue.dataBlock(YES, file, self.state);
        
    }else if([model isKindOfClass:[FileList class]]){
        NSMutableArray *cameraFileList = @[].mutableCopy;
        NSArray *fileList = ((FileList *)model).filelist;
        for (ADNSCameraFile *adnsFile in fileList) {
            [cameraFileList addObject:[self createCameraFile:adnsFile]];
        }
        self.cmdQueue.dataBlock(YES, cameraFileList, self.state);
        
    }else if([model isKindOfClass:[Photography class]]){
        Photography    *photo    = (Photography*)model;
        ADNSCameraFile *adnsFile = [[ADNSCameraFile alloc] init];
        adnsFile.usIndex         = photo.fileindex;
        adnsFile.ucType          = @(1);
        adnsFile.uiDate          = photo.filedate;
        CameraFile *file = [self createCameraFile:adnsFile];
        self.cmdQueue.dataBlock(YES, file, self.state);
        
    }else if([model isKindOfClass:[RecordConfigure class]]){
        RecordConfigure *config = (RecordConfigure *)model;
        self.movieResolution = [config.ucResolution intValue];
        self.autoRecord      = [config.ucAudioRecordEnable boolValue];
        self.cmdQueue.dataBlock(YES, config, self.state);
        
    }else if([model isKindOfClass:[AudioPlayConfigure class]]){
        AudioPlayConfigure *config = (AudioPlayConfigure *)model;
        self.systemVolume= [config.ucSystemVolume intValue];
        self.cmdQueue.dataBlock(YES, config, self.state);
        
    }else{
        
        self.cmdQueue.dataBlock(YES, model, self.state);
    }
}

- (void)unPacketTypeBlock:(BaseModel *)model
{
    if ([model isKindOfClass:[HeartBeat class]]) {
        [self unPacketHeartBeat:(HeartBeat *)model];
        self.cmdQueue.typeBlock(YES, self.state, self.state);
    } else if ([model isKindOfClass:[GsensorConfigure class]]){
        GsensorConfigure *gsensorObj = (GsensorConfigure *)model;
        self.gsensor = [gsensorObj.ucWakeupSensitivity intValue];
        self.cmdQueue.typeBlock(YES, self.gsensor, self.state);
    }
}

- (CameraFile *)createCameraFile:(ADNSCameraFile *)adnsFile
{
    CameraFile *file = [[CameraFile alloc] init];
    file.cameraFile  = adnsFile;
    return file;
}

- (void)unPacketHeartBeat:(HeartBeat *)heartBeat
{
    // 0. UI状态
    // 1. 录制状态
    // 2. SD卡状态
    // 4. 自动录音状态
    // 5. 系统声音
    self.uiState  = [heartBeat.ucUIStatus intValue];
    self.state    = (CameraState)[heartBeat getCameraState];
    self.cardState= [heartBeat getCameraSDCardState];
    self.autoRecord  = [heartBeat.ucAudioRecordStatus boolValue];
    self.systemVolume= [heartBeat.ucSystemVolume intValue];
}

@end
