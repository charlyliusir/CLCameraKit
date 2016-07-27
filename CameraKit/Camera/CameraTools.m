//
//  CameraTools.m
//  Cheche
//
//  Created by apple on 16/3/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CameraTools.h"
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVAsset.h>
#import "LDNetGetAddress.h"
#import "UIImage+Scale.h"

#import "CameraManager.h"

@implementation CameraTools

+ (NSString *)getCameraAddress
{
    return [LDNetGetAddress getGatewayIPAddress];
}

+ (NSString *)doucmentPath
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    return path;
}

// 文件管理器
+ (NSFileManager *)fileManager
{
    return [NSFileManager defaultManager];
}

// 创建文件夹
+ (void)createFilePath:(NSString *)filePath
{
    if (![[self fileManager] fileExistsAtPath:filePath]) {
        
        [[self fileManager] createDirectoryAtPath:filePath
                      withIntermediateDirectories:YES
                                       attributes:NULL
                                            error:NULL];
        
    }
}

// 删除文件夹
+ (void)deleteFilePath:(NSString *)filePath
{
    
    if ([[self fileManager] fileExistsAtPath:filePath]) {
        
        [[self fileManager] removeItemAtPath:filePath
                                       error:NULL];
        
    }
    
}

// 本地缩略图文件地址
+ (NSString *)localNailFilePath:(CameraFileType)fileType
{
    NSString *filePath = [NSString stringWithFormat:@"/%@",LOCAL_NAIL_FILE_LIST[fileType]];
    
    NSString *localNailPath = [[self doucmentPath] stringByAppendingString:filePath];
    [self createFilePath:localNailPath];
    
    return localNailPath;
    
}

// 本地文件地址
+ (NSString *)localFilePath:(CameraFileType)fileType
{
    
    NSString *filePath = [NSString stringWithFormat:@"/%@",LOCAL_FILE_LIST[fileType]];
    
    NSString *localFilePath = [[self doucmentPath] stringByAppendingString:filePath];
    [self createFilePath:localFilePath];
    
    return localFilePath;
    
}

