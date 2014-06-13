//
//  StoreCell.m
//  
//
//  Created by Valentin Filip on 3/15/13.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import "PencaCell.h"

#import "DateUtility.h"
#import "GraphicUtils.h"

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
    
    const CGFloat fontSize = 11;
    
    _lblTitle.text = _penca[@"nombre"];
    _lblTitle.textColor = [GraphicUtils colorDefault];
    _lblTitle.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:15];
    
    _lblDescription.text = _penca[@"descripcion"];
    _lblDescription.textColor = [UIColor colorWithRed:0.45f green:0.45f blue:0.45f alpha:1.00f];
    _lblDescription.font = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
    
    _lblPozo.text = [_penca[@"pozoTotal"] stringValue];
    _lblPozo.textColor = [UIColor colorWithRed:0.67f green:0.67f blue:0.67f alpha:1.00f];
    _lblPozo.font = [UIFont fontWithName:@"ProximaNova-SemiboldIt" size:10];
    
    _lblUsuarios.text = [_penca[@"cantUsuarios"] stringValue];
    _lblUsuarios.textColor = [UIColor colorWithRed:0.67f green:0.67f blue:0.67f alpha:1.00f];
    _lblUsuarios.font = [UIFont fontWithName:@"ProximaNova-SemiboldIt" size:10];
    
    NSDate *date = [DateUtility deserializeJsonDateString:[_penca[@"fechaHoraGeneracion"] stringValue]];
    _lblDate.text = [DateUtility getTimeAsString:date];
    _lblDate.textColor = [UIColor colorWithRed:0.67f green:0.67f blue:0.67f alpha:1.00f];
    _lblDate.font = [UIFont fontWithName:@"ProximaNova-SemiboldIt" size:10];
    
}




@end
