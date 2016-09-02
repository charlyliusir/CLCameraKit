//
//  File.h
//  WiFiDemo
//
//  Created by apple on 16/4/28.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "BaseModel.h"

@interface ADNSCameraFile : BaseModel

@property (nonatomic, strong)NSNumber * usIndex;
@property (nonatomic, strong)NSNumber * ucType;
@property (nonatomic, strong)NSNumber * ucAttr;
@property (nonatomic, strong)NSNumber * uiSize;
@property (nonatomic, strong)NSNumber * uiDate;

- (NSString *)getDate;

@end
