//
//  PartidoCell.m
//  Flattened
//
//  Created by Diego Maye on 05/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "PartidoCell.h"
#import "DateUtility.h"
#import "GraphicUtils.h"

@implementation PartidoCell

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

- (void)setPartido:(NSDictionary *)partido{
    if ([_partido isEqualToDictionary:partido]) {
        return;
    }
    
    _partido = partido;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageLocatario.image = [UIImage imageNamed:_partido[@"local"]];
    self.imageVisitante.image = [UIImage imageNamed:_partido[@"visitante"]];
    
    self.lblLocatario.text = _partido[@"local"];
    self.lblLocatario.textColor = [GraphicUtils colorMidnightBlue];
    self.lblLocatario.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:9];
    self.lblVisitante.text = _partido[@"visitante"];
    self.lblVisitante.textColor = [GraphicUtils colorMidnightBlue];
    self.lblVisitante.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:9];

    NSDate *date = [DateUtility deserializeJsonDateString:[_partido[@"fecha"] stringValue]];
   
    NSString *dateStringFormatter = [NSDateFormatter dateFormatFromTemplate:@"EdMMM" options:0
                                                              locale:[NSLocale currentLocale]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateStringFormatter];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSString *stringFromDate = [dateFormatter stringFromDate:date];
   
    _lblFechaPartido.text = stringFromDate;
    _lblFechaPartido.font = [UIFont fontWithName:@"ProximaNova-Bold" size:14];
    _lblFechaPartido.textColor = [GraphicUtils colorDefault];
    
    NSString * timeStringFormatter = [NSDateFormatter dateFormatFromTemplate:@"HH:mm" options:0 locale:[NSLocale currentLocale]];
    
    [dateFormatter setDateFormat:timeStringFormatter];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSString *stringFromTime = [dateFormatter stringFromDate:date];
    
    _lblHoraPartido.text = stringFromTime;
    _lblHoraPartido.font = [UIFont fontWithName:@"ProximaNova-Bold" size:15];
    _lblHoraPartido.textColor = [GraphicUtils colorMidnightBlue];
}

@end
