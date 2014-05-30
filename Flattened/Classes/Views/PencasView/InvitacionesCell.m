//
//  StoreCell.m
//  
//
//  Created by Valentin Filip on 3/15/13.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import "InvitacionesCell.h"

#import "DateUtility.h"

@implementation InvitacionesCell

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
    if ([_data isEqualToDictionary:data]) {
        return;
    }
    
    _data = data;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageVBkg.image = [[UIImage imageNamed:@"list-item-background"] resizableImageWithCapInsets:UIEdgeInsetsMake(50, 50, 30, 30)];
    
    self.imageVAvatar.image = [UIImage imageNamed:_data[@"person"][@"avatar"]];
    
    /*
     
     "idInvitacion": 278,
     "tipo": "ANFITRION",
     "fechaGenerada": 1398813735489,
     "nombreUsuarioCreador": "Juan Perez",
     "idPenca": 149,
     "nombrePenca": "Penca 1",
     "descripcionPenca": " Penca de prueba 1",
     "estadoPenca": "ACTIVA",
     "fechaInicioPenca": 1398813734462,
     "invitado": 3,
     "invitadoNombre": "Martince Maritnez",
     "invitadoImgToken": null,
     "creador": 2,
     "creadorImgToken": null
     */
    
    NSString *name = _data[@"invitadoNombre"];
        //NSString *email = @"";//_data[@"person"][@"email"];
    
        //NSString *text = [NSString stringWithFormat:@"%@ <%@>", name, email];
    NSString *text = [NSString stringWithFormat:@"%@", name];
    // Create the attributes
    
    const CGFloat fontSize = 10;
    UIFont *boldFont = [UIFont fontWithName:@"ProximaNova-Semibold" size:fontSize];
    UIFont *regularFont = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
    UIColor *regularColor = [UIColor colorWithRed:0.45f green:0.45f blue:0.45f alpha:1.00f];
    UIColor *boldColor = [UIColor colorWithRed:0.91f green:0.38f blue:0.39f alpha:1.00f];
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           regularFont, NSFontAttributeName,
                           regularColor, NSForegroundColorAttributeName, nil];
    NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                              boldFont, NSFontAttributeName,
                              boldColor, NSForegroundColorAttributeName, nil];
    const NSRange range = NSMakeRange(0, name.length);
    
    // Create the attributed string (text + attributes)
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:text
                                           attributes:attrs];
    [attributedText setAttributes:subAttrs range:range];
    
    [_lblSender setAttributedText:attributedText];
    
    _lblTitle.text = _data[@"nombrePenca"];
    _lblTitle.textColor = [UIColor colorWithRed:0.22f green:0.22f blue:0.22f alpha:1.00f];
    _lblTitle.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:14];
    
    _lblDescription.text = _data[@"descripcionPenca"];
    _lblDescription.textColor = [UIColor colorWithRed:0.45f green:0.45f blue:0.45f alpha:1.00f];
    _lblDescription.font = [UIFont fontWithName:@"ProximaNova-Regular" size:fontSize];
    
    NSDate *fechaGenerada = [DateUtility deserializeJsonDateString:[_data[@"fechaGenerada"] stringValue]];
    _lblDate.text = [self getTimeAsString:fechaGenerada];
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
