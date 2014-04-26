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
#define PENCUY_URL @"http://localhost:8180/Pencuy-web/rest/"

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
    return [self URLPublicForQuery:[NSString stringWithFormat:@"usuario"]];
}

+ (NSURL *)URLtoActivateUser
{
    return [self URLPublicForQuery:[NSString stringWithFormat:@"usuario"]];
}

+ (NSURL *)URLtoCreateUser
{
    return [self URLPublicForQuery:[NSString stringWithFormat:@"usuario"]];
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

+ (NSURL *)URLtoQueryApuestas:(NSString *)idPenca
{
    return [self URLAPIForQuery:[NSString stringWithFormat:@"apuesta/%@", idPenca]];
}
+ (NSURL *)URLtoMakeApuestas
{
    return [self URLAPIForQuery:[NSString stringWithFormat:@"apuesta/"]];
}

#pragma mark Mutli Fetcher para creación dinamica de consultas.

+(void)multiFetcher:(NSURL *)url
           withHTTP:(NSString *)httpMethod
        withHandler:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError))callbackBlock{
    
    NSMutableURLRequest *urlRequest= [NSMutableURLRequest requestWithURL:url];
    NSString *user= [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    NSString *pass= [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", user, pass];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [authData base64Encoding];
    
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:httpMethod];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setValue:[NSString stringWithFormat:@"Basic %@",authValue] forHTTPHeaderField:@"Authorization"];
    
    NSOperationQueue *queue= [NSOperationQueue new];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:callbackBlock];
}

+(NSDictionary*)multiFetcherSync:(NSURL *)url
                        withHTTP:(NSString *) httpMethod
                        withData:(NSData *)requestData{
    NSURLResponse *response= nil;
    NSError *error= nil;
    NSMutableURLRequest *urlRequest= [NSMutableURLRequest requestWithURL:url];
    NSString *user= [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    NSString *pass= [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    
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

@end
