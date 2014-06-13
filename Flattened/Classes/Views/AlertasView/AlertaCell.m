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
#import "GraphicUtils.h"
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
    
    NSString* estado = _alerta[@"tipoAlerta"];
    if ([estado isEqualToString:@"SERVER_WELCOME"]) {
        Usuario* usuario = [AppDelegate getUsuario];
        if ([usuario faceID]!=nil&&![[usuario faceID] isEqualToString:@""]) {
            self.imagenPrincipal.hidden=YES;
            self.imagenFacebook.hidden=NO;
            self.imagenFacebook.profileID = usuario.faceID;
            [GraphicUtils makeSquadViewRounded:self.imagenFacebook];
        }
        else{
            self.imagenPrincipal.hidden=NO;
            self.imagenFacebook.hidden=YES;
            self.imagenPrincipal.image = [UIImage imageNamed:@"icon-avatar-60x60"];
        }
    }
    else if (_alerta[@"faceId"] && ![_alerta[@"faceId"] isKindOfClass:[NSNull class]]){
        self.imagenPrincipal.hidden=YES;
        self.imagenFacebook.hidden=NO;
        self.imagenFacebook.profileID = _alerta[@"faceId"];
        [GraphicUtils makeSquadViewRounded:self.imagenFacebook];
    }
    else if ([estado isEqualToString:@"ACEPTO_INVITACION"]) {
        self.imagenFacebook.hidden=YES;
        self.imagenPrincipal.image = [UIImage imageNamed:@"icon-avatar-60x60"];
    }
    else if ([estado isEqualToString:@"RECHAZO_INVITACION"]) {
        self.imagenFacebook.hidden=YES;
        self.imagenPrincipal.image = [UIImage imageNamed:@"icon-avatar-60x60"];
    }
    else if ([estado isEqualToString:@"INVITACION"]) {
        self.imagenFacebook.hidden=YES;
        self.imagenPrincipal.image = [UIImage imageNamed:@"icon-avatar-60x60"];
    }
    else if ([estado isEqualToString:@"GANA_DEFINICION"]) {
        self.imagenFacebook.hidden=YES;
        self.imagenPrincipal.image = [UIImage imageNamed:@"icon-avatar-60x60"];
    }
    else if ([estado isEqualToString:@"GANA_RESULTADO"]) {
        self.imagenFacebook.hidden=YES;
        self.imagenPrincipal.image = [UIImage imageNamed:@"icon-avatar-60x60"];
    }
    else if ([estado isEqualToString:@"APUESTA_EDIT"]) {
        self.imagenFacebook.hidden=YES;
        self.imagenPrincipal.image = [UIImage imageNamed:@"icon-avatar-60x60"];
    }
    else if ([estado isEqualToString:@"SERVER_MSG"]) {
        self.imagenFacebook.hidden=YES;
        self.imagenPrincipal.image = [UIImage imageNamed:@"icon-avatar-60x60"];
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
        //self.imagenTiempo.image = [UIImage imageNamed:@"ic_menu_recent_history"];
    
    self.title.text= _alerta[@"title"];
    self.title.textColor = [GraphicUtils colorFromRGBHexString:@"#27ae60"];
    self.body.text = _alerta[@"body"];

    NSDate *fechaGenerada = [DateUtility deserializeJsonDateString:[_alerta[@"fecha"] stringValue]];
    _fecha.text = [DateUtility getTimeAsString:fechaGenerada];
    _fecha.textColor = [UIColor colorWithRed:0.67f green:0.67f blue:0.67f alpha:1.00f];
    _fecha.font = [UIFont fontWithName:@"ProximaNova-SemiboldIt" size:10];
}


@end
