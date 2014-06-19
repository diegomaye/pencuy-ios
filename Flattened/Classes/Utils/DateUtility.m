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
    NSInteger offset = [[NSTimeZone timeZoneWithName:@"UTC"] secondsFromGMT]; //get number of seconds to add or subtract according to the client default time zone
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

+ (NSString*)getTimeAsString:(NSDate *)lastDate {
    NSTimeInterval dateDiff =  [[NSDate date] timeIntervalSinceDate:lastDate];
    
    int nrSeconds = dateDiff;//components.second;
    int nrMinutes = nrSeconds / 60;
    int nrHours = nrSeconds / 3600;
    int nrDays = dateDiff / 86400; //components.day;
    
    NSString *time;
    if (nrDays > 5){
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateStyle:NSDateFormatterShortStyle];
        [dateFormat setTimeStyle:NSDateFormatterNoStyle];
        
        time = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:lastDate]];
    } else {
            // days=1-5
        if (nrDays > 0) {
            if (nrDays == 1) {
                time = @"1 day ago";
            } else {
                time = [NSString stringWithFormat:NSLocalizedString(@"%d days ago",nil), nrDays];
            }
        } else {
            if (nrHours == 0) {
                if (nrMinutes < 2) {
                    time = @"just now";
                } else {
                    time = [NSString stringWithFormat:NSLocalizedString(@"%d minutes ago",nil), nrMinutes];
                }
            } else { // days=0 hours!=0
                if (nrHours == 1) {
                    time = @"1 hour ago";
                } else {
                    time = [NSString stringWithFormat:NSLocalizedString(@"%d hours ago",nil), nrHours];
                }
            }
        }
    }
    
    return time;
}

@end
