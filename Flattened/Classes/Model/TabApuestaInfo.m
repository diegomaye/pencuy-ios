//
//  TabApuestaInfo.m
//  Flattened
//
//  Created by Diego Maye on 26/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "TabApuestaInfo.h"

@implementation TabApuestaInfo

@synthesize idFechaCampeonato= _idFechaCampeonato;
@synthesize nombre= _nombre;
@synthesize descripcion= _descripcion;
@synthesize fechaFinalizacion= _fechaFinalizacion;
@synthesize fechaInicio = _fechaInicio;

-(id)initWithTabApuestaId:(NSNumber*) idFecha
                  andName:(NSString*) name
           andDescription:(NSString*)description
              andFechaFin:(NSDate*)fechaFin
                andInicio:(NSDate*) fechaInicio
        andControllerName:(NSString*) viewController{
    
    self = [super initWithTabName:name andViewController:viewController];
    
    if (self) {
        _idFechaCampeonato = idFecha;
        _nombre = name;
        _descripcion = description;
        _fechaFinalizacion= fechaFin;
        _fechaInicio = fechaInicio;
    }
    return self;
}
@end
