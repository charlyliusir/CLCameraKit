//
//  BaseModel.h
//  CLWiFiDemo
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+Convert.h"
#import "WiFiCMD.h"


@interface BaseModel : NSObject

@property (nonatomic, strong)NSNumber *errorCode;

- (instancetype)initWithData:(NSData *)responseData;

- (NSData *)getDataInfo;
- (void)getDictionary;

@end
