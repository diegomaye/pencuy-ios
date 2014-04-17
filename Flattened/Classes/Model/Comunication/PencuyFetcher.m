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
#define PENCUY_URL @"http://pencuy-bohen.rhcloud.com/Pencuy-web/rest/"

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

@end
