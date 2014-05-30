//
//  ApuestasDataLoaderTableViewController.h
//  Flattened
//
//  Created by Diego Maye on 24/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "ApuestasTVController.h"

@interface ApuestasDataLoaderTableViewController : ApuestasTVController

@property(nonatomic,strong) NSString* idPenca;
@property(nonatomic,strong) NSNumber* idFecha;

-(void)fetchApuestas:(NSString *) idPenca andFecha:(NSString*)fecha;

@end
