//
//  HandShack.h
//  CLWiFiDemo
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "BaseModel.h"

@interface HandShake : BaseModel

@property (nonatomic, strong)NSNumber *TpVersion;

+ (NSData *)sendTpVersion:(NSString *)tpVersion;

@end
