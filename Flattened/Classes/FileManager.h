//
//  FileManager.h
//  Flattened
//
//  Created by Diego Maye on 26/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

+(void) fileWriteArrayWith:(NSArray*)array withFileName:(NSString*)fileName;
+(NSArray*) fileReadArrayWithFileName:(NSString*) fileName;

@end
