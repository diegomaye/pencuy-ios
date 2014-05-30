//
//  Validator.h
//  Flattened
//
//  Created by Diego Maye on 13/05/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Validator : NSObject

+ (BOOL) validateEmail: (NSString *) candidate;

@end
