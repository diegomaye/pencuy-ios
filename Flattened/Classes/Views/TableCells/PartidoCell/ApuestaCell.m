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
    self.lblYourBet.text = NSLocalizedString(@"Your bet",nil);
    
    NSString* estadoPartido= [_apuesta valueForKey:@"partido"][@"estado"];
    
    if ([[_apuesta valueForKey:@"estado"] isEqualToString:@"PENDIENTE"]) {
        self.imgEstado.backgroundColor = [GraphicUtils colorPumpkin];
        self.imgEstado.alpha = 0.7f;
        self.imgResultado.backgroundColor = [GraphicUtils colorPumpkin];
        self.imgResultado.alpha = 0.3f;
    }
    else if ([[_apuesta valueForKey:@"estado"] isEqualToString:@"INGRESADO"] && [estadoPartido isEqualToString:@"FINALIZADO"]){
        self.imgEstado.backgroundColor = [GraphicUtils colorDefault];
        self.imgEstado.alpha = 0.7f;
        self.imgResultado.backgroundColor = [GraphicUtils colorDefault];
        self.imgResultado.alpha = 0.3f;
    }
    else if ([[_apuesta valueForKey:@"estado"] isEqualToString:@"INGRESADO"] && [estadoPartido isEqualToString:@"NO_INICIADO"]){
        self.imgEstado.backgroundColor = [GraphicUtils colorFromRGBHexString:@"#16a085"];
        self.imgEstado.alpha = 0.7f;
        self.imgResultado.backgroundColor = [GraphicUtils colorFromRGBHexString:@"#16a085"];
        self.imgResultado.alpha = 0.3f;
    }
    else if ([[_apuesta valueForKey:@"estado"] isEqualToString:@"INGRESADO"] && [estadoPartido isEqualToString:@"INICIADO"]){
        self.imgEstado.backgroundColor = [GraphicUtils colorSunFlower];
        self.imgEstado.alpha = 0.7f;
        self.imgResultado.backgroundColor = [GraphicUtils colorSunFlower];
        self.imgResultado.alpha = 0.3f;
    }
    
    self.lblEstado.text = [self calcEstado:estadoPartido];
    
    if ([[_apuesta valueForKey:@"partido"][@"estado"] isEqualToString:@"INICIADO"]){
        self.lblEstado.alpha = 0;
        self.lblResultadoLocatario.alpha = 0;
        self.lblResultadoVisitante.alpha = 0;
        self.lblSeparadorResultado.alpha = 0;
        self.lblFechaPartido.alpha = 0;
        [UIView animateWithDuration:0.8 delay:0.3 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
            self.lblEstado.alpha = 1;
            self.lblResultadoLocatario.alpha = 1;
            self.lblResultadoVisitante.alpha = 1;
            self.lblSeparadorResultado.alpha = 1;
            self.lblFechaPartido.alpha = 1;
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
    
    /*RESULTADO REAL*/
    
    if ([[_apuesta valueForKey:@"partido"][@"golesLocal"] intValue]==0 && [[_apuesta valueForKey:@"partido"][@"estado"] isEqualToString:@"NO_INICIADO"]) {
        self.lblResultadoLocatario.text = @"X";
    }
    else{
        self.lblResultadoLocatario.text = [[_apuesta valueForKey:@"partido"][@"golesLocal"] stringValue];
    }
    if ([[_apuesta valueForKey:@"partido"][@"golesVisitante"] intValue]==0 && [[_apuesta valueForKey:@"partido"][@"estado"] isEqualToString:@"NO_INICIADO"]) {
        self.lblResultadoVisitante.text = @"X";
    }
    else{
        self.lblResultadoVisitante.text = [[_apuesta valueForKey:@"partido"][@"golesVisitante"] stringValue];
    }
    
    
    /*RESULTADO APOSTADO*/
    NSMutableString* resultadoApuesta = [NSMutableString new];
    
    if ([[_apuesta valueForKey:@"golesLocal"] isKindOfClass : [NSNull class]]) {
        [resultadoApuesta appendString:@"X"];
    }
    else{
        [resultadoApuesta appendString:[[_apuesta valueForKey:@"golesLocal"] stringValue]];
    }
    [resultadoApuesta appendString:@"  :  "];
    if ([[_apuesta valueForKey:@"golesVisitante"] isKindOfClass : [NSNull class]]) {
        [resultadoApuesta appendString:@"X"];
    }
    else{
        [resultadoApuesta appendString:[[_apuesta valueForKey:@"golesVisitante"] stringValue]];
    }
    self.lblResultadoApostado.text = resultadoApuesta;
    
    /*RESULTADO REAL*/
    self.lblPuntosGanados.hidden=YES;
    if ([[_apuesta valueForKey:@"partido"][@"estado"] isEqualToString:@"FINALIZADO"]) {
        self.lblPuntosGanados.hidden = NO;
        if ([[_apuesta valueForKey:@"puntosGanados"] intValue]==0) {
            self.lblPuntosGanados.text = NSLocalizedString(@"Didn't win any points", nil);
        }
        else{
            self.lblPuntosGanados.text = [NSString stringWithFormat:NSLocalizedString(@"You win %@ points",nil), [[_apuesta valueForKey:@"puntosGanados"] stringValue]];
        }
    }
    
    /*FECHA Y HORA DEL PARTIDO.*/
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
    //[dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    
    NSString *stringFromDate = [dateFormatter stringFromDate:date];
    _lblFechaPartido.text = stringFromDate;
}

@end
