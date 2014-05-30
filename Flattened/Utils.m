//
//  Utils.m
//  mapper
//
//  Created by Tope Abayomi on 15/08/2013.
//
//

#import "Utils.h"
#import <sys/utsname.h>

@implementation Utils

+(BOOL)isVersion6AndBelow {
    
    return floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1;
}
/*
 El metodo machineName retorna:
 @"i386"      on the simulator
 @"iPod1,1"   on iPod Touch
 @"iPod2,1"   on iPod Touch Second Generation
 @"iPod3,1"   on iPod Touch Third Generation
 @"iPod4,1"   on iPod Touch Fourth Generation
 @"iPhone1,1" on iPhone
 @"iPhone1,2" on iPhone 3G
 @"iPhone2,1" on iPhone 3GS
 @"iPad1,1"   on iPad
 @"iPad2,1"   on iPad 2
 @"iPad3,1"   on iPad 3 (aka new iPad)
 @"iPhone3,1" on iPhone 4
 @"iPhone4,1" on iPhone 4S
 @"iPhone5,1" on iPhone 5
 @"iPhone5,2" on iPhone 5
 */
+(NSString*)machineName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

+(NSString*)dimensionesPantalla{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    NSString* width = [NSString stringWithFormat:@"%i", abs((int)screenWidth)];
    CGFloat screenHeight = screenRect.size.height;
    NSString* height = [NSString stringWithFormat:@"%i", abs((int)screenHeight)];
    return [NSString stringWithFormat:@"%@x%@", width, height];
}

+(UIImage*)createSolidColorImageWithColor:(UIColor*)color andSize:(CGSize)size{
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGRect fillRect = CGRectMake(0,0,size.width,size.height);
    CGContextSetFillColorWithColor(currentContext, color.CGColor);
    CGContextFillRect(currentContext, fillRect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
