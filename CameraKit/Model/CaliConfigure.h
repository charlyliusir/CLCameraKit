//
//  CaliConfigure.h
//  CLWiFiDemo
//
//  Created by apple on 16/6/13.
//  Copyright © 2016年 刘朝龙. All rights reserved.
//

#import "BaseModel.h"

@interface CaliConfigure : BaseModel

@property (nonatomic, strong)NSNumber *	uiVehicleID;        /* Current vehicle ID */
@property (nonatomic, strong)NSNumber *	uiCameraHeight;	    /* Camera height to the ground, unit cm, 100 ~ 300 */
@property (nonatomic, strong)NSNumber *	iFrontAxisOffset;	/* Camere offset to the front-axis, unit cm, -300 ~ 300 */
@property (nonatomic, strong)NSNumber *	uiHeadOffset;	    /* Camere offset to the head of car, unit cm, 0 ~ 300 */
@property (nonatomic, strong)NSNumber *	uiLeftWheelOffset;	/* Camere offset to the left-wheel, unit cm, 50 ~ 150 */
@property (nonatomic, strong)NSNumber *	uiRightWheelOffset;	/* Camere offset to the right-wheel, unit cm, 50 ~ 150 */
@property (nonatomic, strong)NSNumber *	uiCrossPositionX;	/* Cross position of x-axis, unit pixels, 360 ~ 1560[TBD] */
@property (nonatomic, strong)NSNumber *	uiCrossPositionY;	/* Cross position of y-axis, unit pixels, 240 ~ 840[TBD] */
@property (nonatomic, strong)NSNumber *	BottomLineY;	/* Cross position of y-axis, unit pixels, 240 ~ 840[TBD] */

@end
