//
//  ImageManager.h
//  Flattened
//
//  Created by Diego Maye on 12/05/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageManager : NSObject

+ (void)saveImage: (UIImage*)image withPath:(NSString*)fileName;
+ (UIImage*)loadImageWithFileName:(NSString*)fileName;

@end
