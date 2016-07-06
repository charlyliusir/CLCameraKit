//
//  AitCamera.m
//  Cheche
//
//  Created by autobot on 16/5/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AitCamera.h"
#import "AITCameraCommand.h"
#import <AudioToolbox/AudioToolbox.h>
#import "GCDAsyncUdpSocket.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#include <CoreFoundation/CoreFoundation.h>
#include <sys/socket.h>
#include <netinet/in.h>

static NSString *DEFAULT_RTSP_URL_AV1   = @"/liveRTSP/av1" ;
static NSString *DEFAULT_RTSP_URL_V1    = @"/liveRTSP/v1" ;
static NSString *DEFAULT_RTSP_URL_AV2    = @"/liveRTSP/av2" ;
static NSString *DEFAULT_RTSP_URL_AV4    = @"/liveRTSP/av4" ;
static NSString *DEFAULT_MJPEG_PUSH_URL = @"/cgi-bin/liveMJPEG" ;

@interface AitCamera ()<GCDAsyncUdpSocketDelegate>

@property (nonatomic, strong)GCDAsyncUdpSocket *updSocket;

@end

@implementation AitCamera
@synthesize updSocket;

#pragma mark -- request method

- (void)connectSocket
{
    [self disConnectSocket];
    updSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [updSocket setIPv4Enabled:YES];
    [updSocket setPreferIPv4];
    [updSocket setIPv6Enabled:NO];
    
    int port = 49142;//[portField.text intValue];
    
    NSError *error = nil;
    struct sockaddr_in ip;
    ip.sin_family = AF_INET;
    //    ip.sin_addr.s_addr = inet_addr("0.0.0.0");
    
    ip.sin_addr.s_addr = inet_addr("0.0.0.0");
    ip.sin_port = htons(port);
    ip.sin_len = sizeof(struct sockaddr_in);
    NSData * discoveryHost = [NSData dataWithBytes:&ip length:ip.sin_len];
    
    if (![updSocket bindToAddress:discoveryHost error: &error])
    {
        NSLog(@"Error starting server bind address");
        return;
    }
    if (![updSocket beginReceiving:&error])
    {
        [self disConnectSocket];
        NSLog(@"Error starting server recv");
        return;
    }
    
    GCDAsyncUdpSocketReceiveFilterBlock filter = ^BOOL (NSData *data, NSData *address, id *context) {
        
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"FILTER %@", dataString);
        NSDictionary *dict = [AITCameraCommand buildResultDictionary:dataString];
        NSLog(@"cutName: %@", dict[@"CURNAME"]);
        
        if ([dict[@"POWER"] isEqualToString:@"POWEROFF"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CAMERA_UNINORIGIN object:dict[@"CURNAME"]];
        }
        
        return true;
    };
    [self setFilterRecvDataBlock:filter];
    
}

- (void)disConnectSocket
{
    
    if (updSocket) {
        
        [updSocket close];
        [updSocket setDelegate:NULL];
        
    }
    
}

- (void)setFilterRecvDataBlock:(GCDAsyncUdpSocketReceiveFilterBlock)filter
{
    dispatch_queue_t    dispatch_q = NULL;
    if (filter != nil)
        dispatch_q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [updSocket setReceiveFilter:filter
                       withQueue:dispatch_q];
}


- (void)RequestURL:(NSString *)url DataResponse:(DataResponse)response
{
    [CLNetworkingKit RequestWithURL:url parameters:NULL requestmethod:RequestMethodGet contenttype:ContentTypesText responseblock:^(id responseObj, BOOL success, NSError *error) {
        
        if (error) {
            
            response(NO, NULL, self.cameraState);
            
        }else if([responseObj hasPrefix:@"0\nOK"]){

            response(YES,responseObj, self.cameraState);
            
        }else {
            
            response(NO, NULL, self.cameraState);
            
        }
     
    }];
    
}

- (void)RequestXMLURL:(NSString *)url DataResponse:(DataResponse)response
{
    
    [CLNetworkingKit RequestWithURL:url parameters:NULL requestmethod:RequestMethodGet contenttype:ContentTypesXML responseblock:^(id responseObj, BOOL success, NSError *error) {
        
        if (error) {
            
            response(NO, NULL, self.cameraState);
            
        }else{
            
            response(YES,responseObj, self.cameraState);
            
        }
        
    }];
    
}

