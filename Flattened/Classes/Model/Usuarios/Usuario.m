//
//  Usuario.m
//  Flattened
//
//  Created by Diego Maye on 09/05/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "Usuario.h"

@implementation Usuario
#pragma mark variables internas

@synthesize password;
@synthesize rePassword;
@synthesize email;
@synthesize gcmRegID;
@synthesize apnsDeviceToken;
@synthesize lastDevModelUsed;
@synthesize lastDevAndroid;
@synthesize lastDevAppleModelUsed;
@synthesize lastDevApple;
@synthesize locale;

@synthesize facebookToken;	
@synthesize faceID;

@synthesize nombreCompleto;
@synthesize nombre;
@synthesize apellido;
@synthesize masculino;
@synthesize correoExiste;
@synthesize valida;
@synthesize cuentaFacebook;

-(Usuario*) initWithDictionary:(NSDictionary*) diccionario{
    self.password = diccionario[@"password"];
    self.rePassword = diccionario[@"rePassword"];
    self.email = diccionario[@"email"];
    self.gcmRegID = diccionario[@"gcmRegID"];
    self.apnsDeviceToken = diccionario[@"apnsDeviceToken"];
    self.lastDevModelUsed = diccionario[@"lastDevModelUsed"];
    self.lastDevAndroid = diccionario[@"lastDevAndroid"];
    self.lastDevAppleModelUsed = diccionario[@"lastDevAppleModelUsed"];
    self.lastDevApple = diccionario[@"lastDevApple"];
    self.locale = diccionario[@"locale"];
    
    self.facebookToken = diccionario[@"facebookToken"];
    self.faceID = diccionario[@"faceID"];
    
    self.nombreCompleto = diccionario[@"nombreCompleto"];
    self.nombre = diccionario[@"nombre"];
    self.apellido = diccionario[@"apellido"];
    self.masculino = diccionario[@"masculino"];
    self.correoExiste = diccionario[@"correoExiste"];
    self.valida = diccionario[@"valida"];
    self.cuentaFacebook = diccionario[@"cuentaFacebook"];
    return self;
}

@end
