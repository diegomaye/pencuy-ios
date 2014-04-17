//
//  PencuyFetcher.h
//  Flattened
//
//  Created by Diego Maye on 15/01/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PencuyFetcher : NSObject

+ (NSURL *)URLForQuery:(NSString *)query kindOf:(NSString *)kind;

+ (NSURL *)URLAPIForQuery:(NSString *)query;

+ (NSURL *)URLPublicForQuery:(NSString *)query;

#pragma mark Api Publica logueo y creacion de usuario

+ (NSURL *)URLtoCheckUser;
+ (NSURL *)URLtoActivateUser;
+ (NSURL *)URLtoCreateUser;

#pragma mark Api Privada para partidos
+ (NSURL *)URLtoQueryPartido:(NSString *)idPartido;

@end
