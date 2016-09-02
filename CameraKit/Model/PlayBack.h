//
//  PlayBack.h
//  CLWiFiDemo
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "BaseModel.h"

@interface PlayBack : BaseModel

@property (nonatomic, strong)NSNumber * usFileIndex;                 /* 1 ~ 65535. */
@property (nonatomic, strong)NSNumber * usCommand;                   /* 0-play(normal speed), 1-stop, 2-pause, 3-locate, 4-fast forward, 5-fast backward. */
@property (nonatomic, strong)NSNumber * uiLocateTime;                /* Locate time from video beginning, unit seconds. */

@end
