//
//  FacebookImageStorage.m
//  Flattened
//
//  Created by Diego Maye on 12/05/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "FacebookImageStorage.h"

@implementation FacebookImageStorage

+(void) saveFacebookProfileImage:(FBProfilePictureView*) fbViewProfile inPath:(NSString*)fileName{
    UIImage *img = nil;
//    for (NSObject *obj in [fbViewProfile subviews]) {
//        if ([obj isMemberOfClass:[UIImageView class]]) {
//            UIImageView *objImg = (UIImageView *)obj;
//            img = objImg.image;
//            break;
//        }
//    }
    
    UIGraphicsBeginImageContext(fbViewProfile.frame.size);
    [fbViewProfile.layer renderInContext:UIGraphicsGetCurrentContext()];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [ImageManager saveImage:img withPath:fileName];
}

+(UIImage*)loadFacebookImage:(NSString*) fileName {
    
    return [ImageManager loadImageWithFileName:fileName];
    
}

@end
