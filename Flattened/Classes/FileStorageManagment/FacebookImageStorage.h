//
//  FacebookImageStorage.h
//  Flattened
//
//  Created by Diego Maye on 12/05/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "ImageManager.h"

@interface FacebookImageStorage : NSObject

+(void) saveFacebookProfileImage:(FBProfilePictureView*) fbViewProfile inPath:(NSString*)path;
+(UIImage*)loadFacebookImage:(NSString*) path;

@end
