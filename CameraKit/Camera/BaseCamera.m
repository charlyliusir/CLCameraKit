//
//  BaseCamera.m
//  Cheche
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseCamera.h"

@implementation BaseCamera
- (void)connectSocket{}
- (void)disConnectSocket{}
- (void)getPerViewURL:(void(^)(NSString * previewURL))response AddressURL:(NSString *)addressURL
{ }
- (void)ConnectCamera:(TypeResponse)response{ }
- (void)goRecord:(BoolenResponse)response{ }
- (void)setRecordStatus:(BOOL)recordStatus
               response:(BoolenResponse)response{ }
- (void)changeMovieModel:(WIFI_APP_MODE_CMD)model
                response:(BoolenResponse)response{ }
- (void)stopRecord:(BoolenResponse)response{ }
- (void)changeBackPlay:(BoolenResponse)response{ }
- (void)TakeCapture:(DataResponse)response{ }

- (void)getSystemDate:(BoolenResponse)response{ }
- (void)setSystemDate:(BoolenResponse)response{ }
- (void)resetSystem:(BoolenResponse)response{ }

- (void)setAutoRecording:(BOOL)autoRecording
                response:(BoolenResponse)response{ }
- (void)getAutoRecording:(TypeResponse)response{ }

- (void)setAutoRecord:(BOOL)autoRecord
             response:(BoolenResponse)response{ }
- (void)getAutoRecord:(TypeResponse)response{ }

- (void)setRecordSize:(MOVIE_SIZE)recordSize
             response:(BoolenResponse)response{ }
- (void)getRecordSize:(TypeResponse)response{ }

- (void)setLiveSize:(MOVIE_LIVE_SIZE)liveSize
           response:(BoolenResponse)response{ }
- (void)getLiveSize:(TypeResponse)response{ }

- (void)setPhotoSize:(PHOTO_SIZE)photoSize
            response:(BoolenResponse)response{ }
- (void)getPhotoSize:(TypeResponse)response{ }

- (void)setSensititySize:(GSENSOR)sensititySize
                response:(BoolenResponse)response{ }
- (void)getSensititySize:(TypeResponse)response{ }

- (void)setExposureSize:(EXPOSURE)exposureSize
               response:(BoolenResponse)response{ }
- (void)getExposureSize:(TypeResponse)response{ }

- (void)setSSIDandPWD:(CameraInfo *)ssidAndPwd
             response:(BoolenResponse)response{ }
- (void)getSSIDandPWD:(DataResponse)response{ }

- (void)getDiskFreeSpace:(DataResponse)response{ }


- (void)getFileList:(DataResponse)response{ }
- (void)deleteFile:(CameraFile *)file
          response:(BoolenResponse)response{ }
- (void)deleteFileList:(BoolenResponse)response{ }


- (void)getCardState:(TypeResponse)response{ }
- (void)removeUser:(BoolenResponse)response{ }
- (void)resetCard:(BoolenResponse)response{ }


- (void)getVersion:(DataResponse)response{ }
- (void)updateVersion:(DataResponse)response{ }

- (void)makeShortMovie:(BoolenResponse)response{ }
- (void)playbackMoive:(NSData *)movieObject response:(BoolenResponse)response{ }
- (void)getRecordState:(DataResponse)response{ }
- (void)getAudioRecordState:(DataResponse)response{ }
- (void)getAdasState:(DataResponse)response{ }
- (void)setHDR:(Byte)hdr response:(BoolenResponse)response{ }
- (void)setOSD:(Byte)osd response:(BoolenResponse)response{ }
- (void)setAudioPlay:(NSData *)audioPlayObject response:(BoolenResponse)response{ }
- (void)setAdas:(NSData *)adasObject response:(BoolenResponse)response{ }
- (void)getCaliParamComplition:(DataResponse)response{ }
- (void)setCaliParam:(NSData *)caliObject response:(BoolenResponse)response{ }

@end
