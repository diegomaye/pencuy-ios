//
//  ImageManager.m
//  Flattened
//
//  Created by Diego Maye on 12/05/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "ImageManager.h"

@implementation ImageManager

+ (void)saveImage: (UIImage*)image withPath:(NSString*)fileName
{
    if (image != nil)
        {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:fileName];
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
        }
    
}

+ (UIImage*)loadImageWithFileName:(NSString*)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
        //NSString *string = [[NSBundle mainBundle] pathForResource:@"IMAGE_FILE_NAME" ofType:@"jpg"];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:fileName];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}

@end
