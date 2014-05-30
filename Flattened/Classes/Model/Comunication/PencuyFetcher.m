//
//  PencuyFetcher.m
//  Flattened
//
//  Created by Diego Maye on 15/01/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "PencuyFetcher.h"
#import "PencuyAPIKey.h"

@implementation PencuyFetcher

#define PENCUY_PUBLIC_API @"public/"
#define PENCUY_API @"api/"
    //#define PENCUY_URL @"http://localhost:8180/Pencuy-web/rest/"
#define PENCUY_URL @"http://192.168.0.100:8180/Pencuy-web/rest/"
    //#define PENCUY_URL @"http://162.243.34.210:8080/Pencuy-web/rest/"

+ (NSURL *)URLForQuery:(NSString *)query kindOf:(NSString *)kind
{
    query = [NSString stringWithFormat:@"%@%@%@",PENCUY_URL , kind, query];
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:query];
}

+ (NSURL *)URLAPIForQuery:(NSString *)query
{
    return [self URLForQuery:query kindOf:PENCUY_API];
}


+ (NSURL *)URLPublicForQuery:(NSString *)query
{
    return [self URLForQuery:query kindOf:PENCUY_PUBLIC_API];
}

#pragma mark Api Publica logueo y creacion de usuario

+ (NSURL *)URLtoCheckUser
{
    return [self URLPublicForQuery:[NSString stringWithFormat:@"usuario/checkUser/"]];
}

+ (NSURL *)URLtoActivateUser
{
    return [self URLPublicForQuery:[NSString stringWithFormat:@"usuario"]];
}

+ (NSURL *)URLtoCreateUser
{
    return [self URLPublicForQuery:[NSString stringWithFormat:@"usuario"]];
}

+ (NSURL *)URLtoCreateFaceUser{
    return [self URLPublicForQuery:[NSString stringWithFormat:@"usuario/face/"]];
}

+ (NSURL *)URLtoGetUserByFaceId:(NSString*)faceId{
    return [self URLPublicForQuery:[NSString stringWithFormat:@"usuario/face/%@", faceId]];
}

+ (NSURL *)URLtoLoginUser{
    return [self URLPublicForQuery:[NSString stringWithFormat:@"usuario"]];
}

+ (NSURL *)URLtoResetPassword{
    return [self URLPublicForQuery:[NSString stringWithFormat:@"usuario/resetPassword"]];
}

#pragma mark Api Privada para partidos

+ (NSURL *)URLtoQueryPartido:(NSString *)idPartido
{
    return [self URLAPIForQuery:[NSString stringWithFormat:@"partido/%@", idPartido]];
}

#pragma mark Api Privada para fechas

+ (NSURL *)URLtoQueryFechas:(NSString *)nombreCampeonato
{
    return [self URLAPIForQuery:[NSString stringWithFormat:@"fechaCampeonato/%@", nombreCampeonato]];
}

#pragma mark Api Privada para pencas
+ (NSURL *)URLAPIForPencaBrasil{
    return [self URLAPIForQuery:[NSString stringWithFormat:@"penca/brasil/"]];
}

#pragma mark Api Privada para apuestas

+ (NSURL *)URLtoQueryApuestasIdPenca:(NSString *)idPenca andEstado:(NSString *)estado
{
    return [self URLAPIForQuery:[NSString stringWithFormat:@"apuesta/%@/%@", idPenca, estado]];
}
+ (NSURL *)URLtoQueryApuestasIdPenca:(NSString *)idPenca andFecha:(NSString *)fecha
{
    return [self URLAPIForQuery:[NSString stringWithFormat:@"apuesta/fechas/%@/%@", idPenca, fecha]];
}
+ (NSURL *)URLtoMakeApuestas
{
    return [self URLAPIForQuery:[NSString stringWithFormat:@"apuesta/"]];
}

#pragma mark Api Privada para pencas

+ (NSURL *)URLtoQueryPencasActivas{
    return [self URLAPIForQuery:[NSString stringWithFormat:@"penca/ACTIVA"]];
}
+ (NSURL *)URLtoQueryPencas{
    return [self URLAPIForQuery:[NSString stringWithFormat:@"penca/"]];
}

#pragma mark Api Privada para invitaciones
+ (NSURL *)URLtoQueryInvitacionesByIdPenca:(NSString *) idPenca{
    return [self URLAPIForQuery:[NSString stringWithFormat:@"invitacion/penca/%@", idPenca]];
}
+ (NSURL *)URLtoQueryInvitaciones{
    return [self URLAPIForQuery:[NSString stringWithFormat:@"invitacion/"]];
}

#pragma mark Api Privada para alertas
+ (NSURL *)URLtoQueryAlertas{
    return [self URLAPIForQuery:[NSString stringWithFormat:@"alertas/"]];
}

#pragma mark Mutli Fetcher para creación dinamica de consultas.

+(void)multiFetcher:(NSURL *)url
           withHTTP:(NSString *)httpMethod
        withHandler:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError))callbackBlock{
    
    NSMutableURLRequest *urlRequest= [NSMutableURLRequest requestWithURL:url];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    Usuario* usuario= [defaults getUsuario];
    NSString *user= usuario.email;//[[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    NSString *pass= usuario.password;//[[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", user, pass];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [authData base64Encoding];
    
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:httpMethod];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
    
    NSOperationQueue *queue= [NSOperationQueue mainQueue];
        //[self.operationQueue cancelAllOperations];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:callbackBlock];
}

+(NSDictionary*)multiFetcherSync:(NSURL *)url
                        withHTTP:(NSString *) httpMethod
                        withData:(NSData *)requestData{
    NSURLResponse *response= nil;
    NSError *error= nil;
    NSMutableURLRequest *urlRequest= [NSMutableURLRequest requestWithURL:url];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    Usuario* usuario= [defaults getUsuario];
    NSString *user= usuario.email;//[[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    NSString *pass= usuario.password;//[[NSUserDefaults standardUserDefaults] valueForKey:@"password"];

    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", user, pass];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [authData base64Encoding];
    
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:httpMethod];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
    [urlRequest setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPBody: requestData];
    NSData *jsonResults= [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if (error) {
        NSLog(@" Error: %@ ", error);
    }
    return [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:NULL];
}


+(NSDictionary*)multiFetcherSyncPublic:(NSURL *)url
                              withHTTP:(NSString *) httpMethod
                              withData:(NSData *)requestData
                          withUserName:(NSString*) userName
                          withPassword:(NSString*) password
                    communicationError:(NSError **) connError
                jsonSerializationError:(NSError **) jsonError{
    NSURLResponse *response= nil;
    NSMutableURLRequest *urlRequest= [NSMutableURLRequest requestWithURL:url];
    
        //NSString *authStr = [NSString stringWithFormat:@"%@:%@", userName, password];
        //NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
        //NSString *authValue = [authData base64Encoding];
    
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:httpMethod];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        //[urlRequest setValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
    [urlRequest setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPBody: requestData];
    NSData *jsonResults= [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:connError];
    return [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:jsonError];
}


@end
