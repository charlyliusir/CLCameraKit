//
//  RecordConfigure.h
//  CLWiFiDemo
//
//  Created by apple on 16/6/13.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "BaseModel.h"

@interface RecordConfigure : BaseModel



@property (nonatomic, strong)NSNumber * ucResolution;        /* 0-1080P, 1-720P */
@property (nonatomic, strong)NSNumber * ucDuration;          /* Cycle recording duration, uint minutes. */
@property (nonatomic, strong)NSNumber * ucAudioRecordEnable; /* 0-disable, 1-enable. */
@property (nonatomic, strong)NSNumber * ucHdrEnable;         /* 0-disable, 1-enable. */
@property (nonatomic, strong)NSNumber * ucOsdEnable;         /* 0-disable, 1-enable. */

@end
