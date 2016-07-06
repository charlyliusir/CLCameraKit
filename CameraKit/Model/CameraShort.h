//
//  ShareModel.h
//  Cheche
//
//  Created by apple on 16/4/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CameraShort : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) NSString *videoName;
@property (nonatomic, strong) NSString *subURL;
@property (nonatomic, strong) UIImage  *subImage;
@property (nonatomic, strong) UIImage  *shareImage;
@property (nonatomic, strong) NSString *shareURL;

- (void)getFirstImage;

@end
