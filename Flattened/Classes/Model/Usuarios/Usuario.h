//
//  Usuario.h
//  Flattened
//
//  Created by Diego Maye on 09/05/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface Usuario : JSONModel

#pragma mark Variables Servidor

@property(nonatomic, strong) NSString* password;
@property(nonatomic, strong) NSString* rePassword;
@property(nonatomic, strong) NSString* email;
@property(nonatomic, strong) NSString<Optional>* gcmRegID;
@property(nonatomic, strong) NSString<Optional>* apnsDeviceToken;
@property(nonatomic, strong) NSString<Optional>* lastDevModelUsed;
@property(nonatomic, strong) NSString<Optional>* lastDevAndroid;
@property(nonatomic, strong) NSString<Optional>* lastDevAppleModelUsed;
@property(nonatomic, strong) NSString<Optional>* lastDevApple;
@property(nonatomic, strong) NSString* locale;

@property(nonatomic, strong) NSString<Optional>* facebookToken;
@property(nonatomic, strong) NSString<Optional>* faceID;

@property(nonatomic, strong) NSString<Optional>* nombreCompleto;
@property(nonatomic, strong) NSString* nombre;
@property(nonatomic, strong) NSString<Optional>* apellido;
@property(nonatomic, assign, getter=isMasculino) BOOL masculino;
@property(nonatomic, assign, getter=isCorreoExiste) BOOL correoExiste;
@property(nonatomic, assign, getter=isValida) BOOL valida;
@property(nonatomic, assign, getter=isCuentaFacebook) BOOL cuentaFacebook;

@end
