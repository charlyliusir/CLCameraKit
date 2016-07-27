//
//  AitCamera.h
//  Cheche
//
//  Created by autobot on 16/5/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseCamera.h"

@interface AitCamera : BaseCamera
@property (nonatomic, strong)NSDictionary *statusDic;

- (NSString *)formattedNameString:(NSString *)name;
- (NSString *)formattedFpathString:(NSString *)name;

@end
