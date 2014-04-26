//
//  ApuestasDataLoaderTableViewController.h
//  Flattened
//
//  Created by Diego Maye on 24/04/14.
//  Copyright (c) 2014 AppDesignVault. All rights reserved.
//

#import "FixtureViewController.h"

@interface ApuestasDataLoaderTableViewController : FixtureViewController

@property(nonatomic,strong) NSString* idPenca;

-(void)fetchApuestas:(NSString *) idPenca;

@end
