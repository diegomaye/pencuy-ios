//
//  NSUserDefaults+Usuario.m
//  Flattened
//
//  Created by Diego Maye on 13/05/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "NSUserDefaults+Usuario.h"

@implementation NSUserDefaults (Usuario)

-(void) setUsuario:(Usuario*) usuario{
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:[usuario toDictionary]];
    [self setObject:myEncodedObject forKey:@"USUARIO-PENCA"];
}

-(Usuario *) getUsuario{
    NSData* userDefaultData = [self valueForKey:@"USUARIO-PENCA"];
    NSDictionary* userDefaultDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:userDefaultData];
    NSError* error;
    Usuario* usuarioPenca = [[Usuario alloc] initWithDictionary:userDefaultDictionary error:&error];
    if (usuarioPenca) {
        return usuarioPenca;
    }
    else{
        NSLog(@"Error al cargar usuario por defecto en singleton PencuyFetcher: %@", error);
        return nil;
    }
}

@end