- (NSMutableArray *)unpackFileList:(id)fileList
{
    NSMutableArray *files = [[NSMutableArray alloc] init];
    if ([fileList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dict in fileList) {
            NSDictionary *fileDic = dict[@"file"];
            NSInteger fileSize = [[fileDic objectForKey:@"size"] integerValue];
            NSString *OriginName = [fileDic objectForKey:@"name"];
            NSString *path = [self formattedFpathString:OriginName];
            NSString *name = [[self formattedNameString:OriginName] lowercaseString];
            NSString *furl  = [NSString stringWithFormat:@"http://%@%@",[AITCameraCommand CAMERA_IP],path];
            NSString *url = [[NSBundle mainBundle] pathForResource:@"bg_drivingrecord_photo_default.png" ofType:nil];
            
            CameraFile *model  = [[CameraFile alloc] initQueueWithDownloadURL:furl name:name];
            // 对model操作
            model.fileURL      = furl;
            model.fileSize = @(fileSize);
            model.fileNailURL = [NSString stringWithFormat:@"file://%@",url];
            [files addObject:model];
        }
        return files;
    }else if ([fileList isKindOfClass:[NSDictionary class]] && fileList[@"file"]) {
        NSDictionary *fileDic = fileList[@"file"];
        NSInteger fileSize = [[fileDic objectForKey:@"size"] integerValue];
        NSString *OriginName = [fileDic objectForKey:@"name"];
        NSString *path = [self formattedFpathString:OriginName];
        NSString *name = [[self formattedNameString:OriginName] lowercaseString];
        NSString *furl  = [NSString stringWithFormat:@"http://%@%@",[AITCameraCommand CAMERA_IP],path];
        NSString *url = [[NSBundle mainBundle] pathForResource:@"bg_drivingrecord_photo_default.png" ofType:nil];
        
        CameraFile *model  = [[CameraFile alloc] initQueueWithDownloadURL:furl name:name];
        // 对model操作
        model.fileURL      = furl;
        model.fileSize = @(fileSize);
        model.fileNailURL = [NSString stringWithFormat:@"file://%@",url];
        [files addObject:model];
        return files;
    }
    else {
        return files;
    }
}



