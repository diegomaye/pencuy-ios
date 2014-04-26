//
//  DateUtility.m
//  Flattened
//
//  Created by Diego Maye on 20/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "DateUtility.h"

@implementation DateUtility

+(NSDate *)convertDateToLocal:(NSDate *)date{
    
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:date];
    NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:date];
    NSTimeInterval gmtInterval = currentGMTOffset - gmtOffset;
    
    return [[NSDate alloc] initWithTimeInterval:gmtInterval sinceDate:date];
    
}

#pragma mark Deserealizador para campos tipo date en json devuelve objeto NSDate
+(NSDate *)deserializeJsonDateString: (NSString *)jsonDateString
{
    NSInteger offset = [[NSTimeZone defaultTimeZone] secondsFromGMT]; //get number of seconds to add or subtract according to the client default time zone
    
    NSTimeInterval unixTime = [[jsonDateString substringWithRange:NSMakeRange(0, 13)] doubleValue] / 1000; //WCF will send 13 digit-long value for the time interval since 1970 (millisecond precision) whereas iOS works with 10 digit-long values (second precision), hence the divide by 1000
    
    return [[NSDate dateWithTimeIntervalSince1970:unixTime] dateByAddingTimeInterval:offset];
}

#pragma mark Conversor dado un NSDate devuelve una cadena de caracteres para el envio json. Devuelve UTC.
+(NSString *)serealizadorJsonDateToString:(NSDate *) date{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    return [dateFormatter stringFromDate:date];
}

#pragma mark Fecha actual NSString UTC formato ISO 8601 W3C DTF.
+(NSString *)dateNow{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

@end
