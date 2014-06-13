//
//  StoreCell.m
//  
//
//  Created by Valentin Filip on 3/15/13.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import "InvitacionesCell.h"
#import "DateUtility.h"
#import "GraphicUtils.h"

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
    
    /*
     idInvitacion: 1744
     tipo: "ANFITRION"
     fechaGenerada: 1401688685856
     nombreUsuarioCreador: "Juan Carrocio"
     idPenca: 1666
     nombrePenca: "Penca pibes"
     descripcionPenca: "la penca de la gente"
     estadoPenca: "ACTIVA"
     fechaInicioPenca: 1401584426215
     invitado: 1426
     invitadoNombre: "Diego Maye"
     invitadoImgToken: null
     creador: 1579
     creadorImgToken: null
     faceIdInvitado: "10203009223044888"
     faceIdCreador: null
     cantUsuarios: 1
     pozo: 2200
     */
    
    if(_data[@"faceIdInvitado"] && ![[_data valueForKey:@"faceIdInvitado"] isKindOfClass : [NSNull class]]){
        self.imageFacebook.hidden = NO;
        [GraphicUtils makeSquadViewRounded:self.imageFacebook];
        self.imageVAvatar.hidden = YES;
        NSString* face = _data[@"faceIdInvitado"];
        self.imageFacebook.profileID = face;
        
    }
    else {
        self.imageFacebook.hidden = YES;
        self.imageVAvatar.hidden = NO;
        self.imageVAvatar.image = [UIImage imageNamed:@"icon-avatar-60x60"];
    }
    self.lblUserName.text =_data[@"invitadoNombre"];
 
    self.lblUserName.textColor = [GraphicUtils colorDefault];
    self.lblUserName.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:16];
    
    self.lblDescription.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Invited by",nil), _data[@"nombreUsuarioCreador"]];
    self.lblDescription.textColor = [GraphicUtils colorMidnightBlue];
    self.lblDescription.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:12];
    
    NSDate *date = [DateUtility deserializeJsonDateString:[_data[@"fechaGenerada"] stringValue]];
    _lblDate.text = [DateUtility getTimeAsString:date];
    _lblDate.textColor = [UIColor colorWithRed:0.67f green:0.67f blue:0.67f alpha:1.00f];
    _lblDate.font = [UIFont fontWithName:@"ProximaNova-SemiboldIt" size:10];
    
}


@end
