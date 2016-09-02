//
//  AdasConfigure.h
//  CLWiFiDemo
//
//  Created by apple on 16/6/13.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "BaseModel.h"

@interface AdasConfigure : BaseModel

@property (nonatomic, strong)NSNumber * ucAdasEnable;	      /* 0-disable, 1-enable. */
@property (nonatomic, strong)NSNumber * ucLdwSensitivity;	  /* 0-close, 1-low, 2-middle, 3-high */
@property (nonatomic, strong)NSNumber * ucHwwSensitivity;	  /* 0-close, 1-low, 2-middle, 3-high */
@property (nonatomic, strong)NSNumber * ucFcwSensitivity;	  /* 0-close, 1-low, 2-middle, 3-high */
@property (nonatomic, strong)NSNumber * ucVehicleStartEnable; /* 0-disable, 1-enable. */

@end
