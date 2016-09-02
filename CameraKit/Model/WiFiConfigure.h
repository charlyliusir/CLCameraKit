//
//  WiFiConfigure.h
//  CLWiFiDemo
//
//  Created by apple on 16/6/13.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "BaseModel.h"

@interface WiFiConfigure : BaseModel

@property (nonatomic, copy)NSString * ucSSID;    /* name of this device */
@property (nonatomic, copy)NSString * ucPSWD;    /* password of wifi-connecting */

@end
