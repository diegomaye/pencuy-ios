//
//  Penca.h
//  Flattened
//
//  Created by Diego Maye on 24/11/13.
//  Copyright (c) 2013 AppDesignVault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Penca : NSObject

@property int idPenca;

@property(strong, nonatomic) NSString* nombre;

@property(strong, nonatomic) NSString* descripcion;

@property(strong, nonatomic) NSDate* fechaHoraGeneracion;
@property(strong, nonatomic) NSDate* fechaHoraInicio;
@property(strong, nonatomic) NSString* estado;

@property BOOL mostrarApuestas;

@property(strong, nonatomic) NSArray* partidos;

@property(strong, nonatomic) NSArray* usuariosPenca;

@property(strong, nonatomic) NSArray* porcentajesGanadores;

@property(nonatomic, assign) CGFloat costoUnitario;

@property(nonatomic, assign) CGFloat pozoTotal;

@end
