//
//  PartidoCell.m
//  Flattened
//
//  Created by Diego Maye on 05/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "AlertaCell.h"
#import "DateUtility.h"
#import "AppDelegate.h"

@implementation AlertaCell

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

- (void)setAlerta:(NSDictionary *)alerta{
    if ([_alerta isEqualToDictionary:alerta]) {
        return;
    }
    
    _alerta = alerta;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageVBkg.image = [[UIImage imageNamed:@"list-item-background"] resizableImageWithCapInsets:UIEdgeInsetsMake(50, 50, 30, 30)];
    NSString* estado = _alerta[@"tipoAlerta"];
    if ([estado isEqualToString:@"ACEPTO_INVITACION"]) {
        self.imagenPrincipal.image = [UIImage imageNamed:@"ic_menu_invite"];
    }
    else if ([estado isEqualToString:@"RECHAZO_INVITACION"]) {
        self.imagenPrincipal.image = [UIImage imageNamed:@"ic_menu_blocked_user"];
    }
    else if ([estado isEqualToString:@"INVITACION"]) {
        self.imagenPrincipal.image = [UIImage imageNamed:@"ic_menu_cc"];
    }
    else if ([estado isEqualToString:@"GANA_DEFINICION"]) {
        self.imagenPrincipal.image = [UIImage imageNamed:@"ic_menu_myplaces"];
    }
    else if ([estado isEqualToString:@"GANA_RESULTADO"]) {
        self.imagenPrincipal.image = [UIImage imageNamed:@"ic_menu_myplaces"];
    }
    else if ([estado isEqualToString:@"APUESTA_EDIT"]) {
        self.imagenPrincipal.image = [UIImage imageNamed:@"ic_menu_compose"];
    }
    else if ([estado isEqualToString:@"SERVER_MSG"]) {
        self.imagenPrincipal.image = [UIImage imageNamed:@"ic_menu_contact"];
    }
    else if ([estado isEqualToString:@"SERVER_WELCOME"]) {
        Usuario* usuario = [AppDelegate getUsuario];
        if ([usuario faceID]!=nil&&![[usuario faceID] isEqualToString:@""]) {
            self.imagenPrincipal.hidden=YES;
            self.imagenFacebook.hidden=NO;
            self.imagenFacebook.profileID = usuario.faceID;
            self.imagenFacebook.pictureCropping = FBProfilePictureCroppingOriginal;
        }
        else{
            self.imagenPrincipal.hidden=NO;
            self.imagenFacebook.hidden=YES;
            self.imagenPrincipal.image = [UIImage imageNamed:@"icon-avatar-60x60"];
        }
    }
    /*
     ACEPTO_INVITACION
     RECHAZO_INVITACION
     INVITACION
     GANA_DEFINICION
     GANA_RESULTADO
     APUESTA_EDIT
     SERVER_MSG
     SERVER_WELCOME
     */
    
        //self.imagenPrincipal.image = [UIImage imageNamed:@"ic_menu_contact"];
    self.imagenTiempo.image = [UIImage imageNamed:@"ic_menu_recent_history"];
    
    self.title.text= _alerta[@"title"];
    self.title.textColor = [self colorFromRGBHexString:@"#07B196"];
    self.body.text = _alerta[@"body"];

    NSDate *fechaGenerada = [DateUtility deserializeJsonDateString:[_alerta[@"fecha"] stringValue]];
    _fecha.text = [self getTimeAsString:fechaGenerada];
    _fecha.textColor = [UIColor colorWithRed:0.67f green:0.67f blue:0.67f alpha:1.00f];
    _fecha.font = [UIFont fontWithName:@"ProximaNova-SemiboldIt" size:10];
}

-(UIColor *)colorFromRGBHexString:(NSString *)colorString {
    if(colorString.length == 7) {
        const char *colorUTF8String = [colorString UTF8String];
        int r, g, b;
        sscanf(colorUTF8String, "#%2x%2x%2x", &r, &g, &b);
        return [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:1.0];
    }
    return nil;
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
