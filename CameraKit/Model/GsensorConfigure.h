//
//  GsensorConfigure.h
//  CLWiFiDemo
//
//  Created by apple on 16/6/13.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "BaseModel.h"

@interface GsensorConfigure : BaseModel

@property (nonatomic, strong)NSNumber * ucWakeupSensitivity; /* 0-close, 1-low(°¿0.6g), 2-middle(°¿0.8g), 3-high(°¿1.0g) */
@property (nonatomic, strong)NSNumber * ucEmergeSensitivity; /* 0-close, 1-low(°¿1.5g), 2-middle(°¿2.0g), 3-high(°¿2.5g) */
@end
