//
//  PartidoCell.m
//  Flattened
//
//  Created by Diego Maye on 05/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "ApuestaCell.h"
#import "DateUtility.h"
#import "GraphicUtils.h"

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

- (void)setPartido:(NSDictionary *)apuesta{
    if ([_apuesta isEqualToDictionary:apuesta]) {
        return;
    }
    
    _apuesta = apuesta;
    
    [self setNeedsLayout];
}

-(NSString*) calcEstado:(NSString*) estado{
    if ([estado isEqualToString:@"NO_INICIADO"]) {
        return NSLocalizedString(@"Not started", nil);
    }
    else if ([estado isEqualToString:@"BLOQUEADO"]){
        return NSLocalizedString(@"Blocked", nil);
    }
    else if ([estado isEqualToString:@"INICIADO"]){
        return NSLocalizedString(@"Started", nil);
    }
    else if ([estado isEqualToString:@"FINALIZADO"]){
        return NSLocalizedString(@"Ended", nil);
    }
    return @"Not started yet";
}

- (void)layoutSubviews {
    /*
     {
         estado = PENDIENTE;
         ganaLocal = 0;
         golesLocal = "<null>";
         golesVisitante = "<null>";
         idApuesta = 1504;
         localDesc = Netherlands;
         partido =         {
             estado = "NO_INICIADO";
             fecha = 1403539200000;
             fechaCampeonato = "Group B";
             golesLocal = 0;
             golesVisitante = 0;
             idFechaCampeonato = 1285;
             idPartido = 1308;
             local = Netherlands;
             tipo = DEFINIDO;
             visitante = Chile;
         };
         puntosGanados = 0;
         puntosPerdidos = 0;
         tipo = DEFINIDO;
         tipoFinal = 0;
         visitanteDesc = Chile;
     }
     */
    
    if ([[_apuesta valueForKey:@"estado"] isEqualToString:@"PENDIENTE"]) {
        self.imgEstado.backgroundColor = [GraphicUtils colorPumpkin];
        self.imgEstado.alpha = 0.7f;
        self.imgResultado.backgroundColor = [GraphicUtils colorPumpkin];
        self.imgResultado.alpha = 0.3f;
    }
    else if ([[_apuesta valueForKey:@"estado"] isEqualToString:@"INGRESADO"]){
        self.imgEstado.backgroundColor = [GraphicUtils colorDefault];
        self.imgEstado.alpha = 0.7f;
        self.imgResultado.backgroundColor = [GraphicUtils colorDefault];
        self.imgResultado.alpha = 0.3f;
    }
    
    self.lblEstado.text = [self calcEstado:[_apuesta valueForKey:@"partido"][@"estado"]];
    
    if ([[_apuesta valueForKey:@"partido"][@"estado"] isEqualToString:@"INICIADO"]){
        self.lblEstado.alpha = 0;
        [UIView animateWithDuration:1.0 delay:0.5 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
            self.lblEstado.alpha = 1;
        } completion:nil];
    }
    if ([UIImage imageNamed:[_apuesta valueForKey:@"localDesc"]]==nil) {
        self.imageLocatario.image = [UIImage imageNamed:@"field 4"];
    }
    else{
        self.imageLocatario.image = [UIImage imageNamed:[_apuesta valueForKey:@"localDesc"]];
    }
    if ([UIImage imageNamed:[_apuesta valueForKey:@"visitanteDesc"]]==nil) {
        self.imageVisitante.image = [UIImage imageNamed:@"field 4"];
    }
    else{
        self.imageVisitante.image = [UIImage imageNamed:[_apuesta valueForKey:@"visitanteDesc"]];
    }
        //#e74c3c Naranja
        //#27ae60 Verde
        //#f1c40f Amarillo
    
    _lblNombreLocatario.text= [NSLocalizedString([_apuesta valueForKey:@"localDesc"],nil) uppercaseString];
    
    _lblNombreVisitante.text= [NSLocalizedString([_apuesta valueForKey:@"visitanteDesc"],nil) uppercaseString];
    
    _lblNombreLocatario.textColor = [GraphicUtils colorMidnightBlue];
    _lblNombreLocatario.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:12];
    _lblNombreVisitante.textColor = [GraphicUtils colorMidnightBlue];
    _lblNombreVisitante.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:12];
    
    if ([[_apuesta valueForKey:@"golesLocal"] isKindOfClass : [NSNull class]]) {
        _lblResultadoLocatario.text = @"X";
    }
    else{
        _lblResultadoLocatario.text = [[_apuesta valueForKey:@"golesLocal"] stringValue];
    }
    if ([[_apuesta valueForKey:@"golesVisitante"] isKindOfClass : [NSNull class]]) {
        _lblResultadoVisitante.text = @"X";
    }
    else{
        _lblResultadoVisitante.text = [[_apuesta valueForKey:@"golesVisitante"] stringValue];
    }
    
    NSDate *date = [DateUtility deserializeJsonDateString:[[_apuesta valueForKey:@"partido"][@"fecha"] stringValue]];
    /*
    NSString *dateString = [NSDateFormatter localizedStringFromDate:date
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    */
    
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"EdMMM - HH:mm" options:0
                                                              locale:[NSLocale currentLocale]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSString *stringFromDate = [dateFormatter stringFromDate:date];
    _lblFechaPartido.text = stringFromDate;
}

@end
