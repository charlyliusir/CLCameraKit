//
//  CameraFiles.m
//  CLCameraKit
//
//  Created by apple on 16/7/6.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "CameraFile.h"

@implementation CameraFile

- (void)setName:(NSString *)name
{
    [super setName:name];
    
    if ([name hasSuffix:@"mov"]) {
        
        self.fileType = CameraFileTypeMovie;
        
    }else if ([name hasSuffix:@"jpg"]){
        
        self.fileType = CameraFileTypePhoto;
        
    }
    
    // 处理FileDate 和 FileTime
    NSString *dataString    = [name substringWithRange:NSMakeRange(0, 8)];
    NSString *timeString    = [name substringWithRange:NSMakeRange(8, 6)];
    NSString *convertDateString = [self covertDateWithString:dataString];
    NSString *convertTimeString = [self covertTimeWithString:timeString];
    
    self.fileDate = convertDateString;
    self.fileTime = convertTimeString;
}

- (void)setFileDate:(NSString *)fileDate
{
    
    _fileDate = [fileDate stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    
}

- (void)setCameraCellState:(CellState)cameraCellState
{
    
    if(self.download==FileDownloadStateProgress){
        _cameraCellState = CellStateProgress;
    }else{
        _cameraCellState = cameraCellState;
    }
    
}

- (NSString *)covertDateWithString:(NSString *)dataString
{
    NSMutableString *covertString = [NSMutableString stringWithString:dataString];
    
    [covertString insertString:@"-" atIndex:4];
    [covertString insertString:@"-" atIndex:7];
    
    return covertString;
}

- (NSString *)covertTimeWithString:(NSString *)timeString
{
    NSMutableString *covertString = [NSMutableString stringWithString:timeString];
    
    [covertString insertString:@":" atIndex:2];
    [covertString insertString:@":" atIndex:5];
    
    return covertString;
}

@end
