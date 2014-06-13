//
//  GraphicUtils.h
//  Flattened
//
//  Created by Diego Maye on 30/05/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GraphicUtils : NSObject
+(UIColor *)colorFromRGBHexString:(NSString *)colorString ;
+(void) cuztomizeViewToRoundedWithShadow:(UIView*)view withCornerRadius:(float) radius;

#pragma mark Defaults
+(UIColor*)colorDefault;
+(UIColor*)colorBelizeHole;
+(UIColor*)colorMidnightBlue;
+(UIColor*)colorSunFlower;
+(UIColor*)colorPumpkin;
+(UIColor*)colorOrange;

+(void) makeSquadViewRounded:(UIView*) view;

@end