- (NSString *)formattedNameString:(NSString *)name
{
    NSArray *subStr = [name componentsSeparatedByString:@"/"];
    NSString *last = subStr.lastObject;
    NSUInteger index = 0;
    if ([last hasPrefix:@"FILE"]) {
        index = 4;
    }else if ([last hasPrefix:@"IMG"]) {
        index = 3;
    }else {
        
    }
    NSString *str1 = [last substringFromIndex:index];
    str1 = [str1 stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSMutableString *str2 = [@"20" stringByAppendingString:str1].mutableCopy;
//    [str2 insertString:@"_" atIndex:4];
//    [str2 insertString:@"_" atIndex:9];
//    [str2 insertString:@"_" atIndex:16];
    return str2;
    
}
- (NSString *)formattedFpathString:(NSString *)name
{
    return [NSString stringWithFormat:@"%@",name];
}
- (NSString *)formattedTimeString:(NSString *)name
{
    return [name stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
}

- (int)getMenuId:(NSString *)val MenuMap:(NSArray*)map
{
    int     i;
    NSRange rng;
    for (i = 0; i < [map count]; i++) {
        rng.length   = ([val length] > [map[i] length])? [map[i] length] : [val length];
        rng.location = 0;
        if ([val compare:map[i] options:NSCaseInsensitiveSearch|NSLiteralSearch range:rng] == NSOrderedSame)
            return i;
    }
    return -1;
}

- (NSDictionary *)unpackStatusString:(NSString *)result
{
    NSArray *lines;
    int nVideoRes = 0;
    int nImageRes = 0;
    int nEV = 0;
    int nMTD = 0;
    NSString *ver = nil;
    NSCharacterSet *sep = [NSCharacterSet characterSetWithCharactersInString:@"."];
    lines = [result componentsSeparatedByString:@"\n"];
    for (NSString *line in lines) {
        NSArray *properties = [line componentsSeparatedByString:@"="];
        if ([properties count] != 2)
            continue;
        NSRange rng = [[properties objectAtIndex:0] rangeOfCharacterFromSet:sep options:NSBackwardsSearch];
        if (rng.location == 0 || rng.length >= [[properties objectAtIndex:0] length])
            continue;
        rng.location++;
        rng.length = [[properties objectAtIndex:0] length] - rng.location;
        NSString *key = [[properties objectAtIndex:0] substringWithRange:rng];
        if ([properties count] != 2)
            continue;
        NSString* sz = [NSString alloc];
        sz = [properties objectAtIndex:1];
        if ([key caseInsensitiveCompare:[AITCameraCommand PROPERTY_VideoRes]] == NSOrderedSame) {
            NSArray * map = [NSArray arrayWithObjects:@"1080P30", @"720P60", @"720P30", @"VGA", nil];
            nVideoRes = [self getMenuId:sz MenuMap:map];
            if (nVideoRes < 0) {
                nVideoRes = (int)map.count - 1;
            }
        } else if ([key caseInsensitiveCompare:[AITCameraCommand PROPERTY_mtd]] == NSOrderedSame) {
            NSArray * map = [NSArray arrayWithObjects:@"Off", @"Low", @"Middle", @"High", nil];
            nMTD = [self getMenuId:sz MenuMap:map];
            if (nMTD < 0) {
                nMTD = 0;
            }
            NSLog(@"MTD %d", nMTD);
        } else if ([key caseInsensitiveCompare:[AITCameraCommand PROPERTY_ImageRes]] == NSOrderedSame) {
            NSArray * map = [NSArray arrayWithObjects:@"3MP",@"2MP",@"1.2MP",@"VGA", nil];
            nImageRes = [self getMenuId:sz MenuMap:map];
            if (nImageRes < 0) {
                nImageRes = (int)map.count - 1;
            }
            NSLog(@"ImageRes %d", nImageRes);
        }  else if ([key caseInsensitiveCompare:[AITCameraCommand PROPERTY_ev]] == NSOrderedSame) {
            NSArray *map = [NSArray arrayWithObjects:@"EVN200", @"EVN167", @"EVN133", @"EVN100", @"EVN067", @"EVN033", @"EV0", @"EVP033", @"EVP067", @"EVP100", @"EVP133", @"EVP167", @"EVP200", nil];
            nEV = [self getMenuId:sz MenuMap:map];
            if (nEV < 0) {
                nEV = 6;
            }
            NSLog(@"EV %d", nEV);
        }else if([key caseInsensitiveCompare:[AITCameraCommand PROPERTY_FWversion]] == NSOrderedSame) {
            ver = sz;
        }
    }
    NSDictionary *dict = @{
                           @"imagesizes":[NSString stringWithFormat:@"%d",nImageRes],
                           @"livesizes":@"0",
                           @"ev":[NSString stringWithFormat:@"%d",nEV],
                           @"mtd":[NSString stringWithFormat:@"%d",nMTD],
                           @"recordsizes":[NSString stringWithFormat:@"%d",nVideoRes],
                           @"version":ver
                           };
    return dict;
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
    [self getQuereyStatus:NULL];
}

- (void)getQuereyStatus:(void(^)(BOOL success))block
{
    NSString *url = [AITCameraCommand commandQuerySettings];
    [self RequestURL:url DataResponse:^(BOOL success, id obj, CameraState eyeState) {
        if (success) {
            NSString *data = (NSString *)obj;
            self.statusDic = [self unpackStatusString:data];
            if (block) block(YES);
        }else{
            if (block) block(NO);
        }
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
    NSString *url = [AITCameraCommand commandCameraSnapshotUrl];
    [self RequestURL:url DataResponse:^(BOOL success, id obj, CameraState eyeState) {
            if (success) {
                response(success, obj, eyeState);
            }else {
                response(success, obj, eyeState);
            }
    }];
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

#pragma mark -- camera method
/**
 *  获取实时流播放地址URL
 *
 *  @param response block块 返回播放地址 NSString类型
 */
- (void)getPerViewURL:(void(^)(NSString * previewURL))response AddressURL:(NSString *)addressURL
{
    NSString *url = [AITCameraCommand commandQueryPreviewStatusUrl];
    [self RequestURL:url DataResponse:^(BOOL success, id obj, CameraState eyeState) {
        if (success) {
            NSDictionary *dict = [AITCameraCommand buildResultDictionary:obj];
            if (dict != nil) {
                
                int rtsp = [[dict objectForKey:[AITCameraCommand PROPERTY_CAMERA_RTSP]] intValue];
                NSString *liveurl = nil;
                if (rtsp == 1) {
                    liveurl = [NSString stringWithFormat:@"rtsp://%@%@", addressURL, DEFAULT_RTSP_URL_AV1];
                }
                else if (rtsp == 2) {
                    liveurl = [NSString stringWithFormat:@"rtsp://%@%@", addressURL, DEFAULT_RTSP_URL_V1];
                }else if (rtsp == 3) {
                    liveurl = [NSString stringWithFormat:@"rtsp://%@%@", addressURL, DEFAULT_RTSP_URL_AV2];
                }else if (rtsp == 4) {
                    liveurl = [NSString stringWithFormat:@"rtsp://%@%@", addressURL, DEFAULT_RTSP_URL_AV4];
                }
                else {
                    liveurl = [NSString stringWithFormat:@"http://%@%@", addressURL, DEFAULT_MJPEG_PUSH_URL];
                }
                
                response(liveurl);
                NSLog(@"liveurl:%@", liveurl);
                
            }
        }
    }];

}

/*!
 @method
 @abstract 连接行车记录仪,判断连接状态
 @discussion 根据行车记录仪是否在录制判断连接状态
 @result void
 */
- (void)ConnectCamera:(TypeResponse)response{
    NSString *url = [AITCameraCommand commandQueryCameraRecordUrl];
    [self RequestURL:url DataResponse:^(BOOL success, id obj, CameraState eyeState) {
        if (success) {
            NSString *data = (NSString *)obj;
            NSDictionary *dict = [AITCameraCommand buildResultDictionary:data];
            if ([dict[@"Camera.Preview.MJPEG.status.record"] isEqualToString:@"Recording"]) {
                self.state = CameraStateRecord;
                response(YES,CameraStateRecord,self.state);
            }else if([dict[@"Camera.Preview.MJPEG.status.record"] isEqualToString:@"Standby"]){
                self.state = CameraStateConnected;
                response(YES,CameraStateConnected,self.state);
                if (!self.statusDic) {
                    [self getQuereyStatus];
                }
            }else {
                self.state = CameraStateDisConnected;
                response(YES,CameraStateDisConnected,self.state);
            }
        }else {
            self.state = CameraStateDisConnected;
            response(YES,CameraStateDisConnected,self.state);
        }
    }];
}
- (void)goRecord:(BoolenResponse)response{
    
    
}
/*!
 @method
 @abstract 设置录制状态
 @discussion 开始录制和停止录制,录制 cmd = 2001
 @param recordStatus 开始或者停止录制
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)setRecordStatus:(BOOL)recordStatus
               response:(BoolenResponse)response
{
    NSString *url = [AITCameraCommand commandCameraRecordUrl];
    [self RequestURL:url DataResponse:^(BOOL success, id obj, CameraState eyeState) {
        if (success) {
            if (eyeState == CameraStateConnected && recordStatus == YES) {
                [self setState:CameraStateRecord];
            }else if (eyeState == CameraStateRecord && recordStatus == NO) {
                [self setState:CameraStateConnected];
//                self.statusDic[@""] = @"0";
//                [self getQuereyStatus];
            }
            if (response)
                response(success,self.cameraState);
        }else {
            response(success,eyeState);
        }
    }];
}
/*!
 @method
 @abstract 设置行车记录仪播放状态
 @discussion 设置行车记录仪播放状态,有拍照,录像,后台播放等
 @param model emnu 行车记录仪类型枚举
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)changeMovieModel:(WIFI_APP_MODE_CMD)model
                response:(BoolenResponse)response
{
    if (response) {
        response(YES, self.state);
    }
}
- (void)stopRecord:(BoolenResponse)response{
    
    
}

- (void)changeBackPlay:(BoolenResponse)response{
    
}
/*!
 @method
 @abstract 拍照
 @discussion 首先判断连接状态,如果是录制状态就截屏拍照,如果非录制状态就进入PhotoMode下然后拍照然后转变回来。截屏拍照 cmd = 2017 拍照 cmd = 1001
 @param response DataResponse 参数1 是否成功 参数2 id数据 参数3 连接状态
 @result void
 */
- (void)TakeCapture:(DataResponse)response{
    [self takePhoto:^(BOOL success, id obj, CameraState eyeState) {
        if (success) {
            [self cuptureAudio];
        }
        CameraFile *file = [[CameraFile alloc]init];
        response(success, file, eyeState);
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
    [formatter setDateFormat:@"yyyy$MM$dd$HH$mm$ss"];
    NSString *currentTime = [formatter stringFromDate:date];
    NSString *url = [AITCameraCommand commandSetDateTime :currentTime] ;
    [self RequestURL:url DataResponse:^(BOOL success, id obj, CameraState eyeState) {
        if (response) {
            if (success) {
                response(success, eyeState);
            }else{
                response(success, eyeState);
            }
        }
    }];
}
/*!
 @method
 @abstract 恢复出厂设置
 @discussion 恢复出厂设置
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)resetSystem:(BoolenResponse)response{
    NSString *url = [AITCameraCommand commandReset] ;
    [self RequestURL:url DataResponse:^(BOOL success, id obj, CameraState eyeState) {
        if (response) {
            if (success) {
                [self getQuereyStatus:^(BOOL success) {
                    if (success) {
                        response(success, eyeState);
                    }else{
                        response(NO, eyeState);
                    }
                }];
                
            }else{
                response(success, eyeState);
            }
        }
    }];
}
/*!
 @method
 @abstract 设置自动录音
 @discussion 设置自动录音,
 @param autoRecording 是否自动录音
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)setAutoRecording:(BOOL)autoRecording
                response:(BoolenResponse)response{
    NSString *url = [AITCameraCommand commandSetAutoRecoding];
    [self RequestURL:url DataResponse:^(BOOL success, id obj, CameraState eyeState) {
        if (response) {
            if (success) {
                int recording = abs([self.statusDic[@"recording"] intValue]-1);
                NSMutableDictionary *dict = self.statusDic.mutableCopy;
                dict[@"recording"] = [NSString stringWithFormat:@"%d",recording];
                self.statusDic = dict.copy;
                response(success, eyeState);
            }else{
                response(success, eyeState);
            }
        }
    }];
}
/*!
 @method 
 @abstract 获取自动录音状态
 @discussion 获取自动录音状态
 @param recordStatus 开启或关闭自动录音
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)getAutoRecording:(TypeResponse)response{
    
    if ([[self.statusDic allKeys] containsObject:@"recording"]) {
        NSString *recording = self.statusDic[@"recording"];
        response(YES,[recording intValue],self.cameraState);
    }else {
        NSString *url = [AITCameraCommand commandGetAutoRecoding];
        
        [self RequestURL:url DataResponse:^(BOOL success, id obj, CameraState eyeState) {
            
            NSLog(@"%@", obj);
            if (success) {
                NSDictionary *dict = [AITCameraCommand buildResultDictionary:obj];
                NSString *key = [AITCameraCommand PROPERTY_AUTOVOLUE];
                NSString *res = dict[key];
                NSMutableDictionary *mutableDict = self.statusDic.mutableCopy;
                [mutableDict setObject:[NSString stringWithFormat:@"%d", [res isEqualToString:@"ON"]?1:0] forKey:@"recording"];
                
                self.statusDic = mutableDict.copy;
                NSString *recording = self.statusDic[@"recording"];
                response(YES,[recording intValue],self.cameraState);
            }else {
                response(NO,-1,self.cameraState);
            }
        }];
    }
}
/*!
 @method
 @abstract 设置自动录制状态
 @discussion 开始自动录制和停止自动录制,
 @param autoRecord 开始或者停止自动录制
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)setAutoRecord:(BOOL)autoRecord
             response:(BoolenResponse)response{
    response(NO, self.state);
}
/*!
 @method
 @abstract 获取自动录制状态
 @discussion 获取自动录制状态,
 @param recordStatus 开启或者关闭自动录制
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)getAutoRecord:(TypeResponse)response{
    response(NO, 0, self.state);
}
/*!
 @method
 @abstract 设置录制视频分辨率
 @discussion 设置录制视频分辨率,
 @param recordSize 分辨率参数
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)setRecordSize:(MOVIE_SIZE)recordSize
             response:(BoolenResponse)response{
    NSArray *videoSizeArr = @[@"1080P30", @"720P60", @"720P30", @"VGA"];
    if (recordSize >= videoSizeArr.count) {
        response(NO, self.state);
    }else {
    NSString *url = [AITCameraCommand commandSetVideoRes:videoSizeArr[recordSize]];
    [self RequestURL:url DataResponse:^(BOOL success, id obj, CameraState eyeState) {
        if (success) {
            
            NSMutableDictionary *dict = self.statusDic.mutableCopy;
            dict[@"recordsizes"] = [NSString stringWithFormat:@"%d",recordSize];
            self.statusDic = dict.copy;
            
            response(success, eyeState);
        }else {
            response(success, eyeState);
        }
    }];
    }
    
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
    if (self.statusDic) {
        NSString *recordsize = self.statusDic[@"recordsizes"];
        response(YES,[recordsize intValue],self.cameraState);
    }else {
        response(NO,-1,self.cameraState);
    }
}
/*!
 @method
 @abstract 设置预览视频分辨率
 @discussion 设置预览视频分辨率,
 @param recordSize 分辨率参数
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)setLiveSize:(MOVIE_LIVE_SIZE)liveSize
           response:(BoolenResponse)response{
    response(YES,self.cameraState);
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
    if (self.statusDic) {
        NSString *livesizes = self.statusDic[@"livesizes"];
        response(YES,[livesizes intValue],self.cameraState);
    }else {
        response(NO,-1,self.cameraState);
    }
}
/*!
 @method
 @abstract 设置照片分辨率
 @discussion 设置照片分辨率,
 @param recordSize 分辨率参数
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)setPhotoSize:(PHOTO_SIZE)photoSize
            response:(BoolenResponse)response{
    NSArray *photoSizeArr = @[@"3MP",@"2MP",@"1.2MP",@"VGA"];
    if (photoSize >= photoSizeArr.count) {
        response(NO,self.cameraState);
    }else {
        NSString *url = [AITCameraCommand commandSetImageRes:photoSizeArr[photoSize]];
        [self RequestURL:url DataResponse:^(BOOL success, id obj, CameraState eyeState) {
            if (success) {
                NSMutableDictionary *dict = self.statusDic.mutableCopy;
                dict[@"imagesizes"] = [NSString stringWithFormat:@"%d",photoSize];
                self.statusDic = dict.copy;
                response(success, eyeState);
            }else {
                response(success, eyeState);
            }
        }];
    }
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
    if (self.statusDic) {
        NSString *imagesizes = self.statusDic[@"imagesizes"];
        response(YES,[imagesizes intValue],self.cameraState);
    }else {
        response(NO,-1,self.cameraState);
    }
}
/*!
 @method
 @abstract 设置重力传感器
 @discussion 设置重力传感器,
 @param recordSize 分辨率参数
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)setSensititySize:(GSENSOR)sensititySize
                response:(BoolenResponse)response{
    NSArray *mtdArr = @[@"Off", @"Low", @"Middle", @"High"];
    if (sensititySize >= mtdArr.count) {
        response(NO,self.cameraState);
    }else {
        NSString *url = [AITCameraCommand commandSetMTD:mtdArr[sensititySize]];
        [self RequestURL:url DataResponse:^(BOOL success, id obj, CameraState eyeState) {
            NSMutableDictionary *dict = self.statusDic.mutableCopy;
            dict[@"mtd"] = [NSString stringWithFormat:@"%d",sensititySize];
            self.statusDic = dict.copy;
            response(success,eyeState);
        }];
    }
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
    if (self.statusDic) {
        NSString *mtd = self.statusDic[@"mtd"];
        response(YES,[mtd intValue],self.cameraState);
    }else {
        response(NO,-1,self.cameraState);
    }
}
/*!
 @method
 @abstract 设置图像曝光率
 @discussion 设置图像曝光率,
 @param recordSize 分辨率参数
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)setExposureSize:(EXPOSURE)exposureSize
               response:(BoolenResponse)response{
    NSArray *evArr = @[@"EVN200",@"EVN167",@"EVN133",@"EVN100",@"EVN067",@"EVN033",@"EV0",
                       @"EVP033",@"EVP067",@"EVP100",@"EVP133",@"EVP167",@"EVP200"];
    if (exposureSize >= evArr.count) {
        response(NO,self.cameraState);
    }else {
        NSString *url = [AITCameraCommand commandSetEV:evArr[exposureSize]];
        [self RequestURL:url DataResponse:^(BOOL success, id obj, CameraState eyeState) {
            NSMutableDictionary *dict = self.statusDic.mutableCopy;
            dict[@"ev"] = [NSString stringWithFormat:@"%d",exposureSize];
            self.statusDic = dict.copy;
            response(YES,self.cameraState);
        }];
    }
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
    if (self.statusDic) {
        NSString *ev = self.statusDic[@"ev"];
        response(YES,[ev intValue],self.cameraState);
    }else {
        response(NO,-1,self.cameraState);
    }
}
/*!
 @method
 @abstract 设置用户名和密码
 @discussion 设置用户名和密码, 
 @param ssidAndPwd  新的wifi名和密码
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)setSSIDandPWD:(CameraInfo *)ssidAndPwd
             response:(BoolenResponse)response{
    NSString *url = nil;
    if (ssidAndPwd.name&&ssidAndPwd.password) {
        url = [AITCameraCommand commandUpdateUrl:ssidAndPwd.name EncryptionKey:ssidAndPwd.password];
    }else if(ssidAndPwd.name&&(!ssidAndPwd.password)){
        url = [AITCameraCommand commandUpdateSSID:ssidAndPwd.name];
    }else if ((!ssidAndPwd.name)&&ssidAndPwd.password) {
        url = [AITCameraCommand commandUpdateEncryptionKey:ssidAndPwd.password];
    }else {
        
    }
    if (url) {
        [self RequestURL:url DataResponse:^(BOOL success, id obj, CameraState eyeState) {
            if (success) {
                NSString *reset = [AITCameraCommand commandReactivateUrl];
                [self RequestURL:reset DataResponse:^(BOOL success, id obj, CameraState eyeState) {
                    response(success,eyeState);
                }];
            }else {
                response(NO,eyeState);
            }
        }];
    }else {
        response(NO, self.cameraState);
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
    NSString *url = [AITCameraCommand commandWifiInfoUrl];
    [self RequestURL:url DataResponse:^(BOOL success, id obj, CameraState eyeState) {
        if (success) {
            NSString *data = (NSString *)obj;
            NSDictionary *dict = [AITCameraCommand buildResultDictionary:data];
            CameraInfo *model = [[CameraInfo alloc] init];
            // 对model操作
            model.name = dict[[AITCameraCommand PROPERTY_SSID]];
            model.password = dict[[AITCameraCommand PROPERTY_ENCRYPTION_KEY]];
            response(success, model, eyeState);
        }else {
            response(NO,NULL,self.cameraState);
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
- (void)getDiskFreeSpace:(DataResponse)response{
//    NSString *url = [AITCameraCommand commandGetSDCardInfoTotal];
//    NSMutableDictionary *mutabledict = @{}.mutableCopy;
//    [self RequestURL:url DataResponse:^(BOOL success, id obj, CameraState eyeState) {
//         NSLog(@"requestURL : %@", url);
//        
//        NSDictionary *dict = [AITCameraCommand buildResultDictionary:obj];
//        
//        mutabledict[@"totalSpace"] = dict[[AITCameraCommand PROPERTY_SDCARD_TOTAL]];
//        
        NSString *url = [AITCameraCommand commandGetSDCardInfoFree];
        [self RequestURL:url DataResponse:^(BOOL success, id obj, CameraState eyeState) {
            NSLog(@"requestURL : %@", url);
            
            NSDictionary *dict = [AITCameraCommand buildResultDictionary:obj];
            
//            mutabledict[@"freeSpace"] = dict[[AITCameraCommand PROPERTY_SDCARD_FREE]];
            
            response(YES,dict[[AITCameraCommand PROPERTY_SDCARD_FREE]],self.cameraState);
            
        }];
        
//    }];
    
    
}
/*!
 @method
 @abstract 获取文件列表
 @discussion 获取文件列表,
 @param response DataResponse 参数1 是否成功 参数2 id数据
 @result void
 */
- (void)getFileList:(DataResponse)response{
    //先获取图片
    NSString *jpgurl = [AITCameraCommand commandListJPEGFileUrl:500];
    [self RequestXMLURL:jpgurl DataResponse:^(BOOL success, id obj, CameraState eyeState) {
        if (success) {
            NSMutableArray *files = [self unpackFileList:obj];
            //后获取视频
            NSString *movurl = [AITCameraCommand commandListMOVFileUrl:500];
            [self RequestXMLURL:movurl DataResponse:^(BOOL success, id obj, CameraState eyeState) {
                if (success) {
                    NSMutableArray *movarr = [self unpackFileList:obj];
                    if (movarr.count > 0) {
                        [files addObjectsFromArray:movarr];
                    }
                    response(YES,files,self.cameraState);
                }else {
                    response(YES,files,self.cameraState);
                }
            }];
        }else {
            response(NO, NULL,self.cameraState);
        }
    }];
}
/*!
 @method
 @abstract 删除一张特定图片
 @discussion 删除一张特定图片,录制
 @param file 图片的地址
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)deleteFile:(CameraFile *)file
          response:(BoolenResponse)response{
    NSString *url = [AITCameraCommand commandDelFileUrl:[file.path stringByReplacingOccurrencesOfString: @"/" withString:@"$"]];
    [self RequestURL:url DataResponse:^(BOOL success, id obj, CameraState eyeState) {
        response(success, eyeState);
    }];
}
/*!
 @method
 @abstract 删除所有图片
 @discussion 删除所有图片, cmd = 4004
 @param response BoolenResponse 参数 是否成功
 @result void 暂时没有实现
 */
- (void)deleteFileList:(BoolenResponse)response{
    
}

/*!
 @method
 @abstract 获取SD卡状态
 @discussion 获取SD卡状态, cmd = 3024
 @param response TypeResponse 参数1 是否成功 参数2 type
 @result void
 */
- (void)getCardState:(TypeResponse)response{
    
    NSString *url = [AITCameraCommand commandCheckSDCard];
    [self RequestURL:url DataResponse:^(BOOL success, id obj, CameraState eyeState) {
        // 判断
        
        NSDictionary *dict = [AITCameraCommand buildResultDictionary:obj];
        NSString *statusValue = dict[@"Camera.Menu.SDIsExist"];
        if ([statusValue containsString:@"TRUE"]) {
            response(success, CARD_INSERTED, eyeState);
        }else {
            response(success, CARD_REMOVED, eyeState);
        }
        
    }];

}

- (void)removeUser:(BoolenResponse)response{ }

/*!
 @method
 @abstract 初始化SD卡
 @discussion 初始化SD卡
 @param response BoolenResponse 参数 是否成功
 @result void
 */
- (void)resetCard:(BoolenResponse)response{
    NSString *url = [AITCameraCommand commandFormat];
    [self RequestURL:url DataResponse:^(BOOL success, id obj, CameraState eyeState) {
        response(success,eyeState);
    }];
}
/*!
 @method
 @abstract 获取录制状态
 @discussion 获取录制状态
 @result void
 */
- (void)getRecordState:(DataResponse)response{
    
}

/*!
 @method
 @abstract 获取版本信息
 @discussion 获取版本信息,录制 cmd = 3012
 @param response DataResponse 参数1 是否成功 参数2 id数据
 @result void
 */
- (void)getVersion:(DataResponse)response{
    if (self.statusDic) {
        CameraVersion *version = [[CameraVersion alloc] init];
        version.version  = self.statusDic[@"version"];
        response(YES, version, self.cameraState);
    }else {
        response(NO,NULL,self.cameraState);
    }
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
    
}
@end
