//
//  NovatekCamera.m
//  Cheche
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 apple. All rights reserved.
//
#import "NovatekCamera.h"
#import <AudioToolbox/AudioToolbox.h>
#import "GCDAsyncSocket.h"
#import "CLXMLParser.h"

@interface NovatekCamera () <GCDAsyncSocketDelegate>

@property (nonatomic, strong)GCDAsyncSocket *tcpSocket;

@end

@implementation NovatekCamera
@synthesize tcpSocket;

- (void)connectSocket
{
    [self disConnectSocket];
    tcpSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    [tcpSocket connectToHost:@"192.168.1.254" onPort:3333 error:&error];
    if (error) {
        [self disConnectSocket];
    }
    [tcpSocket readDataWithTimeout:-1 tag:0];
}

- (void)disConnectSocket
{
    
    if (tcpSocket) {
        
        [tcpSocket disconnect];
        [tcpSocket setDelegate:NULL];
        
    }
    
}

#pragma mark - asyncSocket Delegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"didConnectToHost:%@ port:%d", host, port);
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"socketDidDisconnect");
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    CLXMLParser *parser = [[CLXMLParser alloc] initWithXMLParser:xmlParser XMLDocumentBlock:^(NSDictionary *XMLDocument) {
        
        if (XMLDocument) {
            NSString     *status   = [XMLDocument objectForKey:@"status"];
            
            NSLog(@"revice notify status : %@", status);
            
            if (status) {
                switch ([status integerValue]) {
                    case 9:
                        // 断电
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CAMERA_UNINORIGIN object:nil];
                        
                        break;
                        
                    case 6:
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CAMERA_UNCONNECTED object:nil];
                        
                        break;
                        
                    case 7:
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CAMERA_HASLASTUSER object:nil];
                        
                        break;
                    case -7:
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CAMERA_FULLSDCARD object:nil];
                        
                        break;
                    default:
                        break;
                }
            }
        }
        
        [sock readDataWithTimeout:-1 tag:tag];
        
    }];
    
}
/*!
 @method
 @abstract 将布尔值变成字符串
 @discussion 方法调用传进来一个布尔值,然后返回一个字符串
 @param Boolen 传参,被转换的布尔值
 @result 转换后的字符串
 */

- (NSString *)covertStringWithBoolen:(BOOL)Boolean
{
    return [NSString stringWithFormat:@"%d", Boolean];
}

/*!
 @method
 @abstract 将整形变成字符串
 @discussion 方法调用传进来一个整形,然后返回一个字符串
 @param Boolen 传参,被转换的整形
 @result 转换后的字符串
 */
- (NSString *)covertStringWithType:(int)type
{
    return [NSString stringWithFormat:@"%d", type];
}

/*!
 @method
 @abstract 拍照成功后的声音
 @discussion 拍照成功后，调用系统拍照（咔嚓）声
 @result void
 */
- (void)cuptureAudio
{
    dispatch_async(dispatch_get_main_queue(), ^{
        SystemSoundID myAlertSound;
        NSURL *url = [NSURL URLWithString:@"/System/Library/Audio/UISounds/photoShutter.caf"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &myAlertSound);
        AudioServicesPlaySystemSound(myAlertSound);
    });
}

#pragma mark - request tools

/*!
 @method
 @abstract 命令请求的URL
 @discussion 通过cmd命令参数和paramter参数,拼接一个字符串返回,
             这个就是命令请求的URL,其中paramter参数可以没有
 @param cmd 命令参数 eg:2001
 @param paramter 参数 eg:0,1...so on 主要用于设置视频分辨率等
 @result 拼接后完整的URL
 */
- (NSString *)RequestWithCMD:(NSString *)cmd Parameter:(NSString *)parameter String:(NSString *)str
{
    NSString *URLString = [NSString stringWithFormat:@"%@/?custom=%@", NovatekIP, CUSTOM];
    // 命令
    if (cmd) {
        URLString = [URLString stringByAppendingString:[NSString stringWithFormat:@"&cmd=%@", cmd]];
    }
    // 参数
    if (parameter) {
        URLString = [URLString stringByAppendingString:[NSString stringWithFormat:@"&par=%@", parameter]];
    }
    // string参数
    if (str) {
        URLString = [URLString stringByAppendingString:[NSString stringWithFormat:@"&str=%@", str]];
    }
    
    return URLString;
}


/*!
 @method
 @abstract 发送请求,返回block是否成功
 @discussion 发送请求,设置状态,返回值可以判断是否成功,只需要命令参数
 @param cmd 发送的命令参数
 @param response BoolenResponse 参数1 返回执行命令是否成功 参数2 连接状态
 @result 空
 */
