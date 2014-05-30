//
//  RandomManager.m
//  Flattened
//
//  Created by Diego Maye on 11/05/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "RandomManager.h"

@implementation RandomManager

+(NSString*) getRandomAphanumeric:(int)lenght{
    NSString *alphabet  = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *s = [NSMutableString stringWithCapacity:lenght];
    for (NSUInteger i = 0U; i < lenght; i++) {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    return s;
}

@end
