//
//  GraphicUtils.m
//  Flattened
//
//  Created by Diego Maye on 30/05/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "GraphicUtils.h"

@implementation GraphicUtils
+(UIColor *)colorFromRGBHexString:(NSString *)colorString {
    if(colorString.length == 7) {
        const char *colorUTF8String = [colorString UTF8String];
        int r, g, b;
        sscanf(colorUTF8String, "#%2x%2x%2x", &r, &g, &b);
        return [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:1.0];
    }
    return nil;
}

+(void) cuztomizeViewToRoundedWithShadow:(UIView*)view withCornerRadius:(float) radius{
    [view.layer setCornerRadius:radius];
    [view.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [view.layer setBorderWidth:1.5f];
    [view.layer setShadowColor:[UIColor blackColor].CGColor];
    [view.layer setShadowOpacity:0.8];
    [view.layer setShadowRadius:3.0];
    [view.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
}
    //Verde Pastel
+(UIColor*)colorDefault{
    return [self colorFromRGBHexString:@"#27ae60"];
}
    //Azul Claro
+(UIColor*)colorBelizeHole{
    return [self colorFromRGBHexString:@"#2980b9"];
}
    //Azul Oscuro
+(UIColor*)colorMidnightBlue{
    return [self colorFromRGBHexString:@"#2c3e50"];
}
    //Amarillo pastel
+(UIColor*)colorSunFlower{
    return [self colorFromRGBHexString:@"#f1c40f"];
}
    //Naranja Fuerte Pastel
+(UIColor*)colorPumpkin{
    return [self colorFromRGBHexString:@"#e74c3c"];
}
    //Naranja Pastel
+(UIColor*)colorOrange{
    return [self colorFromRGBHexString:@"#f39c12"];
}

+(void) makeSquadViewRounded:(UIView*) view{
    return  [self cuztomizeViewToRoundedWithShadow:view withCornerRadius:view.frame.size.width/2];
}
@end
