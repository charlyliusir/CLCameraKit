//
//  CardState.h
//  CLWiFiDemo
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "BaseModel.h"

@interface CardState : BaseModel

@property (nonatomic, strong)NSNumber *  ucSdcardStatus; /* 0-normal, 1-not insert, 2-format error, 3-space too small, 4-write failed, 5-formatting. */
@property (nonatomic, strong)NSNumber *  ucSdcardFormat; /* 0-FAT32, 1-exFAT, others-not support. */
@property (nonatomic, strong)NSNumber * usReserved;      /*  */
@property (nonatomic, strong)NSNumber * uiTotal;         /* uint KB */
@property (nonatomic, strong)NSNumber * uiTotalUsed;     /* uint KB */
@property (nonatomic, strong)NSNumber * uiTotalFree;     /* uint KB */
@property (nonatomic, strong)NSNumber * uiCycleUsed;     /* uint KB */
@property (nonatomic, strong)NSNumber * uiEventUsed;     /* uint KB */
@property (nonatomic, strong)NSNumber * uiImageUsed;     /* uint KB */
@property (nonatomic, strong)NSNumber *  ucCyclePercent; /* uint % */
@property (nonatomic, strong)NSNumber *  ucEventPercent; /* uint % */
@property (nonatomic, strong)NSNumber *  ucImagePercent; /* uint % */

@end
