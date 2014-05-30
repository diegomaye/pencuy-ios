//
//  PartidoCell.m
//  Flattened
//
//  Created by Diego Maye on 05/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "ApuestaCell.h"
#import "DateUtility.h"
#import "DataSource.h"

@implementation ApuestaCell

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
    
    self.imageLocatario.image = [UIImage imageNamed:_partido[@"local"]];
    self.imageVisitante.image = [UIImage imageNamed:_partido[@"visitante"]];
    
    
    _lblNombreLocatario.text= _partido[@"local"];
    _lblNombreVisitante.text= _partido[@"visitante"];
    if (_partido[@"golesLocal"]==[NSNumber numberWithInt:-1]) {
        _lblResultadoLocatario.text = @"?";
    }
    else{
        _lblResultadoLocatario.text = [_partido[@"golesLocal"] stringValue];
    }
    if (_partido[@"golesVisitante"]==[NSNumber numberWithInt:-1]) {
        _lblResultadoVisitante.text = @"?";
    }
    else{
        _lblResultadoVisitante.text = [_partido[@"golesVisitante"] stringValue];
    }
    
    NSDate *date = [DateUtility deserializeJsonDateString:[_partido[@"fecha"] stringValue]];
    /*
    NSString *dateString = [NSDateFormatter localizedStringFromDate:date
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    */
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy - HH:mm"];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    _lblFechaPartido.text = stringFromDate;
}

@end
