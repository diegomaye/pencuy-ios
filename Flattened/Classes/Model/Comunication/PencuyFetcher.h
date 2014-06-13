//
//  PencuyFetcher.h
//  Flattened
//
//  Created by Diego Maye on 15/01/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Usuario.h"
#import "NSUserDefaults+Usuario.h"
@interface PencuyFetcher : NSObject

+ (NSURL *)URLForQuery:(NSString *)query kindOf:(NSString *)kind;

+ (NSURL *)URLAPIForQuery:(NSString *)query;

+ (NSURL *)URLPublicForQuery:(NSString *)query;

#pragma mark API Publica logueo y creacion de usuario UsuarioPublicFacadeREST

+ (NSURL *)URLtoCheckUser;
+ (NSURL *)URLtoActivateUser;
+ (NSURL *)URLtoCreateUser;
+ (NSURL *)URLtoCreateFaceUser;
+ (NSURL *)URLtoGetUserByFaceId:(NSString*)faceId;
+ (NSURL *)URLtoLoginUser;
+ (NSURL *)URLtoResetPassword;


#pragma mark Api Privada para partidos
+ (NSURL *)URLtoQueryPartido:(NSString *)idPartido;
+ (NSURL *)URLAPIForPencaBrasil;
#pragma mark Api Privada para fechas
+ (NSURL *)URLtoQueryFechas:(NSString *)nombreCampeonato;
#pragma mark Api Privada para apuestas
+ (NSURL *)URLtoQueryApuestasIdPenca:(NSString *)idPenca andEstado:(NSString *)estado;
+ (NSURL *)URLtoQueryApuestasIdPenca:(NSString *)idPenca andFecha:(NSString *)fecha;
+ (NSURL *)URLtoMakeApuestas;

#pragma mark Api Privada para pencas
+ (NSURL *)URLtoQueryPencasActivas;
+ (NSURL *)URLtoQueryPencas;
+ (NSURL *)URLtoQueryUsuariosPenca:(NSString *)idPenca;

#pragma mark Api Privada para invitaciones
+ (NSURL *)URLtoQueryInvitacionesByIdPenca:(NSString *) idPenca;
+ (NSURL *)URLtoQueryInvitaciones;
+ (NSURL *)URLtoCreateInvitacion;
+ (NSURL *)URLtoAceptRevocarInvitacion:(NSString *)idInvitacion withBooleanSting:(NSString *) trueFalse;

#pragma mark Api Privada para equipos
+ (NSURL *)URLtoQueryEquipos;

#pragma mark Api Privada para alertas
+ (NSURL *)URLtoQueryAlertas;

#pragma mark Api Privada para suggest de usuarios
+ (NSURL *)URLtoQuerySystemUsers:(NSString*)idPenca withSuggest:(NSString*) suggest;

#pragma mark Api Privada para usuarios
+ (NSURL *)URLtoQueryProfile;

#pragma mark Api privada consulta resumen grupos
+ (NSURL *)URLtoQueryResumenGrupos:(NSString*) idFechaCampeonato;

#pragma mark Api Privada para estadisticas
+ (NSURL *)URLtoQueryEstadisticas:(NSString *) idEquipo;

#pragma mark Mutli Fetcher para creación dinamica de consultas.
+(void)multiFetcher:(NSURL *)url
           withHTTP:(NSString *)httpMethod
        withHandler:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError))callbackBlock;

+(NSDictionary*)multiFetcherSync:(NSURL *)url
                        withHTTP:(NSString *) httpMethod
                        withData:(NSData *)requestData;

+(NSArray*)multiFetcherGetArraySync:(NSURL *)url
                           withHTTP:(NSString *) httpMethod
                           withData:(NSData *)requestData;

+(NSDictionary*)multiFetcherSyncPublic:(NSURL *)url
                              withHTTP:(NSString *) httpMethod
                              withData:(NSData *)requestData
                          withUserName:(NSString*) userName
                          withPassword:(NSString*) password
                    communicationError:(NSError **) connError
                jsonSerializationError:(NSError **) jsonError;

+(NSDictionary*)multiFetcherSync:(NSURL *)url
                        withHTTP:(NSString *) httpMethod
                        withData:(NSData *)requestData
                    withUserName:(NSString*) userName
                    withPassword:(NSString*) password
              communicationError:(NSError **) connError
          jsonSerializationError:(NSError **) jsonError;

@end