// 记录仪图片
+ (NSDictionary *)cameraPhotoList:(NSArray *)fileList downloadFile:(NSArray *)localFileList
{
    NSMutableArray *dataRow   = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    for (CameraFile *file in fileList) {
        
        file.fileSourceType = FileSourceTypeCamera;
        
        if ([file.name hasSuffix:@".jpg"]) {
            
            file.folder = LOCAL_PHTOT_FILE_NAME;
            
            if (file.fileNailURL&&![file.fileNailURL hasPrefix:@"file://"]) {
                
                CLQueue *queue = [[CLQueue alloc] initQueueWithDownloadURL:file.fileNailURL folder:LOCAL_NAIL_FILE_LIST[file.fileType] name:file.name];
                
                if (![[self fileManager] fileExistsAtPath:queue.path]) {
                    
                    [[[CameraManager sharedCameraManager] nailQueueManager] EnQueue:queue];
                    
                }
                
            } else if ([file.fileNailURL hasPrefix:@"file://"]) {
                
                NSString *URL = [file.url stringByReplacingOccurrencesOfString:@"SD" withString:@"thumb"];
                
                CLQueue *queue = [[CLQueue alloc] initQueueWithDownloadURL:URL folder:LOCAL_NAIL_FILE_LIST[file.fileType] name:file.name];
                
                if (![[self fileManager] fileExistsAtPath:queue.path]) {
                    
                    [[[CameraManager sharedCameraManager] nailQueueManager] EnQueue:queue];
                    
                }
                
            }
            
            for (CameraFile *localFile in localFileList) {
                
                if ([localFile.name isEqualToString:file.name]) {
                    
                    file.download = FileDownloadStateEnd;
                    
                }
            }
            
            [dataRow addObject:file];
            
        }
        
    }
    
    [dataRow sortUsingComparator:^NSComparisonResult(CameraFile *obj1, CameraFile *obj2) {
        
        return [obj2.name compare:obj1.name];
        
    }];
    
    NSInteger pictureSize = 0;
    
    for (CameraFile *file in dataRow) {
        
        pictureSize += [file.fileSize integerValue];
        
        if ([[dict allKeys] containsObject:file.fileDate]) {
            
            NSMutableArray *keyArray = [[NSMutableArray alloc] initWithArray:dict[file.fileDate]];
            [keyArray addObject:file];
            [dict setObject:keyArray forKey:file.fileDate];
            
        } else {
            
            [dict setObject:@[file] forKey:file.fileDate];
            
        }
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITY_INIT_DOWNLOAD object:NULL];
    
    [[NSUserDefaults standardUserDefaults] setInteger:pictureSize forKey:USERDEFAULT_CAMERA_PIC_SIZE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return dict;
}

+ (NSArray *)cameraPhotoDataRows:(NSDictionary *)photoList
{
    NSMutableArray *dataRow = [[NSMutableArray alloc] init];
    
    for (NSString *keyValue in [photoList allKeys]) {
        
        NSArray *valueArray = photoList[keyValue];
        
        for (CameraFile *file in valueArray) {
        
            [dataRow addObject:file];
            
        }
        
    }
    
    return dataRow;
}

// 记录仪视频
+ (NSArray *)cameraMovieList:(NSArray *)fileList downloadFile:(NSArray *)localFileList
{
    NSMutableArray *dataRow = [[NSMutableArray alloc] init];
    
    NSInteger movieSize = 0;
    
    for (CameraFile *file in fileList) {
        
        movieSize += [file.fileSize integerValue];
        
        file.fileSourceType = FileSourceTypeCamera;
        
        if ([file.name hasSuffix:@".mov"]) {
            
            file.folder = LOCAL_Movie_FILE_NAME;
            
            if (file.fileNailURL&&![file.fileNailURL hasPrefix:@"file://"]) {
                
                CLQueue *queue = [[CLQueue alloc] initQueueWithDownloadURL:file.fileNailURL folder:LOCAL_NAIL_FILE_LIST[file.fileType] name:file.name];
                
                if (![[self fileManager] fileExistsAtPath:queue.path]) {
                    
                    [[[CameraManager sharedCameraManager] nailQueueManager] EnQueue:queue];
                    
                }
                
            } else if ([file.fileNailURL hasPrefix:@"file://"]) {
                
                NSString *URL = [file.url stringByReplacingOccurrencesOfString:@"SD" withString:@"thumb"];
                
                CLQueue *queue = [[CLQueue alloc] initQueueWithDownloadURL:URL folder:LOCAL_NAIL_FILE_LIST[file.fileType] name:file.name];
                
                if (![[self fileManager] fileExistsAtPath:queue.path]) {
                    
                    [[[CameraManager sharedCameraManager] nailQueueManager] EnQueue:queue];
                    
                }
                
            }
            
            for (CameraFile *localFile in localFileList) {
                
                if ([localFile.name isEqualToString:file.name]) {
                    
                    file.download = FileDownloadStateEnd;
                    
                }
            }
            
            [dataRow addObject:file];
            
        }
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFITY_INIT_DOWNLOAD object:NULL];
    [[NSUserDefaults standardUserDefaults] setInteger:movieSize forKey:USERDEFAULT_CAMERA_MOVIE_SIZE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [dataRow sortUsingComparator:^NSComparisonResult(CameraFile *obj1, CameraFile *obj2) {
       
        return [obj2.name compare:obj1.name];
        
    }];
    
    return dataRow;
}

// 获取本地图片列表
+ (NSDictionary *)localPhotoList
{
    NSString *localPhotoPath  = [self localFilePath:CameraFileTypePhoto];
    
    NSMutableArray *fileList  = [NSMutableArray arrayWithArray:[[self fileManager] contentsOfDirectoryAtPath:localPhotoPath error:NULL]];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [fileList sortUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        
        return [str2 compare:str1];
        
    }];
    
    for (NSString *fileName in fileList) {
        
        CameraFile *file    = [self createLocalFile:fileName];
        file.path = [[localPhotoPath stringByAppendingString:@"/"] stringByAppendingString:fileName];
        file.download = FileDownloadStateEnd;
        
        if ([[dict allKeys] containsObject:file.fileDate]) {
            
            NSMutableArray *keyArray = [[NSMutableArray alloc] initWithArray:dict[file.fileDate]];
            [keyArray addObject:file];
            [dict setObject:keyArray forKey:file.fileDate];
            
        } else {
            
            [dict setObject:@[file] forKey:file.fileDate];
            
        }
    }
    
    return dict;
}

// 获取本地视频列表
+ (NSArray *)localMovieList
{
    NSString *localPhotoPath = [self localFilePath:CameraFileTypeMovie];
    
    NSMutableArray *fileList  = [NSMutableArray arrayWithArray:[[self fileManager] contentsOfDirectoryAtPath:localPhotoPath error:NULL]];
    
    NSMutableArray *dataRow = [[NSMutableArray alloc] init];
    
    [fileList sortUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        
        return [str2 compare:str1];
        
    }];
    
    for (NSString *fileName in fileList) {
        
        CameraFile *file = [self createLocalFile:fileName];
        file.path = [[localPhotoPath stringByAppendingString:@"/"] stringByAppendingString:fileName];
        file.download = FileDownloadStateEnd;
        
        [dataRow addObject:file];
    }
    
    return dataRow;
}

