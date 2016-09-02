//
//  FileDownload.h
//  WiFiDemo
//
//  Created by apple on 16/4/28.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "BaseModel.h"

@interface FileDownload : BaseModel

// command property
@property (nonatomic, strong)NSNumber * uiDataPosition;              /* Data start position  */

// send property
@property (nonatomic, strong)NSNumber * usFileIndex;                 /* 1 ~ 65535 */
@property (nonatomic, strong)NSNumber * usDataType;                  /* 0-data of video or image, 1-thumbnail of video */

// revice property
@property (nonatomic, strong)NSNumber * uiTotalSize;                 /* Total size of Thumbnail , unit bytes */
@property (nonatomic, strong)NSNumber * uiCurrentSize;               /* Current size in this transmition, unit bytes, max 500KB */
@property (nonatomic, strong)NSNumber * uiRemainSize;                /* Remain size witch has not be transmitted, unit bytes */
//@property (nonatomic, strong)NSNumber * uiDataPosition;              /* Data start position(according to the received value) */
@property (nonatomic, copy  )NSData *  ucData;/* Data of the thumbnail, witch start from the "DataPosition", max 500KB */

- (NSData *)getDownloadRequest;

@end
