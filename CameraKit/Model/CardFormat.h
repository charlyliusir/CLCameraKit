//
//  CardFormat.h
//  CLWiFiDemo
//
//  Created by apple on 16/6/12.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "BaseModel.h"

@interface CardFormat : BaseModel

// low zero failed, zero success, high zero formatting
@property (nonatomic, strong)NSNumber *formatstate;

@end
