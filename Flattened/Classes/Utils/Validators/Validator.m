//
//  Validator.m
//  Flattened
//
//  Created by Diego Maye on 13/05/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "Validator.h"

@implementation Validator

+ (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

@end
