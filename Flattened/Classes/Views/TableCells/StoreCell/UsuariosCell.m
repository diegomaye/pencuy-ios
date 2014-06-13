//
//  StoreCell.m
//  
//
//  Created by Valentin Filip on 3/15/13.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import "UsuariosCell.h"
#import "GraphicUtils.h"

@implementation UsuariosCell

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
        apellido = Maye;
        email = "diegomaye@gmail.com";
        estado = ACTIVO;
        faceID = 10203009223044888;
        idUsuario = 1426;
        imgtoken = "<null>";
        nombre = "Diego Maye";
        pais = "<null>";
        posicion = 1;
        puntosGanados = 0;
        puntosPerdidos = 0;
        tipo = CREADOR;
        totApGanExa = 0;
        totApGanNoExa = 0;
        totApIngresada = 0;
        totApuesta = 64;
        */
    
    if(_data[@"faceID"] && ![[_data valueForKey:@"faceID"] isKindOfClass : [NSNull class]]){
        self.imageFacebook.hidden = NO;
        [GraphicUtils makeSquadViewRounded:self.imageFacebook];
        self.imageVAvatar.hidden = YES;
        NSString* face = _data[@"faceID"];
        self.imageFacebook.profileID = face;
        
    }
    else {
        self.imageFacebook.hidden = YES;
        self.imageVAvatar.hidden = NO;
        self.imageVAvatar.image = [UIImage imageNamed:@"icon-avatar-60x60"];
    }
    if (_data[@"nombre"]) {
        self.lblUserName.text =_data[@"nombre"];

    }
    else{
        self.lblUserName.text =_data[@"email"];
    }
    self.lblUserName.textColor = [GraphicUtils colorDefault];
    self.lblUserName.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:16];
    self.lblPosition.text = [_data[@"posicion"] stringValue];
    self.lblPuntos.text = [NSString stringWithFormat:@"%@ Pts.", [_data[@"puntosGanados"] stringValue]];
    /*
     long total = user.getTotApuesta() > 0 ? user.getTotApuesta() : 1;
     long totalIngresado = user.getTotApIngresada() > 0 ? user.getTotApIngresada() : 1;
     long completado = (user.getTotApIngresada() * 100) / total;
     long acierto = ((user.getTotApGanExa() + user.getTotApGanNoExa()) * 100) / totalIngresado;
     */
    int totalApuestas = [_data[@"totApuesta"]intValue] > 0 ? [_data[@"totApuesta"]intValue] : 1;
    int totalIngresado = [_data[@"totApIngresada"] intValue] > 0 ? [_data[@"totApIngresada"] intValue] : 1;
    int porcentajeCompletado = [_data[@"totApIngresada"] intValue]*100/totalApuestas;
    int porcentajeAcierto = (([_data[@"totApGanExa"] intValue] + [_data[@"totApGanNoExa"] intValue])*100 / totalIngresado);
    self.lblCompletado.text = [NSString stringWithFormat:@"%d%%%@",porcentajeCompletado, NSLocalizedString(@"Comp.", nil)];
    
    self.lblAcierto.text = [NSString stringWithFormat:@"%d%%%@",porcentajeAcierto, NSLocalizedString(@"Success", nil)];
    
    self.lblCompletado.alpha = 0.5;
    self.lblAcierto.alpha = 0.5;
    self.lblPuntos.alpha = 0.5;
    
}


@end
