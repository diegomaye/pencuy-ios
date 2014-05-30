//
//  StoreCell.m
//  
//
//  Created by Valentin Filip on 3/15/13.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import "PencaCell.h"

#import "DataSource.h"

#import "DateUtility.h"

@implementation PencaCell

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self initialize];
    }
    return self;
}

+ (void)initialize {
    
}

- (void)initialize {
    [[self class] initialize];
    
}


#pragma mark - Accessors

- (void)setData:(NSDictionary *)data {
    if ([_penca isEqualToDictionary:data]) {
        return;
    }
    
    _penca = data;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageVBkg.image = [[UIImage imageNamed:@"list-item-background"] resizableImageWithCapInsets:UIEdgeInsetsMake(50, 50, 30, 30)];
     
    const CGFloat fontSize = 10;
    
    _lblTitle.text = _penca[@"nombre"];
    _lblTitle.textColor = [UIColor colorWithRed:0.22f green:0.22f blue:0.22f alpha:1.00f];
    _lblTitle.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:14];
    
    _lblDescription.text = _penca[@"descripcion"];
    _lblDescription.textColor = [UIColor colorWithRed:0.45f green:0.45f blue:0.45f alpha:1.00f];
    _lblDescription.font = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
    
    NSDate *date = [DateUtility deserializeJsonDateString:[_penca[@"fechaHoraGeneracion"] stringValue]];
    _lblDate.text = [self getTimeAsString:date];
    _lblDate.textColor = [UIColor colorWithRed:0.67f green:0.67f blue:0.67f alpha:1.00f];
    _lblDate.font = [UIFont fontWithName:@"ProximaNova-SemiboldIt" size:8];
    
}


- (NSString*)getTimeAsString:(NSDate *)lastDate {
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
                time = [NSString stringWithFormat:@"%d days ago", nrDays];
            }
        } else {
            if (nrHours == 0) {
                if (nrMinutes < 2) {
                    time = @"just now";
                } else {
                    time = [NSString stringWithFormat:@"%d minutes ago", nrMinutes];
                }
            } else { // days=0 hours!=0
                if (nrHours == 1) {
                    time = @"1 hour ago";
                } else {
                    time = [NSString stringWithFormat:@"%d hours ago", nrHours];
                }
            }
        }
    }
    
    return [NSString stringWithFormat:NSLocalizedString(@"%@", @"label"), time];
}

@end
