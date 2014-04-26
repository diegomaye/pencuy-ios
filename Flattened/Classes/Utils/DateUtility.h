//
//  DateUtility.h
//  Flattened
//
//  Created by Diego Maye on 20/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtility : NSObject

+(NSDate *)convertDateToLocal:(NSDate *)date;
+(NSDate *)deserializeJsonDateString: (NSString *)jsonDateString;
+(NSString *)serealizadorJsonDateToString:(NSDate *) date;
+(NSString *)dateNow;
@end
