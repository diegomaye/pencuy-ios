//
//  ApuestasCerradasDLTVController.h
//  Flattened
//
//  Created by Diego Maye on 28/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "ApuestasTVController.h"

@interface ApuestasHoyDLTVController : ApuestasTVController

@property(nonatomic,strong) NSString* idPenca;

-(void)fetchApuestas:(NSString *) idPenca;

@end
