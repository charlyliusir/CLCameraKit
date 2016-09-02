//
//  File.m
//  WiFiDemo
//
//  Created by apple on 16/4/28.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "ADNSCameraFile.h"

@implementation ADNSCameraFile

- (instancetype)initWithData:(NSData *)responseData
{
    
    if (self = [super init]) {
        
        struct tAckFileInfo fileInfo;
        [responseData getBytes:&fileInfo length:responseData.length];
        
        self.usIndex = @(fileInfo.usIndex);
        self.ucType = @(fileInfo.ucType);
        self.ucAttr = @(fileInfo.ucAttr);
        self.uiSize = @(fileInfo.uiSize);
        self.uiDate = @(fileInfo.uiDate);
        
    }
    
    return self;
    
}


//- (CameraFileType)getFileType
//{
//    if ([self.ucType unsignedCharValue]==0x00) {
//        
//        return CameraFileTypeMovie;
//        
//    } else {
//        
//        return CameraFileTypeImage;
//        
//    }
//}

- (NSString *)getDate
{
    
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:[self.uiDate unsignedIntValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    
    return [formatter stringFromDate:createDate];
    
}

@end