+ (NSArray *)localDataList:(CameraFileType)fileType
{
    NSString *localPhotoPath = [self localFilePath:fileType];
    
    NSMutableArray *fileList  = [NSMutableArray arrayWithArray:[[self fileManager] contentsOfDirectoryAtPath:localPhotoPath error:NULL]];
    
    NSMutableArray *dataRow = [[NSMutableArray alloc] init];
    
    [fileList sortUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        
        return [str2 compare:str1];
        
    }];
    
    for (NSString *fileName in fileList) {
        
        CameraFile *file = [self createLocalFile:fileName];
        file.path = [[localPhotoPath stringByAppendingString:@"/"] stringByAppendingString:fileName];
        file.download = FileDownloadStateEnd;
        
        [dataRow addObject:file];
    }
    
    return dataRow;

}

+ (NSString *)covertDateWithString:(NSString *)dataString
{
    NSMutableString *covertString = [NSMutableString stringWithString:dataString];
    
    [covertString insertString:@"-" atIndex:4];
    [covertString insertString:@"-" atIndex:7];
    
    return covertString;
}

+ (NSString *)covertTimeWithString:(NSString *)timeString
{
    NSMutableString *covertString = [NSMutableString stringWithString:timeString];
    
    [covertString insertString:@":" atIndex:2];
    [covertString insertString:@":" atIndex:5];
    
    return covertString;
}

+ (CameraFile *)createLocalFile:(NSString *)fileName
{
    CameraFile *file    = [[CameraFile alloc] init];
    file.name = fileName;
    file.fileSourceType = FileSourceTypeLocation;
    
    return file;
}


// 换算内存大小
+ (NSString *)memoryWithSize:(NSNumber *)memorySize
{
    CGFloat GVlaue = [memorySize floatValue] / 1024.f / 1024.f / 1024.f;
    
    CGFloat mValue = [memorySize floatValue] / 1024.f / 1024.f;
    
    if (GVlaue > 1.0f) {
        
        return [NSString stringWithFormat:@"%.0fG", GVlaue];
        
    }
    
    if (mValue > 1.0f) {
        
        return [NSString stringWithFormat:@"%.0fM", mValue];
        
    }
    
    return [NSString stringWithFormat:@"%.1fKB", [memorySize floatValue] / 1024.f];
    
}

+(void)deleteFile:(CameraFileType)fileType Objects:(NSArray *)Objects
{
    
    NSString * filePath = [self localFilePath:fileType];
//    NSString * nailPath = [self localNailFilePath:fileType];
    
    for (CameraFile *file in Objects) {
        
        NSString * dFilePath = [NSString stringWithFormat:@"%@/%@", filePath, file.name];
//        NSString * dNailPath = [NSString stringWithFormat:@"%@/%@", nailPath, file.fileName];
        
//        [self deleteFilePath:dNailPath];
        [self deleteFilePath:dFilePath];
    }
    
}

+ (NSURL *)movieURLPath:(CameraFile *)file
{
    
    if (file.fileSourceType == FileSourceTypeLocation || file.download) {
        
        NSString *filePath = [self localFilePath:CameraFileTypeMovie];
        
        return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", filePath, file.name]];
        
    } else if (file.fileSourceType == FileSourceTypeCamera) {
        
        return [NSURL URLWithString:file.fileURL];
        
    }
    
    return NULL;
}

+ (void)makeNailWithPath:(NSString *)fpath scaleImageSize:(float)size
{
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *path = [NSString stringWithFormat:@"%@/Image/%@", filePath, fpath];
    NSString *nailPath = [NSString stringWithFormat:@"%@/Imagenail/%@", filePath, fpath];
    
    UIImage *bigImage = [UIImage imageWithContentsOfFile:path];
    UIImage *scaleImage = [bigImage scaleSize:CGSizeMake(bigImage.size.width/size, bigImage.size.height/size)];
    
    [UIImageJPEGRepresentation(scaleImage, 1) writeToFile:nailPath atomically:YES];
}

+ (BOOL)saveFileNailWithType:(CameraFileType )type
                     NailUrl:(NSURL *)nailurl
                     FileUrl:(NSURL *)fileUrl
{
    if (type == CameraFileTypeMovie) {
        UIImage *nailimage = [self thumbnailImageForVideo:fileUrl atTime:1];
        NSData *data = UIImageJPEGRepresentation(nailimage, 0);
        return [data writeToURL:nailurl atomically:YES];
    }else {
        NSData *data= [NSData dataWithContentsOfURL:fileUrl];
        UIImage *nailimage = [UIImage imageWithData:data];
        NSData *saveData = UIImageJPEGRepresentation(nailimage, 0);
        return [saveData writeToURL:nailurl atomically:YES];
    }
}

+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode =AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage:thumbnailImageRef] : nil;
    
    return thumbnailImage;
}



@end
