//
//  NSUserDefaults+Usuario.h
//  Flattened
//
//  Created by Diego Maye on 13/05/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Usuario.h"
@interface NSUserDefaults (Usuario)

-(void) setUsuario:(Usuario*) usuario;
-(Usuario *) getUsuario;

@end