- (void)RequestCMD:(NSString *)cmd DataResponse:(DataResponse)response{
    [self RequestCMD:cmd parameter:NULL string:NULL DataResponse:^(BOOL success, id obj, CameraState eyeState) {
        if (response) {
            response(success, obj, eyeState);
        }
    }];
}

/*!
 @method
 @abstract 发送请求,返回block是否成功
 @discussion 发送请求,设置状态,返回值可以判断是否成功
 @param cmd 发送的命令参数
 @param paramter 执行命令其他参数
 @param response BoolenResponse 参数1 返回执行命令是否成功 参数2 连接状态
 @result 空
 */
- (void)RequestCMD:(NSString *)cmd parameter:(NSString *)parameter string:(NSString *)str DataResponse:(DataResponse)response
{
    NSString *requestURL = [self RequestWithCMD:cmd Parameter:parameter String:str];
    
    [CLNetworkingKit RequestWithURL:requestURL parameters:NULL requestmethod:RequestMethodGet contenttype:ContentTypesXML responseblock:^(id responseObj, BOOL success, NSError *error) {
        
        if (error) {
            
            if (response)
                response(NO, NULL, self.cameraState);
            
        }else{
            
            if ([responseObj isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dict = responseObj;
                response(YES,dict, self.cameraState);
                
            } else if ([responseObj isKindOfClass:[NSArray class]]) {
                
                NSArray *array = [responseObj copy];
                response (YES, array, self.cameraState);
                
            } else {
                
                NSArray *array = [NSArray array];
                response (YES, array, self.cameraState);
                
            }
            
        }
        
    }];
    
}


/*!
 @method
 @abstract 发送请求,返回block是否成功
 @discussion 发送请求,设置状态,返回值可以判断是否成功,只需要命令参数
 @param cmd 发送的命令参数
 @param response BoolenResponse 参数1 返回执行命令是否成功 参数2 连接状态
 @result 空
 */
- (void)RequestCMD:(NSString *)cmd BoolenResponse:(BoolenResponse)response{
    [self RequestCMD:cmd parameter:NULL string:NULL BoolenResponse:^(BOOL success, CameraState eyeState) {
        if (response)
            response(success, eyeState);
    }];
}

/*!
 @method
 @abstract 发送请求,返回block是否成功
 @discussion 发送请求,设置状态,返回值可以判断是否成功
 @param cmd 发送的命令参数
 @param paramter 执行命令其他参数
 @param response BoolenResponse 参数1 返回执行命令是否成功 参数2 连接状态
 @result 空
 */
- (void)RequestCMD:(NSString *)cmd parameter:(NSString *)parameter string:(NSString *)str BoolenResponse:(BoolenResponse)response
{
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *requestURL = [self RequestWithCMD:cmd Parameter:parameter String:str];
    NSLog(@"%@", requestURL);
    
    [CLNetworkingKit RequestWithURL:requestURL parameters:NULL requestmethod:RequestMethodGet contenttype:ContentTypesXML responseblock:^(id responseObj, BOOL success, NSError *error) {
        
        if (error) {
            
            if ([responseObj isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dict = responseObj;
                NSString *status   = dict[@"status"];
                if ([status integerValue]==0)
                    response(YES, self.cameraState);
                else
                    response(NO, self.cameraState);
            } else if ([responseObj isKindOfClass:[NSDictionary class]]) {
                
                
                
            }
            
        }else{
            
            if (response)
                response(NO, self.cameraState);
            
        }
        
    }];
    
}

/*!
 @method
 @abstract 获取状态
 @discussion 获取当前设备的设置状态,
             通过Query Current Status获得所有设置的状态,然后再筛选特例
 @param cmd 获取当前所有设置状态命令
 @param status 想要获取状态的设置命令
 @param response TypeResponse: 参数1 是否成功 参数2 状态
 @result 空
 */

- (void)getQuereyStatus
{
    NSString *requestURL = [self RequestWithCMD:WIFIAPP_CMD_QUERY_CUR_STATUS Parameter:NULL String:NULL];
    NSLog(@"%@", requestURL);
    
    [CLNetworkingKit RequestWithURL:requestURL parameters:NULL requestmethod:RequestMethodGet contenttype:ContentTypesXML responseblock:^(id responseObj, BOOL success, NSError *error) {
       
        if (!error&&[responseObj isKindOfClass:[NSArray class]]) {
            
            self.queueArray = (NSArray *)responseObj;
            
        }
        
    }];
    
}

- (void)QueryCMD:(NSString *)cmd StatusCMD:(NSString *)status TypeResponse:(TypeResponse)response
{
    
    if (_queueArray && _queueArray.count > 0) {
        
        for (NSDictionary *dict in _queueArray) {
            
            NSString *cmdString= dict[@"cmd"];
            NSString *statu   = dict[@"status"];
            
            if ([status isEqualToString:cmdString]) {
                
                response(YES, [statu intValue], self.cameraState);
                
            }
        }
        
    }else{
        response(NO, -1, self.cameraState);
    }
    
}

/*!
 @method
 @abstract 获取连接状态
 @discussion 获取当前设备的连接状态,
 @param cmd 录制时间命令
 @param response TypeResponse: 参数1 是否成功 参数2 状态
 @result 空
 */
- (void)RequestCMD:(NSString *)cmd TypeResponse:(TypeResponse)response
{
    NSString *requestURL = [self RequestWithCMD:cmd Parameter:NULL String:NULL];
    NSLog(@"%@", requestURL);
    
    [CLNetworkingKit RequestWithURL:requestURL parameters:NULL requestmethod:RequestMethodGet contenttype:ContentTypesXML responseblock:^(id responseObj, BOOL success, NSError *error) {
        
        if (error) {
            
            if (response)
                response(NO, -1, self.state);
            
        }else {
            
            if ([responseObj isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *dict = (NSDictionary *)responseObj;
                
                NSString *cmdString= dict[@"cmd"];
                NSString *status   = dict[@"status"];
                NSString *value    = dict[@"value"];
                
                switch ([cmdString integerValue]) {
                    case 2016:
                        if ([status integerValue]==0&&[value integerValue]>0) {
                            response(YES, CameraStateRecord, CameraStateRecord);
                        }else if ([status integerValue]==0&&[value integerValue]==0){
                            response(YES, CameraStateConnected, CameraStateConnected);
                        }else{
                            response(YES, CameraStateDisConnected, CameraStateDisConnected);
                        }
                        break;
                    case 3024:
                        if ([status integerValue]==0&&[value integerValue]>0){
                            response(YES, CarStateHave, self.state);
                        }else if ([status integerValue]==0){
                            response(YES, CarStateNot, self.state);
                        }else{
                            response(NO, CarStateNon, self.state);
                        }
                    default:
                        break;
                }
            }
            
        }
        
    }];
    
}


#pragma mark - cmd request
/*!
 @method
 @abstract 连接行车记录仪,判断连接状态
 @discussion 根据行车记录仪是否在录制判断连接状态
             判断录制命令 cmd=2016
             返回 value !=0 就是录制状态
 @result void
 */
- (void)ConnectCamera:(TypeResponse)response{
    [self RequestCMD:WIFIAPP_CMD_MOVIE_RECORDING_TIME TypeResponse:^(BOOL success, int type, CameraState eyeState) {
        self.state = type;
        
        if (self.cameraState == CameraStateConnected) {
            
            [self getQuereyStatus];
            
        }
        
        if (response)
            response(success, type, eyeState);
        
    }];
}

/*!
 @method
 @abstract 设置录制状态
 @discussion 开始录制和停止录制,录制 cmd = 2001
 @param recordStatus 开始或者停止录制
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)setRecordStatus:(BOOL)recordStatus response:(BoolenResponse)response
{
    [self RequestCMD:WIFIAPP_CMD_RECORD parameter:[self covertStringWithBoolen:recordStatus] string:NULL BoolenResponse:^(BOOL success, CameraState eyeState) {
        
        if (success) {
            
            if (recordStatus) {
                
                [self setState:CameraStateRecord];
                
            }else {
                
                [self setState:CameraStateConnected];
                
                [self getQuereyStatus];
                    
            }
            
            if (response)
                response(success,self.cameraState);
            
        } else {
            
            response(success, eyeState);
            
        }
        
    }];
}

/*!
 @method
 @abstract 设置预览状态
 @discussion 开始预览和停止预览,录制 cmd = 2015
 @param recordStatus 开始或者停止预览
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)setLiveStatus:(BOOL)liveStatus response:(BoolenResponse)response
{
    [self RequestCMD:WIFIAPP_CMD_MOVIE_LIVEVIEW_START parameter:[self covertStringWithBoolen:liveStatus] string:NULL BoolenResponse:^(BOOL success, CameraState eyeState) {
        if (response)
            response(success,eyeState);
    }];
}

/*!
 @method
 @abstract 设置行车记录仪播放状态
 @discussion 设置行车记录仪播放状态,有拍照,录像,后台播放等 cmd = 3001
 @param model emnu 行车记录仪类型枚举
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)changeMovieModel:(WIFI_APP_MODE_CMD)model response:(BoolenResponse)response{
    [self RequestCMD:WIFIAPP_CMD_MODECHANGE parameter:[self covertStringWithType:model] string:NULL BoolenResponse:^(BOOL success, CameraState eyeState) {
        if (response)
            response(success, eyeState);
    }];
}

/*!
 @method
 @abstract 拍照
 @discussion 首先判断连接状态,如果是录制状态就截屏拍照,如果非录制状态就进入PhotoMode下然后拍照然后转变回来。截屏拍照 cmd = 2017 拍照 cmd = 1001
 @param response DataResponse 参数1 是否成功 参数2 id数据 参数3 连接状态
 @result void
 */
- (void)TakeCapture:(DataResponse)response{
    
    switch (self.cameraState) {
            
        case CameraStateDisConnected:
            
            response(NO, NULL, CameraStateDisConnected);
            
            break;
            
        case CameraStateConnected:{
            
            [self takePhoto:^(BOOL success, id obj, CameraState eyeState) {
                
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    
                    NSDictionary *dict     = (NSDictionary *)obj;
                    
                    NSString *status       = dict[@"status"];
                    
                    if ([status intValue]!=0) {
                        
                        response(YES, NULL, eyeState);
                        
                    } else {
                        if (success) {
                            [self cuptureAudio];
                            
                            NSDictionary *fileDict = dict[@"file"];
                            NSString *filePath     = fileDict[@"fpath"];
                            NSString *fileName     = fileDict[@"name"];
                            NSString *furl         = [[NSString stringWithFormat:@"%@%@", NovatekIP, [[filePath stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] stringByReplacingOccurrencesOfString:@"A:" withString:@""]] lowercaseString];
                            NSString *name    = [[fileName stringByReplacingOccurrencesOfString:@"_" withString:@""] lowercaseString];
                            
                            CameraFile *model = [[CameraFile alloc] initQueueWithDownloadURL:furl folder:LOCAL_FILE_LIST[0] name:name];
                            // 处理
                            model.name   = name;
                            model.fileType   = CameraFileTypePhoto;
                            model.fileURL    = furl;
                            model.fileNailURL = [NSString stringWithFormat:@"%@?custom=%@&cmd=%@", model.fileURL, CUSTOM, WIFIAPP_CMD_THUMB];
                            
                            response(YES, model, eyeState);
                            
                        }else{
                            
                            response(NO, NULL, eyeState);
                            
                        }
                        
                    }
                    
                }
                
            }];
        }
            break;
        case CameraStateRecord:{
            
            [self screenCut:^(BOOL success, CameraState eyeState) {
                
                if (success) {
                    
                    NSDate *date = [NSDate date];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"YYYYMMddHHmmss"];
                    NSString *dateString = [formatter stringFromDate:date];
                    dateString = [NSString stringWithFormat:@"%@_001.jpg", dateString];
                    NSString *furl = [NSString stringWithFormat:@"%@%@", NovatekIP, TakeCutURL];
                    CameraFile *model = [[CameraFile alloc] initQueueWithDownloadURL:furl folder:LOCAL_FILE_LIST[0] name:dateString];
                    
                    model.name   = dateString;
                    model.fileType   = CameraFileTypePhoto;
                    model.fileURL    = furl;
                    
                    [self cuptureAudio];
                    
                    response(YES, model, eyeState);
                    
                }else{
                    
                    response(NO, NULL, eyeState);
                    
                }
                
            }];
        }
            break;
        default:
            break;
    }
    
}

/*!
 @method
 @abstract 录制下截屏拍照
 @discussion 录制下截屏拍照,拍照 cmd = 2017
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)screenCut:(BoolenResponse)response
{
    [self RequestCMD:WIFIAPP_CMD_MOVIE_TRIGGER_RAW BoolenResponse:^(BOOL success, CameraState eyeState) {
        if (response)
            response(success, eyeState);
    }];
}

/*!
 @method
 @abstract 预览下拍照
 @discussion 预览下拍照,拍照 cmd = 1001
 @param response DataResponse 参数1 是否成功 参数2 id数据
 @result void
 */
- (void)takePhoto:(DataResponse)response
{
    [self changeMovieModel:WIFI_APP_MODE_PHOTO response:NULL];
    [self RequestCMD:WIFIAPP_CMD_CAPTURE DataResponse:^(BOOL success, id obj, CameraState eyeState) {
       // 数据处理->统一格式,使用Model
        [self changeMovieModel:WIFI_APP_MODE_MOVIE response:^(BOOL success, CameraState eyeState) {
            NSLog(@"success = %d", success);
            if (response) {
                response(success, obj, eyeState);
            }

        }];
    }];
    
}

/*!
 @method
 @abstract 设置系统时间
 @discussion 设置系统时间, cmd = 3011
 @param data 系统时间 cmd 3005 & 3006
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)setSystemDate:(BoolenResponse)response{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:date];
    
    NSArray *dateTime = [dateString componentsSeparatedByString:@" "];
    
    [self RequestCMD:WIFIAPP_CMD_SET_DATE parameter:NULL string:[dateTime firstObject] BoolenResponse:^(BOOL success, CameraState eyeState) {
        if (response) {
            if (success) {
                [self RequestCMD:WIFIAPP_CMD_SET_TIME parameter:NULL string:[dateTime lastObject] BoolenResponse:^(BOOL success, CameraState eyeState) {
                    response(success, eyeState);
                }];
            }else{
                response(success, eyeState);
            }
        }
    }];
}
/*!
 @method
 @abstract 获取系统时间
 @discussion 获取系统时间 【暂无】
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)getSystemDate:(BoolenResponse)response{
    // 联咏不存在
}
/*!
 @method
 @abstract 恢复出厂设置
 @discussion 恢复出厂设置, cmd = 3011
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)resetSystem:(BoolenResponse)response{
    [self RequestCMD:WIFIAPP_CMD_SYSRESET BoolenResponse:^(BOOL success, CameraState eyeState) {
        if (response)
            response(success, eyeState);
    }];
}

/*!
 @method
 @abstract 设置自动录音
 @discussion 设置自动录音,cmd = 2001
 @param autoRecording 是否自动录音
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)setAutoRecording:(BOOL)autoRecording response:(BoolenResponse)response{
    
    [self RequestCMD:WIFIAPP_CMD_MOVIE_AUDIO parameter:[self covertStringWithBoolen:autoRecording] string:NULL BoolenResponse:^(BOOL success, CameraState eyeState) {
        if (response)
            response(success, eyeState);
    }];
}

/*!
 @method
 @abstract 获取自动录音状态
 @discussion 获取自动录音状态,cmd = 2001 query cmd = 3014
 @param recordStatus 开启或关闭自动录音
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)getAutoRecording:(TypeResponse)response{
    [self QueryCMD:WIFIAPP_CMD_QUERY_CUR_STATUS StatusCMD:WIFIAPP_CMD_MOVIE_AUDIO TypeResponse:^(BOOL success, int type, CameraState eyeState) {
        if (response)
            response(success, type, eyeState);
    }];
}

/*!
 @method
 @abstract 设置自动录制状态
 @discussion 开始自动录制和停止自动录制,cmd = 2012
 @param autoRecord 开始或者停止自动录制
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)setAutoRecord:(BOOL)autoRecord response:(BoolenResponse)response{
    [self RequestCMD:WIFIAPP_CMD_SET_AUTO_RECORDING parameter:[self covertStringWithBoolen:autoRecord] string:NULL BoolenResponse:^(BOOL success, CameraState eyeState) {
        if (response)
            response(success, eyeState);
    }];
}

/*!
 @method
 @abstract 获取自动录制状态
 @discussion 获取自动录制状态,cmd = 2013 query cmd = 3014
 @param recordStatus 开启或者关闭自动录制
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)getAutoRecord:(TypeResponse)response{
    [self QueryCMD:WIFIAPP_CMD_QUERY_CUR_STATUS StatusCMD:WIFIAPP_CMD_SET_AUTO_RECORDING TypeResponse:^(BOOL success, int type, CameraState eyeState) {
        if (response)
            response(success, type, eyeState);
    }];
}

/*!
 @method
 @abstract 设置录制视频分辨率
 @discussion 设置录制视频分辨率,cmd = 2002
 @param recordSize 分辨率参数
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)setRecordSize:(MOVIE_SIZE)recordSize response:(BoolenResponse)response{
    [self RequestCMD:WIFIAPP_CMD_MOVIE_REC_SIZE parameter:[self covertStringWithType:recordSize] string:NULL BoolenResponse:^(BOOL success, CameraState eyeState) {
        if (response)
            response(success, eyeState);
    }];
}

/*!
 @method
 @abstract 获取录制视频分辨率
 @discussion 获取录制视频分辨率
            通过Query Current Status获得所有设置的状态,然后再筛选特例
 @param response TypeResponse: 参数1 是否成功 参数2 状态
 @result 空
 */
- (void)getRecordSize:(TypeResponse)response{
    [self QueryCMD:WIFIAPP_CMD_QUERY_CUR_STATUS StatusCMD:WIFIAPP_CMD_MOVIE_REC_SIZE TypeResponse:^(BOOL success, int type, CameraState eyeState) {
        if (response)
            response(success, type, eyeState);
    }];
}

/*!
 @method
 @abstract 设置预览视频分辨率
 @discussion 设置预览视频分辨率,cmd = 2010
 @param recordSize 分辨率参数
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)setLiveSize:(MOVIE_LIVE_SIZE)liveSize response:(BoolenResponse)response{
    [self RequestCMD:WIFIAPP_CMD_MOVIE_LIVEVIEW_SIZE parameter:[self covertStringWithType:liveSize] string:NULL BoolenResponse:^(BOOL success, CameraState eyeState) {
        if (response)
            response(success, eyeState);
    }];
}

/*!
 @method
 @abstract 获取预览视频分辨率
 @discussion 获取预览视频分辨率
 通过Query Current Status获得所有设置的状态,然后再筛选特例
 @param response TypeResponse: 参数1 是否成功 参数2 状态
 @result 空
 */
- (void)getLiveSize:(TypeResponse)response{
    [self QueryCMD:WIFIAPP_CMD_QUERY_CUR_STATUS StatusCMD:WIFIAPP_CMD_MOVIE_LIVEVIEW_SIZE TypeResponse:^(BOOL success, int type, CameraState eyeState) {
        if (response)
            response(success, type, eyeState);
    }];
}

/*!
 @method
 @abstract 设置照片分辨率
 @discussion 设置照片分辨率,cmd = 1002
 @param recordSize 分辨率参数
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)setPhotoSize:(PHOTO_SIZE)photoSize response:(BoolenResponse)response{
    [self RequestCMD:WIFIAPP_CMD_CAPTURESIZE parameter:[self covertStringWithType:photoSize] string:NULL BoolenResponse:^(BOOL success, CameraState eyeState) {
        if (response)
            response(success, eyeState);
    }];
}

/*!
 @method
 @abstract 获取照片分辨率
 @discussion 获取照片分辨率
 通过Query Current Status获得所有设置的状态,然后再筛选特例
 @param response TypeResponse: 参数1 是否成功 参数2 状态
 @result 空
 */
- (void)getPhotoSize:(TypeResponse)response{
    [self QueryCMD:WIFIAPP_CMD_QUERY_CUR_STATUS StatusCMD:WIFIAPP_CMD_CAPTURESIZE TypeResponse:^(BOOL success, int type, CameraState eyeState) {
        if (response)
            response(success, type, eyeState);
    }];
}

/*!
 @method
 @abstract 设置重力传感器
 @discussion 设置重力传感器,cmd = 2011
 @param recordSize 分辨率参数
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)setSensititySize:(GSENSOR)sensititySize response:(BoolenResponse)response{
    [self RequestCMD:WIFIAPP_CMD_MOVIE_GSENSOR_SENS parameter:[self covertStringWithType:sensititySize] string:NULL BoolenResponse:^(BOOL success, CameraState eyeState) {
        if (response)
            response(success, eyeState);
    }];
}

/*!
 @method
 @abstract 获取重力传感器值
 @discussion 获取重力传感器值
 通过Query Current Status获得所有设置的状态,然后再筛选特例
 @param response TypeResponse: 参数1 是否成功 参数2 状态
 @result 空
 */
- (void)getSensititySize:(TypeResponse)response{
    [self QueryCMD:WIFIAPP_CMD_QUERY_CUR_STATUS StatusCMD:WIFIAPP_CMD_MOVIE_GSENSOR_SENS TypeResponse:^(BOOL success, int type, CameraState eyeState) {
        if (response)
            response(success, type, eyeState);
    }];
}

/*!
 @method
 @abstract 设置图像曝光率
 @discussion 设置图像曝光率,cmd = 2005
 @param recordSize 分辨率参数
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)setExposureSize:(EXPOSURE)exposureSize response:(BoolenResponse)response{
    [self RequestCMD:WIFIAPP_CMD_MOVIE_EV parameter:[self covertStringWithType:exposureSize] string:NULL BoolenResponse:^(BOOL success, CameraState eyeState) {
        if (response)
            response(success, eyeState);
    }];
}

/*!
 @method
 @abstract 获取图像曝光率
 @discussion 获取图像曝光率
 通过Query Current Status获得所有设置的状态,然后再筛选特例
 @param response TypeResponse: 参数1 是否成功 参数2 状态
 @result 空
 */
- (void)getExposureSize:(TypeResponse)response{
    [self QueryCMD:WIFIAPP_CMD_QUERY_CUR_STATUS StatusCMD:WIFIAPP_CMD_MOVIE_EV TypeResponse:^(BOOL success, int type, CameraState eyeState) {
        if (response)
            response(success, type, eyeState);
    }];
}

/*!
 @method
 @abstract 设置用户名和密码
 @discussion 设置用户名和密码, cmd = 2003 | 3004
 @param ssidAndPwd  新的wifi名和密码
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)setSSIDandPWD:(CameraInfo *)ssidAndPwd response:(BoolenResponse)response{
    if (ssidAndPwd.name&&ssidAndPwd.password) {
        [self RequestCMD:WIFIAPP_CMD_SET_SSID parameter:NULL string:ssidAndPwd.name BoolenResponse:^(BOOL success, CameraState eyeState) {
            if (response){
                if (success) {
                    [self RequestCMD:WIFIAPP_CMD_SET_PASSPHRASE parameter:NULL string:ssidAndPwd.password BoolenResponse:^(BOOL success, CameraState eyeState) {
                        response(success, eyeState);
                    }];
                }else{
                    response (success, eyeState);
                }
            }
            
        }];
    }else{
        NSString *cmdString= WIFIAPP_CMD_SET_SSID; // 3003
        NSString *string   = ssidAndPwd.name;
        if (!string) {
            cmdString = WIFIAPP_CMD_SET_PASSPHRASE;
            string    = ssidAndPwd.password;
        }
        [self RequestCMD:cmdString parameter:NULL string:string BoolenResponse:^(BOOL success, CameraState eyeState) {
            if (response)
                response(success, eyeState);
        }];
    }
}

/*!
 @method
 @abstract 获取设备wifi名和密码
 @discussion 获取设备wifi名和密码, cmd = 3029
 @param response DataResponse 参数1 是否成功 参数2 id数据
 @result void
 */
- (void)getSSIDandPWD:(DataResponse)response{
    [self RequestCMD:WIFIAPP_CMD_LIST_CAMERE DataResponse:^(BOOL success, id obj, CameraState eyeState) {
        if (response){
            
            NSDictionary *dict = (NSDictionary *)obj;
            
            NSString *status = dict[@"status"];
            
            if (status) {
                
                response(NO, NULL, eyeState);
                
            }else {
                if (success) {
                    
                    CameraInfo *model = [[CameraInfo alloc] init];
                    // 对model操作
                    model.name = dict[SSID_STRING_VALUE];
                    model.password = dict[PWD_STRING_VALUE];
                    response(success, model, eyeState);
                }else{
                    response(success, obj, eyeState);
                }
            }
            
        }
    }];
}

/*!
 @method
 @abstract 获取SD卡使用信息
 @discussion cmd = 3017
 @param response DataResponse 参数1 是否成功 参数2 id数据
 @result void
 */
- (void)getDiskFreeSpace:(DataResponse)response
{
    [self RequestCMD:WIFIAPP_CMD_DISK_FREE_SPACE DataResponse:^(BOOL success, id obj, CameraState eyeState) {
        if (response){
            if (success) {
                
                NSDictionary *dict = (NSDictionary *)obj;
                NSNumber *value = @([dict[@"value"] floatValue]);
                response(success, value, eyeState);
                
            }else{
                
                response(success, obj, eyeState);
                
            }
            
        }
    }];
}

/*!
 @method
 @abstract 获取文件列表
 @discussion 获取文件列表, cmd = 3015
 @param response DataResponse 参数1 是否成功 参数2 id数据
 @result void
 */
- (void)getFileList:(DataResponse)response{
    [self RequestCMD:WIFIAPP_CMD_FILELIST DataResponse:^(BOOL success, id obj, CameraState eyeState) {
        if (response) {
            
            if ([obj isKindOfClass:[NSDictionary class]]) {
                
                response(success, @[], eyeState);
                
            }else {
                
                if (success) {
                    NSArray *fileList = (NSArray *)obj;
                    NSMutableArray *files = [[NSMutableArray alloc] init];
                    for (NSDictionary *dict in fileList) {
                        NSDictionary *file = dict[@"allfile"][@"file"];
                        NSString *fileName = file[@"name"];
                        NSString *fileSize = file[@"size"];
                        NSString *filePath = file[@"fpath"];
                        
                        NSArray *isTrue = [fileName componentsSeparatedByString:@"_"];
                        if (isTrue.count>=3) {
                            NSString *furl = [[NSString stringWithFormat:@"%@%@", NovatekIP, [[filePath stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] stringByReplacingOccurrencesOfString:@"A:" withString:@""]] lowercaseString];
                            NSString *name = [[fileName stringByReplacingOccurrencesOfString:@"_" withString:@""] lowercaseString];
                            
                            CameraFile *model = [[CameraFile alloc] initQueueWithDownloadURL:furl name:name];
                            // 对model操作
                            model.name = name;
                            model.fileSize = @([fileSize integerValue]);
                            model.fileURL  = furl;
                            model.fileNailURL = [NSString stringWithFormat:@"%@?custom=%@&cmd=%@", model.fileURL, CUSTOM, WIFIAPP_CMD_THUMB];
                            
                            [files addObject:model];
                        }
                    }
                    
                    response(success, files, eyeState);
                }else{
                    response(success, obj, eyeState);
                }
                
            }
        }
        
    }];
}

/*!
 @method
 @abstract 删除一张特定图片
 @discussion 删除一张特定图片,录制 cmd = 4003
 @param file 图片的地址
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)deleteFile:(CameraFile *)file response:(BoolenResponse)response{
    [self RequestCMD:WIFIAPP_CMD_DELETE_ONE parameter:NULL string:file.path BoolenResponse:^(BOOL success, CameraState eyeState) {
        if (response)
            response(success, eyeState);
    }];
}

/*!
 @method
 @abstract 删除所有图片
 @discussion 删除所有图片, cmd = 4004
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)deleteFileList:(BoolenResponse)response{
    [self RequestCMD:WIFIAPP_CMD_DELETE_ALL BoolenResponse:^(BOOL success, CameraState eyeState) {
        if (response)
            response(success, eyeState);
    }];
}

/*!
 @method
 @abstract 获取SD卡状态
 @discussion 获取SD卡状态, cmd = 3024
 @param response TypeResponse 参数1 是否成功 参数2 type
 @result void
 */
- (void)getCardState:(TypeResponse)response{
    [self RequestCMD:WIFIAPP_CMD_GET_CARD_STATUS TypeResponse:^(BOOL success, int type, CameraState eyeState) {
        if (response)
            response(success, type, eyeState);
    }];
}

/*!
 @method
 @abstract 获取SD卡状态
 @discussion 获取SD卡状态, cmd = 3024
 @param response TypeResponse 参数1 是否成功 参数2 type
 @result void
 */
- (void)removeUser:(BoolenResponse)response{
    
    [self RequestCMD:WIFIAPP_CMD_REMOVE_USER BoolenResponse:^(BOOL success, CameraState eyeState) {
        
        if (response) response(success, eyeState);
        
    }];
    
}

/*!
 @method
 @abstract 初始化SD卡
 @discussion 初始化SD卡, cmd = 3010
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)resetCard:(BoolenResponse)response{
    [self RequestCMD:WIFIAPP_CMD_FORMAT parameter:@"1" string:NULL BoolenResponse:^(BOOL success, CameraState eyeState) {
        if (response)
            response(success, eyeState);
    }];
}

/*!
 @method
 @abstract 获取录制状态
 @discussion 获取录制状态
 @result void
 */
- (void)getRecordState:(DataResponse)response{
    // 已实现
}

/*!
 @method
 @abstract 获取版本信息
 @discussion 获取版本信息,录制 cmd = 3012
 @param response DataResponse 参数1 是否成功 参数2 id数据
 @result void
 */
- (void)getVersion:(DataResponse)response{
    [self RequestCMD:WIFIAPP_CMD_VERSION DataResponse:^(BOOL success, id obj, CameraState eyeState) {
        if (response) {
            if (success) {
                NSDictionary *dict = (NSDictionary *)obj;
                CameraVersion *version = [[CameraVersion alloc] init];
                // 处理
                version.version  = dict[@"string"];
                response(success, version, eyeState);
            }else{
                response(success, obj, eyeState);
            }
        }
    }];
}

/*!
 @method
 @abstract 设置录制状态
 @discussion 开始录制和停止录制,录制 cmd = 2001
 @param recordStatus 开始或者停止录制
 @param response DataResponse 参数1 是否成功 参数2 id数据
 @result void
 */
- (void)updateVersion:(DataResponse)response{
    if (response) {
        
    }
}


@end
