//
//  TabApuestaInfo.h
//  Flattened
//
//  Created by Diego Maye on 26/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TabInfo.h"

@interface TabApuestaInfo : TabInfo

@property(nonatomic, strong) NSNumber* idFechaCampeonato;
@property(nonatomic,strong) NSString* nombre;
@property(nonatomic,strong) NSString* descripcion;
@property(nonatomic,strong) NSDate* fechaInicio;
@property(nonatomic, strong) NSDate* fechaFinalizacion;

-(id)initWithTabApuestaId:(NSNumber*) idFecha
                  andName:(NSString*) name
           andDescription:(NSString*)description
              andFechaFin:(NSDate*)fechaFin
                andInicio:(NSDate*) fechaInicio
        andControllerName:(NSString*) viewController;

@end
