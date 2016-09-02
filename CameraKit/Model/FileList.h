//
//  FileList.h
//  WiFiDemo
//
//  Created by apple on 16/4/28.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "BaseModel.h"
#import "ADNSCameraFile.h"
@interface FileList : BaseModel

@property (nonatomic, strong)NSNumber *totalIndex;
@property (nonatomic, copy  )NSArray <ADNSCameraFile *> *filelist;

@end
